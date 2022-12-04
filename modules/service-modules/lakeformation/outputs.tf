# outputs.tf

output "aws_lakeformation_data_lake_settings" {
  description = "LakeFormation Settings"
  value       = aws_lakeformation_data_lake_settings.this
}

output "aws_lakeformation_resource" {
  description = "LakeFormation Settings"
  value       = aws_lakeformation_resource.this
}
