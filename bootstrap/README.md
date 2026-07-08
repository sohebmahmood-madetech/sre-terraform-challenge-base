# Bootstrap (run once, by a human)

Creates the three things CI needs before the pipelines can touch AWS:

1. A GitHub Actions **OIDC identity provider** in the AWS account.
2. A **deploy role** that only this GitHub repository can assume (PowerUserAccess
   plus IAM writes scoped to `sre-challenge-*` roles/instance profiles).
3. A versioned, encrypted **S3 bucket** for Terraform state.

No secrets are produced or stored anywhere — GitHub authenticates to AWS with
short-lived OIDC tokens.

## Prerequisites

- Access to the playground account via IAM Identity Center with permissions to
  create IAM providers/roles and S3 buckets (e.g. `AdministratorAccess`).
- AWS CLI configured for SSO:

  ```sh
  aws configure sso   # first time only; start URL: https://madetech.awsapps.com/start/
  aws sso login --profile <your-profile>
  export AWS_PROFILE=<your-profile>
  ```

## Apply

```sh
cd bootstrap
terraform init
terraform apply -var="github_repository=<owner>/<repo>"
```

State is written locally to `bootstrap/terraform.tfstate` (gitignored). Keep it
somewhere safe if you ever want to `terraform destroy` the bootstrap cleanly.

## Wire up GitHub

Take the three outputs and set them as **repository variables**
(Settings → Secrets and variables → Actions → Variables — these are not
secrets):

| Variable             | Output              |
| -------------------- | ------------------- |
| `AWS_DEPLOY_ROLE_ARN`| `deploy_role_arn`   |
| `TF_STATE_BUCKET`    | `state_bucket_name` |
| `AWS_REGION`         | `aws_region`        |

Until `AWS_DEPLOY_ROLE_ARN` is set, the deploy workflow skips itself, so the
repo is safe to use without any AWS wiring.
