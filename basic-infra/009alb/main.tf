module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.16.0"

  name    = "alb-${var.env}-${var.region}"
  vpc_id  = data.aws_vpc.vpc-id.id
  subnets = data.aws_subnets.public-subnets.ids

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = true
  enable_http2                     = true

  security_groups = [data.terraform_remote_state.terraform_state["security-groups"].outputs.alb_security_group_ids["public"]]


  access_logs = {
    bucket = data.terraform_remote_state.terraform_state["s3"].outputs.s3_bucket_for_logs_id
    prefix = "alb-${var.env}-${var.region}"
  }

  listeners = {
    http-default = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    https-default = {
      port            = 443
      protocol        = "HTTPS"
      action_type     = "fixed-response"
      certificate_arn = data.terraform_remote_state.terraform_state["acm"].outputs.acm_certificate_arn
      fixed_response = {
        content_type = "text/plain"
        status_code  = "404"
      }
    }
  }

  tags = {
    description = "ALB for ${var.env}"
    region      = var.region
    managed_by  = "OpenTofu"
    environment = var.env
    type        = "alb"
  }
}
