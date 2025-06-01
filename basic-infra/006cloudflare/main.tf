module "cf_dns_validation" {
  source     = "../../modules/cloudflare-acm-validation"

  domain_validation_options = data.terraform_remote_state.terraform_state.outputs.acm_certificate_domain_validation_options
  zone_id                   = var.cloudflare_zone_id
}