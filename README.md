# Terraform S3 Backend
Terraform project to store remotely terraform states of all futures projects in an S3 bucket. Dynamo table is used for locking access to more than one user at time on a terraform state (in s3).


