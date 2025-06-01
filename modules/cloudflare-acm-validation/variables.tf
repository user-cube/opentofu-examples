variable "domain_validation_options" {
  description = "Domain validation options from ACM module"
  type = list(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
}

variable "zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
}