variable "region" {
  type        = string
  description = "The region to deploy the infrastructure to"
}

variable "env" {
  type        = string
  description = "The environment to deploy the infrastructure to"
}

variable "domain_name" {
  type = string
}

variable "san_names" {
  type    = list(string)
  default = []
}

variable "cloudflare_account_id" {
  type        = string
  description = "The Cloudflare account ID"
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_zone_id" {
  type = string
}