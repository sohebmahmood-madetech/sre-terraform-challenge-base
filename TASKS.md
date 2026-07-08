# SRE Challenge Tasks

Two exercises, sized to test the edit → validate → push → PR loop in a CDE
workspace. Work on a branch and open a pull request for each — the `Validate`
workflow must pass, and if AWS is wired up the `Deploy` workflow will post a
plan on your PR and apply on merge.

Useful commands inside the workspace:

```sh
cd terraform
terraform init -backend=false   # offline init, enough for validate
terraform fmt -recursive
terraform validate
tflint --recursive              # run from the repo root
```

---

## Task 1 (small): configurable landing-page message

The landing page currently shows a fixed sentence. The team wants each
deployment to display its own message without editing the HTML template.

**Do this:**

1. Add a `web_message` variable to the root module
   (`terraform/variables.tf`) with a sensible default, e.g.
   `"Provisioned with Terraform."`.
2. Thread it through the `web_server` module: a new module variable, passed in
   from `terraform/main.tf`, and rendered on the page via the
   `user_data.sh.tpl` template (replace the hard-coded sentence).

**Acceptance criteria:**

- `terraform fmt -check -recursive`, `terraform validate` and `tflint` all pass
  (the Validate workflow is green on your PR).
- The message is *not* hard-coded anywhere except as a variable default.
- Variable descriptions are filled in.
- If deployed: the page at `web_url` shows your message.

*Expected size: ~4 small edits across 4 files.*

---

## Task 2 (medium): assets bucket with instance read access

Feature request: the web server needs somewhere to pull static assets from.
Add a private S3 bucket and give the instance read-only access to it.

**Do this:**

1. Create a new local module `terraform/modules/assets_bucket` that provisions:
   - an S3 bucket named `<project_name>-assets-<account id>` (use
     `data.aws_caller_identity`),
   - versioning enabled,
   - server-side encryption,
   - all public access blocked.
2. Instantiate it from the root module and add a `assets_bucket_name` output.
3. Give the EC2 instance read-only access to that bucket:
   - an IAM role **named with the `sre-challenge-` prefix** (the CI deploy role
     may only manage IAM resources with this prefix),
   - an inline or attached policy allowing `s3:GetObject` / `s3:ListBucket`
     on this bucket only,
   - an instance profile attached to the instance in the `web_server` module.

**Acceptance criteria:**

- Validate workflow green (fmt, validate, tflint, trivy).
- The bucket is not publicly accessible and the policy grants read-only access
  to this one bucket — no `s3:*`, no `Resource = "*"`.
- The module has its own `variables.tf` / `outputs.tf` with descriptions.
- If deployed: `aws s3 ls s3://$(terraform output -raw assets_bucket_name)`
  succeeds from the instance (e.g. via SSM session) and the state stays clean
  on a second `terraform plan` (no drift).

*Expected size: 1 new module (~3 files) + edits to the root and web_server
modules.*
