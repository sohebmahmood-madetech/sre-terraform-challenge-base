terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Bootstrap state is intentionally local (and gitignored). This config is
  # applied once by a human with SSO credentials, not by CI.
  backend "local" {}
}
