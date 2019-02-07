#!/bin/bash
#-----------------------------------------------------------------------------------
#    Shell Script create VPC on AWS EC2 using aws-cli commands
#-----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
# What this SHELL script do ?
#    
#1.Create a Virtual Private Cloud (VPC).
#2.Create subnets in your VPC. You must create 3 subnets, each in different availability zone in the same region under same VPC.
#3.Create Internet Gateway resource.
#4.Attach the Internet Gateway to the created VPC.
#5.Create a public Route Table. Attach all subnets created above to the route table.
#6.Create a public route in the public route table created above with destination CIDR block 0.0.0.0/0 and internet gateway creted above as the target.
#7.Modify the default security group for your VPC to remove existing rules and add new rules to only allow TCP traffic on port 22 and 80 from anywhere.
#------------------------------------------------------------------------------------


if [ $# -eq 0 ]; then
echo "Scrip required one command line argument. Please pass <stack_name>"
echo "Ex : sh csye6225-aws-networking-setup.sh <stack_name>"
exit 1
fi

REGION="us-east-1"
vpcName="$1-csye6225-vpc-1"
internetGatewayName="$1-csye6225-InternetGateway-1"
vpc_cidr="10.0.0.0/16"
publicRouteTableName="$1-csye6225-public-route-table"
ZONE1="us-east-1a"
ZONE2="us-east-1b"
ZONE3="us-east-1c"
PublicSubnet1="$1-csye-public-subnet-1"
PublicSubnet2="$1-csye-public-subnet-2"
PublicSubnet3="$1-csye-public-subnet-3"
default_ip="0.0.0.0/0"
security_group="$1-csye6225-security_group"



#--------------------------------------------------------------------------------------------------
# Step1 : Create a Virtual Private Cloud (VPC)
#-------------------------------------------------------------------------------------------------
echo -e "\n"
echo "--------------------------------------------------------------------------------------------"
echo "Step1 : Create a Virtual Private Cloud (VPC)"
echo "--------------------------------------------------------------------------------------------"
VPC_ID=$(aws ec2 create-vpc \
  --cidr-block $vpc_cidr \
  --query 'Vpc.{VpcId:VpcId}' \
  --output text \
  --region $REGION)
  #--region $REGION 2>&1)
VPC_CREATE_STATUS=$?
echo "VPC creation status : '$VPC_CREATE_STATUS'"

if [ $VPC_CREATE_STATUS -eq 0 ]; then
  echo " VPC ID '$VPC_ID' Created in '$REGION' region."
else
	echo "##########Error:VPC creation command failed, check command status code!!"
  echo " $VPC_ID "
	exit $VPC_CREATE_STATUS
fi

# Rename VPC using aws create-tags command 
echo -e "\n"
echo "Rename VPC using aws create-tags command"
VPC_RENAME=$(aws ec2 create-tags \
  --resources $VPC_ID \
  --tags "Key=Name,Value=$vpcName" \
  --region $REGION 2>&1)
VPC_RENAME_STATUS=$?
if [ $VPC_RENAME_STATUS -eq 0 ]; then
  echo "  VPC ID '$VPC_ID' Renamed/Tagged To '$vpcName'."
else
    echo "##########Error: VPC name tagging command failed check command status code!!"
    echo " $VPC_RENAME "
    exit $VPC_RENAME_STATUS
fi

#--------------------------------------------------------------------------------------------------
#Step2: Create subnets in your VPC. You must create 3 subnets, each in different availability zone in the same region under same VPC.
#--------------------------------------------------------------------------------------------------
echo -e "\n"
echo "-------------------------------------------------------------------------------------------------------------------------------------"
echo "Step2: Create subnets in your VPC. You must create 3 subnets, each in different availability zone in the same region under same VPC."
echo "-------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\n"
echo "Please provide IP Address for subnet 1 in x.x.x.x/x"
read CIDR_BLOCK

#echo "Please provide Availability zones for Public subnet 1"
PUBLIC_SUBNET_1=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $CIDR_BLOCK \
  --availability-zone $ZONE1 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $REGION)

echo  "Subnet ID '$PUBLIC_SUBNET_1' is created in '$ZONE1'" "Availability Zone."

# Rename Public Subnet 1
echo -e "\n"
echo "RENAME PUBLIC SUBNET 1"
SUBNET_RENAME=$(aws ec2 create-tags \
  --resources $PUBLIC_SUBNET_1 \
  --tags "Key=Name,Value=$PublicSubnet1" 2>&1)
SUBNET_RENAME_STATUS=$?
if [ $SUBNET_RENAME_STATUS -eq 0 ]; then
  echo "Public Subnet ID '$PUBLIC_SUBNET_1' NAMED as '$PublicSubnet1'."
else
    echo "Error:PublicSubnet1 name not added!!"
    echo " $SUBNET_RENAME "
    exit $SUBNET_RENAME_STATUS
fi

echo -e "\n"
echo "Please provide IP Address for Public subnet 2 in x.x.x.x/x"
read CIDR_BLOCK

#echo "Please provide Availability zones for Public subnet 2"
PUBLIC_SUBNET_2=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $CIDR_BLOCK \
  --availability-zone $ZONE2 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $REGION)

echo  "Subnet ID '$PUBLIC_SUBNET_2' is created in '$ZONE2'" "Availability Zone."

# Rename Public Subnet 2
echo -e "\n"
echo "RENAME PUBLIC SUBNET 2"
SUBNET_RENAME=$(aws ec2 create-tags \
  --resources $PUBLIC_SUBNET_2 \
  --tags "Key=Name,Value=$PublicSubnet2" 2>&1)
SUBNET_RENAME_STATUS=$?
if [ $SUBNET_RENAME_STATUS -eq 0 ]; then
  echo "Public Subnet ID '$PUBLIC_SUBNET_2' NAMED as '$PublicSubnet2'."
else
    echo "Error:PublicSubnet2 name not added!!"
    echo " $SUBNET_RENAME "
    exit $SUBNET_RENAME_STATUS
fi


echo -e "\n"
echo "Please provide IP Address for Public subnet 3 in x.x.x.x/x"
read CIDR_BLOCK

# echo "Please provide Availability zones for Public subnet 3"
PUBLIC_SUBNET_3=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $CIDR_BLOCK \
  --availability-zone $ZONE3 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $REGION)

echo  "Subnet ID '$PUBLIC_SUBNET_3' is created in '$ZONE3'" "Availability Zone."

# Rename Public Subnet 3
echo -e "\n"
echo "RENAME PUBLIC SUBNET 3"
SUBNET_RENAME=$(aws ec2 create-tags \
  --resources $PUBLIC_SUBNET_3 \
  --tags "Key=Name,Value=$PublicSubnet3" 2>&1)
SUBNET_RENAME_STATUS=$?
if [ $SUBNET_RENAME_STATUS -eq 0 ]; then
  echo "Public Subnet ID '$PUBLIC_SUBNET_3' NAMED as '$PublicSubnet3'."
else
    echo "Error:PublicSubnet3 name not added!!"
    echo " $SUBNET_RENAME "
    exit $SUBNET_RENAME_STATUS
fi

