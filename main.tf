provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

resource "aws_s3_bucket" "tf_states" {
  bucket = var.bucket_name

  lifecycle {
    # This would help not delete this bucket throw terraform
    ## Important because if we delete it, we delete all terraform states
    prevent_destroy = true
  }
}

data "aws_iam_policy_document" "tf_states_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.tf_states.arn]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.tf_states.arn}/${var.tf_state_path_key}"]
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "tf_states_policy" {
  name        = var.bucket_policy
  description = "${var.bucket_name} policy."
  policy      = data.aws_iam_policy_document.tf_states_policy.json
}

resource "aws_iam_policy_attachment" "policy_current_user_attachment" {
  name       = "${var.bucket_policy}-attachment"
  users      = [data.aws_caller_identity.current.user_id]
  policy_arn = aws_iam_policy.tf_states_policy.arn
}

resource "aws_s3_bucket_acl" "tf_states_acl" {
  bucket = aws_s3_bucket.tf_states.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "tf_states_versioning" {
  bucket = aws_s3_bucket.tf_states.id
  versioning_configuration {
    status = "Enabled"
  }
}

# To enable buket objects server side encryption
# This would help to hide sensitives information in
# all terraform states in the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_states_sse" {
  bucket = aws_s3_bucket.tf_states.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Setup of our locking mechanism with Dynamo DB
# This locking step would ensure only one user can
# edit terraform state (in other word run terraform apply)
# at a given time. This ensures terraform state consistancy
resource "aws_dynamodb_table" "tf_states_locks" {
  name         = var.terrafom_db_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.table_lock_id

  attribute {
    name = var.table_lock_id
    type = "S"
  }
}
