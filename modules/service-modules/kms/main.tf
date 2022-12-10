# main.tf

# -------------------------------------------------
# TODO
# -------------------------------------------------
# - aws_kms_ciphertest
# - aws_kms_custom_key_store
# - aws_kms_external_key
# - aws_kms_grant
# - aws_kms_key
# - aws_kms_replica_external_key
# - aws_kms_replica_key

# -------------------------------------------------
# Resources
# -------------------------------------------------

resource "aws_kms_alias" "this" {
  name          = var.name
  target_key_id = var.target_key_id != null ? var.target_key_id : aws_kms_key.this.key_id
}

resource "aws_kms_key" "this" {}
