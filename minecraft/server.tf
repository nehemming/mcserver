# Server provissioning, creates the server and installs key packages

# Install the server
resource "hcloud_server" "server" {
  name        = var.server_name
  location    = var.server_location
  image       = var.server_image
  server_type = var.server_type
  ssh_keys    = var.server_ssh_keys
  backups     = var.server_backups
}

# Provision the server 
resource "null_resource" "provision_server" {
  triggers = {
    ipv4_address               = hcloud_server.server.ipv4_address
    sha                        = sha1(file("${path.module}/resources/provision.sh"))
    minecraft_public_port      = var.minecraft_public_port
    minecraft_enable_rcon      = var.minecraft_enable_rcon
    minecraft_rcon_public_port = var.minecraft_rcon_public_port
  }

  connection {
    host  = self.triggers.ipv4_address
    user  = "root"
    agent = true
  }

  # Provision packages
  provisioner "remote-exec" {
    inline = [templatefile("${path.module}/resources/provision.sh",
      {
        ip_address                 = hcloud_server.server.ipv4_address
        server_timezone            = var.server_timezone
        minecraft_public_port      = var.minecraft_public_port
        minecraft_enable_rcon      = var.minecraft_enable_rcon
        minecraft_rcon_public_port = var.minecraft_rcon_public_port
    })]
  }

  # Setup automated security updates
  provisioner "file" {
    source      = "${path.module}/resources/10periodic.conf"
    destination = "/etc/apt/apt.conf.d/10periodic"
  }
}