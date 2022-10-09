# terraform-localstack

A template for local terraform development with local stack


## Install requirements

This assumes you have python and pip installed for the moment and that pip executatables are in your path
This will likely not be needed when solution and pattern is finaliased but are needed for the moment


```bash
pip install -r requirements.txt
```

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


