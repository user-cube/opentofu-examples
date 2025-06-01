# ALB Security Group
module "alb_sg" {
  for_each = {
    public = ["http-80-tcp", "https-443-tcp"]
  }

  source = "terraform-aws-modules/security-group/aws"

  name        = "alb-sg-${each.key}-secgroup.${var.region}.${var.env}"
  description = "Security group allowing access to ${each.key} ALB"
  vpc_id      = data.aws_vpc.vpc-id.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = each.value

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    description = "Security group allowing access to ${each.key} ALB"
    region      = var.region
    managed_by  = "OpenTofu"
    environment = var.env
    type        = "security-group"
  }
}

# RDS Security Group
module "rds_sg" {
  for_each = {
    rds = ["postgresql-tcp"]
  }

  source = "terraform-aws-modules/security-group/aws"

  name        = "rds-sg-${var.env}-secgroup.${var.region}.${var.env}"
  description = "Security group allowing access to RDS"
  vpc_id      = data.aws_vpc.vpc-id.id

  egress_rules = [] # Deny all outbound traffic

  tags = {
    description = "Security group allowing access to RDS"
    region      = var.region
    managed_by  = "OpenTofu"
    environment = var.env
    type        = "security-group"
  }
}

# EC2 Security Group
module "ec2_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ec2-sg-${var.env}-secgroup.${var.region}.${var.env}"
  description = "Security group allowing access to EC2"
  vpc_id      = data.aws_vpc.vpc-id.id

  ingress_with_source_security_group_id = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      source_security_group_id = module.alb_sg["public"].security_group_id
      description              = "Allow HTTP from ALB"
    },
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      source_security_group_id = module.alb_sg["public"].security_group_id
      description              = "Allow HTTPS from ALB"
    }
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    description = "Security group allowing access to EC2"
    region      = var.region
    managed_by  = "OpenTofu"
    environment = var.env
    type        = "security-group"
  }
}
