locals {
  unique_validation_records = [
    for record in var.domain_validation_options :
    {
      name    = record.resource_record_name
      type    = record.resource_record_type
      content = record.resource_record_value
    }
  ]

  # Actually remove duplicates based on name+type+content
  deduplicated_records = distinct(local.unique_validation_records)
}

resource "cloudflare_record" "validation" {
  count = length(local.deduplicated_records)

  zone_id = var.zone_id
  name    = local.deduplicated_records[count.index].name
  type    = local.deduplicated_records[count.index].type
  content = local.deduplicated_records[count.index].content
  ttl     = 300
  proxied = false
  allow_overwrite = true
}