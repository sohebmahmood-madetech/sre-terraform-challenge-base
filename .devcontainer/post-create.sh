#!/usr/bin/env bash
# Runs once after the devcontainer is created.
set -uo pipefail

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> Installing tflint rulesets"
(cd "$WORKSPACE_DIR" && tflint --init) || echo "WARN: tflint --init failed (offline?); run it manually later"

echo "==> Enabling terraform tab-completion"
terraform -install-autocomplete 2>/dev/null || true

echo "==> Setting up baseline Neovim config (skipped if you already have one)"
if [ ! -e "$HOME/.config/nvim/init.lua" ]; then
    mkdir -p "$HOME/.config/nvim"
    cp "$WORKSPACE_DIR/.devcontainer/nvim/init.lua" "$HOME/.config/nvim/init.lua"
fi

# GitHub Copilot on the CLI (only works once `gh auth login` has happened —
# in most CDEs a GitHub token is already injected).
if gh auth status >/dev/null 2>&1; then
    echo "==> Installing gh-copilot extension"
    gh extension install github/gh-copilot 2>/dev/null || true
else
    echo "==> gh not authenticated yet; run 'gh auth login' then 'gh extension install github/gh-copilot'"
fi

echo "==> Done. Tool versions:"
terraform version | head -1
tflint --version | head -1
terraform-ls version | head -1
trivy --version | head -1
nvim --version | head -1
aws --version
gh --version | head -1
claude --version 2>/dev/null || echo "claude: installed, run 'claude' to authenticate"
