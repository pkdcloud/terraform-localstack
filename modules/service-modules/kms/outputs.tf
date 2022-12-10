# outputs.tf

# -------------------------------------------------
# Outputs - KMS Key Alias
# -------------------------------------------------

output "alias_full" {
  description = "(VERBOSE) Full export of the resource."
  value       = aws_kms_alias.this
}

output "alias_arn" {
  description = "The Amazon Resource Name (ARN) of the key alias."
  value       = aws_kms_alias.this.arn
}

output "alias_target_key_arn" {
  description = "The Amazon Resource Name (ARN) of the target key identifier."
  value       = aws_kms_alias.this.target_key_arn
}

# -------------------------------------------------
# Outputs - KMS Key
# -------------------------------------------------

output "key_full" {
  description = "(VERBOSE) Full export of the resource."
  value       = aws_kms_key.this
}

output "key_arn" {
  description = "The Amazon Resource Name (ARN) of the key alias."
  value       = aws_kms_key.this.arn
}

output "key_id" {
  description = "The globally unique identifier for the key."
  value       = aws_kms_key.this.key_id
}

output "key_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_kms_key.this.tags_all
}
