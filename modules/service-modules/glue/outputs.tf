# outputs.tf

output "aws_glue_catalog_database" {
  description = "Glue Database"
  value       = aws_glue_catalog_database.this
}

output "aws_glue_catalog_table" {
  description = "Glue Database"
  value       = aws_glue_catalog_table.this
}
