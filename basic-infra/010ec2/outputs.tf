output "ec2_instance_ids" {
  value = { for k, v in module.ec2_instance : k => v.id }
}
