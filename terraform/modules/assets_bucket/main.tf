data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "assets" {
  bucket = "${var.project_name}-assets-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "${var.project_name}-assets"
  }
}

resource "aws_s3_bucket" "assets_logs" {
  bucket = "${var.project_name}-assets-logs-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "${var.project_name}-assets-logs"
  }
}

resource "aws_s3_bucket_versioning" "assets" {
  bucket = aws_s3_bucket.assets.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "assets" {
  bucket = aws_s3_bucket.assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "assets_logs" {
  bucket = aws_s3_bucket.assets_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "assets_logs" {
  bucket = aws_s3_bucket.assets_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "assets_logs" {
  bucket = aws_s3_bucket.assets_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "assets" {
  bucket        = aws_s3_bucket.assets.id
  target_bucket = aws_s3_bucket.assets_logs.id
  target_prefix = "logs/"
}

resource "aws_s3_bucket_logging" "assets_logs" {
  bucket        = aws_s3_bucket.assets_logs.id
  target_bucket = aws_s3_bucket.assets_logs.id
  target_prefix = "access-logs/"
}
