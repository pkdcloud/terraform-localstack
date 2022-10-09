# index.py

import json
import boto3
import os

def lambda_handler(event, context):
    client = boto3.client('s3', region_name='ap-southeast-2', endpoint_url='http://localhost:4566')
    client.put_object(Body=json.dumps(event), Bucket=os.environ['S3_BUCKET_NAME'], Key='test')
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
