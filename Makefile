# Makefile

# ------------------------------------------------------------
# USER VARIABLES
# ------------------------------------------------------------

IS_LOCAL ?= true
DEBUG    ?= false

TERRAFORM_STATE_LOCAL=true
TERRAFORM_WORKSPACE=localstack
TERRAFORM_MODULE=localstack
TERRAFORM_DIRECTORY=terraform

export DNS_ADDRESS=0 # fixes localstack pro issue
export LOCALSTACK_API_KEY=1f13YQ76Dj
export LAMBDA_EXECUTOR=local
export MAIN_CONTAINER_NAME=localstack_main
export AWS_SECRET_ACCESS_KEY="mock_access_key"
export AWS_ACCESS_KEY_ID="mock_secret_key"
export DEFAULT_REGION="ap-southeast-2" # For localstack Config

# ------------------------------------------------------------
# DERIVED VARIABLES
# ------------------------------------------------------------

TERRAFORM_ARGS := $(DEBUG) $(IS_LOCAL) $(TERRAFORM_STATE_LOCAL) $(TERRAFORM_WORKSPACE) $(TERRAFORM_MODULE) $(TERRAFORM_DIRECTORY)

# ------------------------------------------------------------
# LOCAL DEVELOPMENT TARGETS
# ------------------------------------------------------------

up:
	#localstack start -d
	docker-compose up --detach localstack

down:
	#localstack stop
	docker-compose down

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

all: up apply test destroy down
all-up: up apply test
all-down: up apply test down
all-clean: up apply test down clean

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
	sudo rm -rf terraform/localstack/localstack_providers_override.tf
	docker system prune -af

todo:
	@echo "[ INFO ] List of Files with TODO's left" 
	@grep -rl --exclude Makefile "PKD-TODO:"

logs:
	localstack logs

PHONY: up all-up all-clean all-down down init validate workspace plan apply destroy show all test logs clean todo
