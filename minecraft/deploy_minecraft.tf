# Deploy Minecraft to the server using docker compose

locals {
  # where te game data will be stored on the server
  data_folder = format("%s/%s", var.storage_mountpoint, var.minecraft_folder)

  # world folder
  world_folder = format("%s/%s/world", var.storage_mountpoint, var.minecraft_folder)

  # local folder when any mods uploaded will be copied from
  mods_folder = format("%s/%s/", path.module, var.minecraft_mods_folder)

  # datapack folder
  datapack_folder = format("%s/%s/", path.module, var.minecraft_datapack_folder)

  # white listed playes in comma seperated list
  whitelist = join(",", var.minecraft_whitelist)

  # minecraft ops
  opslist = length(var.minecraft_opslist) == 0 ? join(",", var.minecraft_whitelist) : join(", ", var.minecraft_opslist)
}

# Deploy minecraft to server and run
resource "null_resource" "deploy_minecraft" {

  depends_on = [
    null_resource.provision_server
  ]

  triggers = {
    ipv4_address               = hcloud_server.server.ipv4_address
    sha                        = sha1(file("${path.module}/resources/docker-compose.yml"))
    minecraft_public_port      = var.minecraft_public_port
    minecraft_server_name      = var.server_name
    minecraft_settings         = sha1(jsonencode(var.minecraft_settings))
    minecraft_enable_rcon      = var.minecraft_enable_rcon
    minecraft_rcon_password    = sha1(var.minecraft_rcon_password)
    minecraft_rcon_public_port = var.minecraft_rcon_public_port
    minecraft_whitelist        = sha1(jsonencode(local.whitelist))
    minecraft_opslist          = sha1(jsonencode(local.opslist))
    mods_folder                = sha1(jsonencode(fileset(local.mods_folder, "*")))
    datapacks_folder           = sha1(jsonencode(fileset(local.datapack_folder, "*")))
    sha_install_datapacks      = sha1(file("${path.module}/resources/install_datapacks.sh"))
    server_mods_folder         = var.server_mods_folder
  }

  connection {
    host  = self.triggers.ipv4_address
    user  = "root"
    agent = true
  }

  # try to close server on destroy
  provisioner "remote-exec" {
    when = destroy
    inline = [
      "docker-compose down || true"
    ]
  }

  # Reset server mods import folder
  provisioner "remote-exec" {
    inline = [
      "rm -rf ${var.server_mods_folder}*",
      "mkdir -p ${var.server_mods_folder}",
      "rm -rf ${var.server_datapack_folder}*",
      "mkdir -p ${var.server_datapack_folder}"
    ]
  }

  # Copy the mods to the server from the local mods folder
  provisioner "file" {
    source      = local.mods_folder
    destination = var.server_mods_folder
  }

  # Copy the mods to the server from the local datapack folder
  provisioner "file" {
    source      = local.datapack_folder
    destination = var.server_datapack_folder
  }

  # copy the compose file to the server
  provisioner "file" {
    content = templatefile("${path.module}/resources/docker-compose.yml",
      {
        minecraft_public_port      = var.minecraft_public_port
        minecraft_data_folder      = local.data_folder
        minecraft_server_name      = var.server_name
        minecraft_settings         = var.minecraft_settings
        minecraft_enable_rcon      = var.minecraft_enable_rcon
        minecraft_rcon_password    = var.minecraft_rcon_password
        minecraft_rcon_public_port = var.minecraft_rcon_public_port
        whitelist                  = local.whitelist
        opslist                    = local.opslist
        server_mods_folder         = var.server_mods_folder
    })
    destination = "/root/docker-compose.yml"
  }

  # Install datapacks
  provisioner "remote-exec" {
    inline = [templatefile("${path.module}/resources/install_datapacks.sh",
      {
        server_datapack_folder = var.server_datapack_folder
        world_folder           = local.world_folder
    })]
  }

  # start the server, added a pre pull to ensure the serveer
  # is kept up to date with the main image
  provisioner "remote-exec" {
    inline = [
      "docker-compose pull",
      "docker-compose up -d"
    ]
  }
}