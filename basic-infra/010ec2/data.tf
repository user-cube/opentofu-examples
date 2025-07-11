data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc-id" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_subnets" "private-subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc-id.id]
  }
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}-private-*"]
  }
}

# Access terraform state to get security groups
data "terraform_remote_state" "terraform_state" {
  for_each = toset(
    [
      "security-groups",
      "secrets",
      "alb"
    ]
  )
  backend = "s3"
  config = {
    bucket = "992382848249-opentofu-state-bucket"
    key    = "us-east-1/basic-infra/${each.value}"
    region = "us-east-1"
  }
}
