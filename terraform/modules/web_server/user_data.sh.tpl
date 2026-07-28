#!/usr/bin/env bash
set -euo pipefail

dnf install -y nginx

cat > /usr/share/nginx/html/index.html <<'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>SRE Terraform Challenge</title>
  <style>
    body { font-family: sans-serif; max-width: 40rem; margin: 4rem auto; }
    code { background: #eee; padding: 0.1rem 0.3rem; border-radius: 3px; }
  </style>
</head>
<body>
  <h1>SRE Terraform Challenge</h1>
  <p>Environment: <code>${environment}</code></p>
  <p>This page is served by an EC2 instance provisioned with Terraform.</p>
  <p>Environment: <code>${web_message}</code></p>
</body>
</html>
HTML

systemctl enable --now nginx
