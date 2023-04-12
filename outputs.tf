output "caller_user" {
  description = "Terraform caller user"
  value       = data.aws_caller_identity.current.user_id
}

output "s3_bucket" {
  description = "Terraform bucket Id"
  value       = aws_s3_bucket.tf_states.bucket
}