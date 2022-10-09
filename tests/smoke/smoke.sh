#!/bin/bash

# Description: A Simple Smoke test to test the SNS > SQS > Lambda > S3 solution

echo "[ :$(basename "$0"): ] Executing $0"

RUNNER="awslocal"
ENDPOINT="http://localhost:4566"
TOPIC_ARN="arn:aws:sns:ap-southeast-2:000000000000:pkd-sandbox-apse2-events"
BUCKET="pkd-sandbox-apse2-ingest"
OBJECT="test"
MESSAGE='{"Name" : "Paul"}'
REGION="ap-southeast-2"
TIME=12 # each 1 = 5 seconds


export AWS_PAGER=""
export AWS_ACCESS_KEY_ID="fake"
export AWS_SECRET_ACCESS_KEY="fake"
export AWS_DEFAULT_REGION="ap-southeast-2"

echo "[ INFO ] Posting Message to SNS Topic" 

$RUNNER sns publish --topic-arn $TOPIC_ARN --message "$MESSAGE" --region $REGION #2> /dev/null

echo "[ INFO ] Checking S3 for Processed Message Object" 

ATTEMPT=1

# PKD-TODO: Need to validate contents of the file = message

while [ $ATTEMPT -le $TIME ]
do
    echo "[ INFO ] Checking for S3 Object $OBJECT ... Attempt $ATTEMPT/$TIME"

    $RUNNER s3 ls s3://$BUCKET/$OBJECT --region $REGION 2> /dev/null

    if [ $? -eq 0 ]; then
        echo "[ SUCCESS ] Smoke Test completed"
        exit 0
    else
        ATTEMPT=$(( $ATTEMPT + 1 ))
        sleep 5
    fi
done

echo "[ ERROR ] Smoke Test failed"
