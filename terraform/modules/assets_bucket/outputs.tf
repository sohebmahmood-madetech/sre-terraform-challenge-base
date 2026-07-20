# CHANGE LOG:
# - Created: 2026-07-20
# - Purpose: Output the S3 bucket name for reference in root configuration

output "assets_bucket_name" {
  description = "Name of the S3 assets bucket"
  value       = aws_s3_bucket.assets.bucket
}

output "assets_bucket_arn" {
  description = "ARN of the S3 assets bucket"
  value       = aws_s3_bucket.assets.arn
}

output "assets_bucket_id" {
  description = "ID of the S3 assets bucket"
  value       = aws_s3_bucket.assets.id
}
