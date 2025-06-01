module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = var.san_names

  create_route53_records = false
  wait_for_validation    = false

  tags = {
    Name = "ACM Cert for ${var.domain_name}"
  }
}