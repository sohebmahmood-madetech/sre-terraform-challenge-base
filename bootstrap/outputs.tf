output "deploy_role_arn" {
  description = "Set as the AWS_DEPLOY_ROLE_ARN repository variable in GitHub."
  value       = aws_iam_role.deploy.arn
}

output "state_bucket_name" {
  description = "Set as the TF_STATE_BUCKET repository variable in GitHub."
  value       = aws_s3_bucket.state.bucket
}

output "aws_region" {
  description = "Set as the AWS_REGION repository variable in GitHub."
  value       = var.aws_region
}
