# CHANGE LOG:
# - Created: 2026-07-20
# - Purpose: S3 bucket module for asset storage with security controls
# - Features: Versioning, encryption, public access blocking

# Data source to retrieve current AWS account ID
data "aws_caller_identity" "current" {}

# S3 bucket with naming convention: {project_name}-assets-{account_id}
resource "aws_s3_bucket" "assets" {
  bucket = "${var.project_name}-assets-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name    = "${var.project_name}-assets"
    Purpose = "Asset storage"
  }
}

# Enable versioning on the bucket
resource "aws_s3_bucket_versioning" "assets" {
  bucket = aws_s3_bucket.assets.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Customer-managed KMS key for S3 encryption
resource "aws_kms_key" "s3" {
  description = "${var.project_name} S3 CMK"
  tags = {
    Name    = "${var.project_name}-s3-cmk"
    Purpose = "S3 CMK"
  }
}

# Enable server-side encryption with AWS KMS (customer managed key)
resource "aws_s3_bucket_server_side_encryption_configuration" "assets" {
  bucket = aws_s3_bucket.assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3.arn
    }
  }
}

# Block all public access to the bucket for security
resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
