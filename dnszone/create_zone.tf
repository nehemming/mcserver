# Creates a DNS Zone in HETZNER and attached the NS records for the ZONE
resource "hetznerdns_zone" "dns_zone" {
  name = var.dns_zone
  ttl  = var.dns_ttl
}

locals {
  dns_zone_id = hetznerdns_zone.dns_zone.id
}

# Create a record per HETZNER DNS Nameserver
resource "hetznerdns_record" "nameserver" {
  for_each = { for o in var.dns_nameservers : o => o }
  zone_id  = local.dns_zone_id
  name     = "@"
  value    = each.key
  type     = "NS"
  ttl      = var.dns_ttl
}

# Add in any additional records, such as mail servers etc
resource "hetznerdns_record" "dns_record" {
  for_each = { for o in var.dns_records : format("%s/%s", o.type, o.name) => o }
  zone_id  = local.dns_zone_id
  name     = each.value.name
  value    = each.value.value
  type     = each.value.type
  ttl      = var.dns_ttl
}



