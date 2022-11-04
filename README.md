# terraform-localstack

A template for local terraform development with local stack


## Install requirements

This assumes you have python and pip installed for the moment and that pip executatables are in your path
This will likely not be needed when solution and pattern is finaliased but are needed for the moment


```bash
pip install -r requirements.txt
```

## Copy a file
awslocal s3 cp README.md s3://localstack-ingest/test

## Test a file is there
awslocal s3 ls s3://localstack-ingest/test

## Delete a File
awslocal s3 rm s3://localstack-ingest/test

## Read File

awslocal s3 cp s3://localstack-ingest/test - | printf "\n"


## SQS Get Message

awslocal sqs receive-message --queue-url http://localhost:4566/000000000000/localhost-events

## Raw Message Extraction

awslocal s3 cp s3://localstack-ingest/test - | jq -r '.Records[].body' | jq -r .Message | jq

# add to path 

export PATH="$HOME/.local/bin:$PATH" # localstack
export DEFAULT_REGION=ap-southeast-2
<!-- export LAMBDA_EXECUTOR=local
export MAIN_CONTAINER_NAME=localstack_main
export AWS_SECRET_ACCESS_KEY="mock_access_key"
export AWS_ACCESS_KEY_ID="mock_secret_key"
export AWS_DEFAULT_REGION="ap-southeast-2"

export DEBUG=0
 -->

local web app pro

https://app.localstack.cloud/dashboard
