# Provides support for DNS registration of the server
# Get the DNS Zone details (use the dnszone tf scripts to create)
data "hetznerdns_zone" "dns_zone" {
  count = var.dns_enabled ? 1 : 0
  name  = var.dns_zone
}

locals {
  dns_zone_id = var.dns_enabled ? data.hetznerdns_zone.dns_zone[0].id : 0
  server_fqdn = "${var.server_name}.${var.dns_zone}"
}

# Add in reverse DNS lookup from server to ip
resource "hcloud_rdns" "server_rdns" {
  depends_on = [
    null_resource.deploy_minecraft
  ]
  count      = var.dns_enabled ? 1 : 0
  server_id  = hcloud_server.server.id
  ip_address = hcloud_server.server.ipv4_address
  dns_ptr    = local.server_fqdn
}

# Register the server with an A record
resource "hetznerdns_record" "server_name" {
  depends_on = [
    null_resource.deploy_minecraft
  ]
  count   = var.dns_enabled ? 1 : 0
  zone_id = local.dns_zone_id
  name    = var.server_name
  value   = hcloud_server.server.ipv4_address
  type    = "A"
  ttl     = var.dns_ttl
}

locals {
  dns_records = var.dns_enabled ? var.dns_records : []
}

# Register any additional server specific DNS rules
# The value element will expand $(IP) with the servers ip address and
# $(NAME) with the servers name (i.e. its sub domain not the fqdn)
resource "hetznerdns_record" "dns_record" {
  depends_on = [
    null_resource.deploy_minecraft
  ]
  for_each = { for o in local.dns_records : format("%s/%s", o.type, o.name) => o }
  zone_id  = local.dns_zone_id
  name     = each.value.name
  value = replace(
    replace(each.value.value, "$(IP)", hcloud_server.server.ipv4_address),
  "$(NAME)", var.server_name)
  type = each.value.type
  ttl  = var.dns_ttl
}


