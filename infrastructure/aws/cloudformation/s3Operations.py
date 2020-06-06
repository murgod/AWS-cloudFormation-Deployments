import logging
import boto3
from botocore.exceptions import ClientError

class s3Operations(object):
    def __init__(self):
        self.s3_client = boto3.client('s3')


    def create_bucket(self, bucket_name, region=None):
        try:
            if region is None:
                self.s3_client.create_bucket(Bucket=bucket_name)
            else:
                self.s3_client = boto3.client('s3', region_name=region)
                location = {'LocationConstraint': region}
                self.s3_client.create_bucket(Bucket=bucket_name,
                                    CreateBucketConfiguration=location)
        except ClientError as e:
            logging.error(e)
            return False
        return True

    def listBuckets(self):
        try:
            res = self.s3_client.list_buckets()
            for bucket in res['Buckets']:
                    print(bucket['Name'])
        except ClientError as e:
            logging.error(e)
            return false
        
        return True

    def checkIfBucketExists(self, bucket_name):
        try:
            res = self.s3_client.list_buckets()
            for bucket in res['Buckets']:
                if bucket['Name'] == bucket_name:
                    logging.error("Bucket already exits")
                    return True
        except ClientError as e:
            logging.error(e)
            return False




print("Module to create S3 bucket and enable versioning on it")

bucket_name = input("Enter bicker name :")
bucket_name = bucket_name.strip()

s3Object = s3Operations()

if s3Object.checkIfBucketExists(bucket_name): #If bucket already exists, tag it with DATE. bucket_name+"Date"
    s3Object.create_bucket(bucket_name)

s3Object.listBuckets()



