#!/bin/bash

# Description: A Simple Smoke test to test the SNS > SQS > Lambda > S3 solution

echo "[ :$(basename "$0"): ] Executing $0 $1 $2"

TERRAFORM_WORKSPACE=$1
IS_LOCAL=$2
AWS_REGION=$3

ENDPOINT="http://localhost:4566"
TOPIC_ARN="arn:aws:sns:$AWS_REGION:000000000000:$TERRAFORM_WORKSPACE-events.fifo"
BUCKET="$TERRAFORM_WORKSPACE-ingest"
OBJECT="test"
MESSAGE='{"Name" : "Paul"}'
REGION="ap-southeast-2"
TIME=12 # each 1 = 5 seconds

if [[ $IS_LOCAL == true ]]
then
    echo "[ INFO ] Running Tests against Localstack"
    RUNNER="awslocal"
else
    echo "[ INFO ] Running Tests in AWS"
    RUNNER="aws" 
fi

echo "[ INFO ] Posting Message to SNS Topic" 

$RUNNER sns publish --topic-arn $TOPIC_ARN --message "$MESSAGE" --region $REGION #2> /dev/null

# echo "[ INFO ] Checking S3 for Processed Message Object" 

# ATTEMPT=1

# # PKD-TODO: Need to validate contents of the file = message

# while [ $ATTEMPT -le $TIME ]
# do
#     echo "[ INFO ] Checking for S3 Object $OBJECT ... Attempt $ATTEMPT/$TIME"

#     $RUNNER s3 ls s3://$BUCKET/$OBJECT --region $REGION 2> /dev/null

#     if [ $? -eq 0 ]; then
#         echo "[ SUCCESS ] Smoke Test completed"
#         exit 0
#     else
#         ATTEMPT=$(( $ATTEMPT + 1 ))
#         sleep 5
#     fi
# done

# echo "[ ERROR ] Smoke Test failed"
