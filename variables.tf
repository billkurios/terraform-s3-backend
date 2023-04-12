variable "bucket_name" {
  description = "Name of the s3 bucket to create"
  type        = string
  default     = "terraform-states"
}

variable "tf_state_path_key" {
  description = "Terraform state path key in the s3 terraform states bucket"
  type        = string
  default     = "global/s3-backend/terraform.tfstate"
}

variable "bucket_policy" {
  description = "Bucket policy name"
  type        = string
  default     = "terraform-states-policy"
}

variable "terrafom_db_table_name" {
  description = "Name of the dynamo DB table used for locking mechanism"
  type        = string
  default     = "terraform-states-locking"
}

variable "table_lock_id" {
  description = "Dynamo DB Table Lock ID attribute"
  type        = string
  default     = "LockID"
}

variable "aws_profile" {
  description = "AWS profile configures and uses by terraform"
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "AWS region where terraform should create these ressources."
  type        = string
  default     = "us-east-1"
}