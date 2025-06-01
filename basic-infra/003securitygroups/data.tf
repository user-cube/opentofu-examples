data "aws_caller_identity" "current" {
}

data "aws_vpc" "vpc-id" {
  tags = {
    Name = var.vpc_name
  }
}
