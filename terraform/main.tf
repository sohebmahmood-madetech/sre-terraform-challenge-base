module "assets_bucket" {
  source       = "./modules/assets_bucket"
  project_name = var.project_name
}

module "web_server" {
  source = "./modules/web_server"

  name               = "${var.project_name}-web"
  vpc_id             = aws_vpc.main.id
  subnet_id          = aws_subnet.public.id
  instance_type      = var.instance_type
  allowed_http_cidrs = var.allowed_http_cidrs
  environment        = var.environment
  web_message        = var.web_message

  assets_bucket_arn  = module.assets_bucket.assets_bucket_arn
  assets_bucket_name = module.assets_bucket.assets_bucket_name
}
