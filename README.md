# terraform-localstack

A template for local terraform development with local stack

## Copy a file
aws --endpoint http://localhost:4566 s3 cp README.md s3://pkd-sandbox-apse2-ingest/test

## Test a file is there
aws --endpoint http://localhost:4566 s3 ls s3://pkd-sandbox-apse2-ingest/test

## Delete a File
aws --endpoint http://localhost:4566 s3 rm s3://pkd-sandbox-apse2-ingest/test

## Read File

aws --endpoint http://localhost:4566 s3 cp s3://pkd-sandbox-apse2-ingest/test - | printf "\n"


## SQS Get Message

aws --endpoint http://localhost:4566 sqs receive-message --queue-url http://localhost:4566/000000000000/pkd-sandbox-apse2-events


# add to path 

export PATH="$HOME/.local/bin:$PATH"
export LAMBDA_EXECUTOR=local
export MAIN_CONTAINER_NAME=localstack_main
export AWS_SECRET_ACCESS_KEY="mock_access_key"
export AWS_ACCESS_KEY_ID="mock_secret_key"
export AWS_DEFAULT_REGION="ap-southeast-2"
export DEFAULT_REGION="ap-southeast-2"
export DEBUG=1

