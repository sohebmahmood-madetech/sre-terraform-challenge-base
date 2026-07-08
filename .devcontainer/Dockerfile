FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG TARGETARCH

# Base packages + HashiCorp apt repo (for terraform-ls, used by the Neovim LSP
# setup; the terraform binary itself comes from the devcontainer feature).
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl gnupg lsb-release unzip jq ripgrep fd-find bash-completion \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg \
        | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
        > /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends terraform-ls \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Neovim (stable release tarball — the Ubuntu package lags too far behind)
RUN NVIM_ARCH=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "x86_64") \
    && curl -fsSL -o /tmp/nvim.tar.gz \
        "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz" \
    && tar -xzf /tmp/nvim.tar.gz -C /opt \
    && ln -s /opt/nvim-linux-${NVIM_ARCH}/bin/nvim /usr/local/bin/nvim \
    && rm /tmp/nvim.tar.gz

# Trivy (IaC/security scanning — same tool the CI pipeline runs)
RUN curl -fsSL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
    | sh -s -- -b /usr/local/bin

USER vscode
