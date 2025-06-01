data "aws_caller_identity" "current" {
}

# Get domain validation options from terraform state
data "terraform_remote_state" "terraform_state" {
  backend = "s3"
  config = {
    bucket = "992382848249-opentofu-state-bucket"
    key    = "us-east-1/basic-infra/acm"
    region = "us-east-1"
  }
}