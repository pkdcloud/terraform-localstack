# outputs.tf

output "settings_full" {
  description = "(VERBOSE) Full export of the resource."
  value       = aws_lakeformation_data_lake_settings.this
}

output "resources_full" {
  description = "(VERBOSE) Full export of the resource."
  value       = aws_lakeformation_resource.this
}

# TODO: Iterate over these

# output "resources_last_modified" {
#   description = "The date and time the resource was last modified in RFC 3339 format."
#   value       = aws_lakeformation_resource.this.last_modified
# }

# output "lakeformation_tags" {
#   description = "Catalog ID and key-name of the tag."
#   value       = aws_lakeformation_lf_tag.this.id
# }
