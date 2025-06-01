output "rds_outputs" {
  value = {
    for k, v in module.db : k => {
      rds_instance_arn     = v.db_instance_arn
      rds_instance_domain  = v.db_instance_domain
      rds_instance_port    = v.db_instance_port
      rds_instance_address = v.db_instance_address
      rds_instance_name    = v.db_instance_name
      rds_instance_port    = v.db_instance_port
    }
  }
}
