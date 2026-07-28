# SRE Terraform Challenge

A small but realistic Terraform project used to evaluate Cloud Development
Environments (Coder, Ona, Bunnyshell, …) with SREs. It provisions a tiny web
stack in an AWS playground account and ships everything an SRE needs to work
on it from a CDE workspace: devcontainer tooling, editor integrations, CI
validation and an OIDC-authenticated deploy pipeline.

**The exercises live in [TASKS.md](TASKS.md).**

## What it deploys
No Op Change

```
VPC (10.42.0.0/16)
└── public subnet ── internet gateway
    └── EC2 (t3.micro, Amazon Linux 2023, nginx)   ← modules/web_server
        └── security group: HTTP in, all out
```

Outputs `web_url` — a static landing page proving the stack is up.

## Repository layout

| Path                  | Purpose                                                        |
| --------------------- | -------------------------------------------------------------- |
| `terraform/`          | The playground stack (this is where the exercises happen)      |
| `terraform/modules/`  | Local modules (`web_server`)                                   |
| `bootstrap/`          | One-time setup: OIDC provider, deploy role, state bucket       |
| `.devcontainer/`      | CDE/devcontainer image, tooling and editor setup               |
| `.github/workflows/`  | `validate.yml` (lint/validate) and `deploy.yml` (plan/apply)   |
| `TASKS.md`            | The SRE exercises                                              |

## Working in the CDE workspace

The devcontainer ships with: Terraform, terraform-ls, tflint, trivy,
terraform-docs, AWS CLI, GitHub CLI, Node, Claude Code, Neovim.

- **VS Code** — extensions are installed automatically: HashiCorp Terraform
  (format-on-save is preconfigured), GitHub Copilot + Chat, GitHub Pull
  Requests, GitHub Actions, Claude Code.
- **Neovim** — a baseline config with terraform-ls (go-to-def, hover, rename,
  format-on-save) is installed *only if you don't bring your own*; point your
  CDE's dotfiles feature at your own repo and it stays untouched.
- **Auth** — nothing is baked in:
  - GitHub: most CDEs inject a token; otherwise `gh auth login`.
  - Copilot: sign in via the VS Code extension, or `gh extension install
    github/gh-copilot` for the CLI.
  - Claude Code: run `claude` and authenticate, or have the CDE inject
    `ANTHROPIC_API_KEY`.
  - AWS (optional, for local plans): `aws configure sso` against your
    Identity Center start URL, then `aws sso login`.

Everyday loop:

```sh
cd terraform
terraform init -backend=false   # no AWS access needed
terraform fmt -recursive && terraform validate
tflint --recursive              # from repo root
```

## CI

- **Validate** (`validate.yml`) — on every PR and push to main:
  `terraform fmt -check`, `terraform validate` (both root modules), `tflint`,
  and a trivy misconfiguration scan (HIGH/CRITICAL block; deliberate
  playground exceptions are documented in `.trivyignore`).
- **Deploy** (`deploy.yml`) — plans on PRs touching `terraform/`, applies on
  merge to main, and supports manual plan/apply/**destroy** via *Run
  workflow*. Authenticates with short-lived OIDC tokens — no stored AWS
  credentials. Skips itself entirely until the repo variables below exist.

## One-time AWS setup

See [bootstrap/README.md](bootstrap/README.md). In short: run
`terraform apply` in `bootstrap/` once with your SSO credentials, then set
three **repository variables** (not secrets) from its outputs:
`AWS_DEPLOY_ROLE_ARN`, `TF_STATE_BUCKET`, `AWS_REGION`.

Optionally create a GitHub *environment* named `playground` with required
reviewers to gate applies/destroys.

## Security posture

- No secrets, state files or `.tfvars` in the repo (enforced by `.gitignore`);
  backend config and credentials are injected at runtime.
- CI → AWS via OIDC only; the deploy role's IAM write access is scoped to
  `sre-challenge-*` resources.
- Instance enforces IMDSv2 and an encrypted root volume.
