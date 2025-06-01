output "bucket_name" {
  value = module.state_bucket.s3_bucket_id
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.tofu_locks.name
}