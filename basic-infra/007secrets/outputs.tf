output "rds_secrets_arn" {
  value = module.rds_secrets.secret_arn
}

output "ec2_key_pair_name" {
  value = module.ec2_key_pair.key_pair_name
}

resource "local_file" "ec2_key_pair_pem" {
  content         = module.ec2_key_pair.private_key_pem
  filename        = "${path.module}/keys/ec2-key-pair-${var.env}.pem"
  file_permission = "0600"
}
