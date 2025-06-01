output "alb_arn" {
  value = module.alb.arn
}

output "alb_dns_name" {
  value = module.alb.dns_name
}

output "alb_zone_id" {
  value = module.alb.zone_id
}

output "alb_listener_arn" {
  value = module.alb.listeners["https-default"].arn
}
