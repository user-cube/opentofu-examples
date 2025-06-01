variable "region" {
  type        = string
  description = "The region to deploy the infrastructure to"
}

variable "env" {
  type        = string
  description = "The environment to deploy the infrastructure to"
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
}

variable "domain" {
  type        = string
  description = "The domain to deploy the infrastructure to"
}
