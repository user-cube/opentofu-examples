terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    encrypt = true
    bucket  = "992382848249-opentofu-state-bucket"
    key     = "us-east-1/basic-infra/vpc"
    region  = "us-east-1"
  }
}
