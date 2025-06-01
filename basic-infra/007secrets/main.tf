module "rds_secrets" {
  source = "terraform-aws-modules/secrets-manager/aws"

  # Secret
  name                    = "rds-master-password-${var.env}"
  description             = "Database credentials"
  recovery_window_in_days = 30

  # Version
  create_random_password           = true
  random_password_length           = 64
  random_password_override_special = "!@#"

  tags = {
    description = "Secrets Manager for ${var.env}"
    region      = var.region
    managed_by  = "OpenTofu"
    environment = var.env
    type        = "secrets-manager"
  }
}

module "ec2_key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "~> 2.1.0"

  key_name           = "ec2-key-pair-${var.env}"
  create_private_key = true


  tags = {
    description = "EC2 key pair for ${var.env}"
    region      = var.region
    managed_by  = "OpenTofu"
  }
}
