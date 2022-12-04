# Makefile

# ------------------------------------------------------------
# USER VARIABLES
# ------------------------------------------------------------

IS_LOCAL   ?= true
DEBUG      ?= false
AWS_REGION ?= ap-southeast-2

TERRAFORM_STATE_LOCAL=true
TERRAFORM_WORKSPACE=localstack
TERRAFORM_MODULE=localstack
TERRAFORM_DIRECTORY=terraform

# ------------------------------------------------------------
# RUNNERS
# ------------------------------------------------------------

COMPOSE_RUNNER=docker compose

export DNS_ADDRESS=0 # fixes localstack pro issue
#export LOCALSTACK_API_KEY=xxxxxxxxx # this needs to happen
export LAMBDA_EXECUTOR=local
export MAIN_CONTAINER_NAME=localstack_main
export AWS_SECRET_ACCESS_KEY=mock_access_key
export AWS_ACCESS_KEY_ID=mock_secret_key
export AWS_DEFAULT_REGION=ap-southeast-2 # For localstack tflocal provider override. It defaults to us-east-1 without this in place.

# ------------------------------------------------------------
# DERIVED VARIABLES
# ------------------------------------------------------------

TERRAFORM_ARGS := $(DEBUG) $(IS_LOCAL) $(TERRAFORM_STATE_LOCAL) $(TERRAFORM_WORKSPACE) $(TERRAFORM_MODULE) $(TERRAFORM_DIRECTORY)

# ------------------------------------------------------------
# LOCAL DEVELOPMENT TARGETS
# ------------------------------------------------------------

up:
	#localstack start -d
	$(COMPOSE_RUNNER) up --detach localstack

down:
	#localstack stop
	$(COMPOSE_RUNNER) down

# ------------------------------------------------------------
# TERRAFORM TARGETS
# ------------------------------------------------------------

init: up
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

all: plan apply destroy

# ------------------------------------------------------------
# TERRAFORM TESTS
# ------------------------------------------------------------

test:
	tests/smoke/smoke.sh $(TERRAFORM_WORKSPACE) $(IS_LOCAL) $(AWS_REGION)

# ------------------------------------------------------------
# UTILITY HELPERS
# ------------------------------------------------------------

clean: down
	sudo rm -rf terraform/localstack/.terraform.lock.hcl
	sudo rm -rf terraform/localstack/.terraform
	sudo rm -rf terraform/localstack/terraform.tfstate.d
	sudo rm -rf terraform/localstack/files
	sudo rm -rf terraform/localstack/localstack_providers_override.tf
	docker system prune -af

todo:
	@echo "[ INFO ] List of Files with TODO's left" 
	@grep -rl --exclude Makefile "PKD-TODO:"

logs:
	localstack logs

PHONY: up all-up all-clean all-down down init validate workspace plan apply destroy show all test logs clean todo
