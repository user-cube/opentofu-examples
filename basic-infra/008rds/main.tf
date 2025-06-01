locals {
  rds = {
    prod-rds = {
      engine_version          = "15"
      family                  = "postgres15"
      major_engine_version    = "15"
      instance_class          = "db.t3.small"
      allocated_storage       = "20"
      max_allocated_storage   = "30"
      multi_az                = false # Usually this is enabled, currently disable because i'm deploying this using KodeKloud
      replicate_snapshot      = true
      maintenance_window      = "Sun:00:00-Sun:03:00"
      backup_window           = "03:00-06:00"
      backup_retention_period = 1
    }
  }
}
module "db" {
  for_each = local.rds
  source   = "terraform-aws-modules/rds/aws"

  identifier          = "postgres-db-${lower(var.env)}"
  snapshot_identifier = try(each.value.snapshot_identifier, null)

  engine               = "postgres"
  engine_version       = each.value.engine_version
  family               = each.value.family
  major_engine_version = each.value.major_engine_version
  instance_class       = each.value.instance_class

  allocated_storage     = each.value.allocated_storage
  max_allocated_storage = each.value.max_allocated_storage
  storage_encrypted     = true

  username                    = "rds_master"
  manage_master_user_password = false
  password                    = data.aws_secretsmanager_secret_version.rds_secrets.secret_string

  port = 5432

  multi_az = each.value.multi_az

  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.private-subnets.ids
  vpc_security_group_ids = [data.terraform_remote_state.terraform_state["security-groups"].outputs.rds_security_group_ids["rds"]]

  maintenance_window              = each.value.maintenance_window
  backup_window                   = each.value.backup_window
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  backup_retention_period = each.value.backup_retention_period
  skip_final_snapshot     = true
  deletion_protection     = false

  copy_tags_to_snapshot       = true
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = false
  apply_immediately           = true

  # Custom parameter group
  create_db_parameter_group = false # Usually this is enabled, currently disable because i'm deploying this using KodeKloud

  performance_insights_enabled          = false # Usually this is enabled, currently disable because i'm deploying this using KodeKloud
  performance_insights_retention_period = 7
  create_monitoring_role                = false # Usually this is enabled, currently disable because i'm deploying this using KodeKloud
  # monitoring_role_name                  = "monitoring-role-rds-${each.key}-${var.region}-${var.env}" # Usually this is enabled, currently disable because i'm deploying this using KodeKloud
  # monitoring_interval                   = 60 # Usually this is enabled, currently disable because i'm deploying this using KodeKloud

  tags = {
    description = "RDS for ${var.env}"
    region      = var.region
    managed_by  = "OpenTofu"
    environment = var.env
    type        = "rds"
  }
}
