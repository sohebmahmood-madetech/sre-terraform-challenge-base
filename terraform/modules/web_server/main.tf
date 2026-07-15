# Latest Amazon Linux 2023 AMI, resolved via the public SSM parameter so we
# never pin an AMI ID in code.
data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_security_group" "web" {
  name        = "${var.name}-sg"
  description = "Web server ingress/egress"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-sg"
  }
}

resource "aws_iam_role" "assets_read" {
  name = "sre-challenge-${var.name}-assets-read"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "sre-challenge-${var.name}-assets-read"
  }
}

resource "aws_iam_policy" "assets_read" {
  name = "sre-challenge-${var.name}-assets-read"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ListBucket"
        Effect = "Allow"
        Action = ["s3:ListBucket"]
        Resource = [
          var.assets_bucket_arn
        ]
      },
      {
        Sid    = "GetObject"
        Effect = "Allow"
        Action = ["s3:GetObject"]
        Resource = [
          "${var.assets_bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "assets_read" {
  role       = aws_iam_role.assets_read.name
  policy_arn = aws_iam_policy.assets_read.arn
}

resource "aws_iam_instance_profile" "assets_read" {
  name = "sre-challenge-${var.name}-assets-read"
  role = aws_iam_role.assets_read.name
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  for_each = toset(var.allowed_http_cidrs)

  security_group_id = aws_security_group.web.id
  description       = "HTTP from ${each.value}"
  cidr_ipv4         = each.value
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.web.id
  description       = "Allow all outbound"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "web" {
  ami                    = data.aws_ssm_parameter.al2023_ami.insecure_value
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web.id]
  iam_instance_profile   = aws_iam_instance_profile.assets_read.name

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    environment = var.environment
    web_message = var.web_message
  })
  user_data_replace_on_change = true

  metadata_options {
    http_tokens = "required" # enforce IMDSv2
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = true
  }

  tags = {
    Name = var.name
  }
}
