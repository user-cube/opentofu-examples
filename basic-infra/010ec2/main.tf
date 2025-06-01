locals {
  ec2_instances = {
    one = {
      instance_type = "t3.small"
      ami_id        = "ami-084568db4383264d4"
    }
    two = {
      instance_type = "t3.small"
      ami_id        = "ami-084568db4383264d4"
    }
  }
}

# IAM Role for SSM
resource "aws_iam_role" "ssm_role" {
  name = "ec2-session-manager-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm-instance-profile-${var.env}"
  role = aws_iam_role.ssm_role.name
}

# EC2 Instances using shared config
module "ec2_instance" {
  source   = "terraform-aws-modules/ec2-instance/aws"
  for_each = local.ec2_instances

  name                 = "instance-${each.key}"
  instance_type        = each.value.instance_type
  ami                  = each.value.ami_id
  monitoring           = true
  key_name             = null
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
  vpc_security_group_ids = [
    data.terraform_remote_state.terraform_state["security-groups"].outputs.ec2_security_group_ids
  ]

  tags = {
    Name        = "ec2-${each.key}-${var.env}"
    region      = var.region
    environment = var.env
    managed_by  = "OpenTofu"
    type        = "ec2"
  }
}

# Shared Target Group for all EC2 instances
resource "aws_lb_target_group" "app_tg" {
  name             = "tg-${var.env}"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = data.aws_vpc.vpc-id.id

  health_check {
    enabled = true
    path    = "/"
    matcher = "200"
  }

  tags = {
    Name        = "tg-${var.env}"
    region      = var.region
    environment = var.env
    managed_by  = "OpenTofu"
    type        = "tg"
  }
}

# Attach all EC2 instances to the shared TG
resource "aws_lb_target_group_attachment" "app_tg_attachment" {
  for_each = module.ec2_instance

  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = each.value.id
  port             = 80
}

# Forward all traffic from HTTPS listener to the shared TG
resource "aws_lb_listener_rule" "forward_all" {
  listener_arn = data.terraform_remote_state.terraform_state["alb"].outputs.alb_listener_arn # HTTPS listener ARN
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }

  condition {
    host_header {
      values = ["tests.${var.domain}"]
    }
  }

  tags = {
    Name        = "listener-rule-${var.env}"
    region      = var.region
    environment = var.env
    managed_by  = "OpenTofu"
    type        = "listener-rule"
  }
}
