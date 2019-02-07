#!/bin/bash
#-----------------------------------------------------------------------------------
#    Shell Script to Delete The VPC
#-----------------------------------------------------------------------------------
#
#
# DESCRIPTION
# 1) Deletes the VPC created
# 2) Deletes the Subnet created in the VPC
# 3) Deletes the Internet Gateway created
# 4) Deletes the Route Table
# 5) Deletes the Custom Security Group

region="us-east-1"
security_Group="$1-csye6225-security_group"

if [ $# -eq 0 ]; then
	echo " PLEASE PASS <STACK_NAME> as parameter "
	exit 1
fi


# Getting VPC Name
echo -e "\n"
echo "-----GETTING THE VPC NAME-----"
vpc="$1-csye6225-vpc-1"
vpcName=$(aws ec2 describe-vpcs \
	--query "Vpcs[?Tags[?Key=='Name']|[?Value=='$vpc']].Tags[0].Value" \
	--output text)
echo $vpcName

# Getting VPC ID
echo -e "\n"
echo "-----GETTING VPC ID------"
vpc_Id=$(aws ec2 describe-vpcs \
	--query 'Vpcs[*].{VpcId:VpcId}' \
	--filters Name=is-default,Values=false \
	--output text \
 	--region $region)
echo $vpc_Id

# Getting Internet-Gateway-Id
echo -e "\n"
echo "------GETTING INTERNET GATEWAY ID------"
internetGateway_Id=$(aws ec2 describe-internet-gateways \
 	--query 'InternetGateways[*].{InternetGatewayId:InternetGatewayId}' \
 	--filters "Name=attachment.vpc-id,Values=$vpc_Id" \
 	--output text)
echo $internetGateway_Id

# Getting Route-Table-Id
echo -e "\n"
echo "-----GETTING ROUTE-TABLE ID-----"
route_Table_Id=$(aws ec2 describe-route-tables \
	--filters "Name=vpc-id,Values=$vpc_Id" "Name=association.main, Values=false" \
	--query 'RouteTables[*].{RouteTableId:RouteTableId}' \
	--output text)

route_Table_Id1=${route_Table_Id}

echo "First Route-Table ID: '$route_Table_Id1'"


