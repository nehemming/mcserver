# Server output variables
output "server_public_ip" {
  value = hcloud_server.server.ipv4_address
}

output "minecraft_address" {
  value = format("%s:%s",
    var.dns_enabled ? format("%s.%s", var.server_name, var.dns_zone) : hcloud_server.server.ipv4_address,
  var.minecraft_public_port)
}