# Makefile

# ------------------------------------------------------------
# USER VARIABLES
# ------------------------------------------------------------

IS_LOCAL ?= true
DEBUG    ?= false

TERRAFORM_STATE_LOCAL=true
TERRAFORM_WORKSPACE=pkd-sandbox-apse2
TERRAFORM_MODULE=localstack
TERRAFORM_DIRECTORY=terraform

export LAMBDA_EXECUTOR=local
export MAIN_CONTAINER_NAME=localstack_main
export AWS_SECRET_ACCESS_KEY="mock_access_key"
export AWS_ACCESS_KEY_ID="mock_secret_key"
export DEFAULT_REGION="ap-southeast-2"
export DEBUG=1
# ------------------------------------------------------------
# DERIVED VARIABLES
# ------------------------------------------------------------

TERRAFORM_ARGS := $(DEBUG) $(IS_LOCAL) $(TERRAFORM_STATE_LOCAL) $(TERRAFORM_WORKSPACE) $(TERRAFORM_MODULE) $(TERRAFORM_DIRECTORY)

# ------------------------------------------------------------
# LOCAL DEVELOPMENT TARGETS
# ------------------------------------------------------------

up:
	localstack start -d
	#docker-compose up --detach localstack

down:
	localstack stop
	#docker-compose down

# ------------------------------------------------------------
# TERRAFORM TARGETS
# ------------------------------------------------------------

init:
	ops/terraform init $(TERRAFORM_ARGS)

validate:
	ops/terraform validate $(TERRAFORM_ARGS)

workspace: init
	ops/terraform workspace $(TERRAFORM_ARGS)

plan: workspace
	ops/terraform plan $(TERRAFORM_ARGS)

apply: workspace
	ops/terraform apply $(TERRAFORM_ARGS)

destroy: workspace
	ops/terraform destroy $(TERRAFORM_ARGS)

show: workspace
	ops/terraform show $(TERRAFORM_ARGS)

all: up apply test #logs down

# ------------------------------------------------------------
# TERRAFORM TESTS
# ------------------------------------------------------------

test:
	tests/smoke/smoke.sh

# ------------------------------------------------------------
# UTILITY HELPERS
# ------------------------------------------------------------

clean:
	sudo rm -rf terraform/localstack/.terraform.lock.hcl
	sudo rm -rf terraform/localstack/.terraform
	sudo rm -rf terraform/localstack/terraform.tfstate.d
	sudo rm -rf terraform/localstack/files
	docker system prune -af

todo:
	@echo "[ INFO ] List of Files with TODO's left" 
	@grep -rl --exclude Makefile "PKD-TODO:"

logs:
	localstack logs

PHONY: up down init validate workspace plan apply destroy show all test logs clean todo
