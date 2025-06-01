output "alb_security_group_ids" {
  value = { for k, v in module.alb_sg : k => v.security_group_id }
}

output "rds_security_group_ids" {
  value = { for k, v in module.rds_sg : k => v.security_group_id }
}

output "ec2_security_group_ids" {
  value = module.ec2_sg.security_group_id
}
