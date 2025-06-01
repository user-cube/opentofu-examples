variable "region" {
  type        = string
  description = "The region to deploy the infrastructure to"
}

variable "bucket_name" {
  type        = string
  description = "The name of the state bucket"
}

variable "env" {
  type        = string
  description = "The environment to deploy the infrastructure to"
}