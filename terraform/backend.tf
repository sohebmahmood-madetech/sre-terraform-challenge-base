# Backend configuration is injected at init time so no account-specific
# values live in the repo:
#
#   terraform init \
#     -backend-config="bucket=<state-bucket-name>" \
#     -backend-config="key=sre-terraform-challenge/terraform.tfstate" \
#     -backend-config="region=<aws-region>" \
#     -backend-config="use_lockfile=true"
#
# For local experiments without the remote backend, run:
#   terraform init -backend=false && terraform validate
terraform {
  backend "s3" {}
}
