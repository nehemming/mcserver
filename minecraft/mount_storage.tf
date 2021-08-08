# Mount storage volume onto server

# Find the volume by name
data "hcloud_volume" "store" {
  name = var.storage_name
}

locals {
  storage_volume_id    = data.hcloud_volume.store.id
  storage_linux_device = data.hcloud_volume.store.linux_device
}

# Attach the volume to the server
resource "hcloud_volume_attachment" "store" {
  volume_id = local.storage_volume_id
  server_id = hcloud_server.server.id
  automount = false
}

# Attach the storage to the server so that it auto mounts
# hcloud_volume_attachment automount above is false to allow the correct
# mount point to be specified
resource "null_resource" "attach_store" {
  triggers = {
    ipv4_address = hcloud_server.server.ipv4_address
    unmount_script = templatefile("${path.module}/resources/unmount.sh",
      {
        linux_device = local.storage_linux_device,
        mountpoint   = var.storage_mountpoint,
        volume_id    = local.storage_volume_id,
    })
  }

  depends_on = [
    hcloud_volume_attachment.store
  ]

  connection {
    host  = self.triggers.ipv4_address
    user  = "root"
    agent = true
  }

  provisioner "remote-exec" {
    when = destroy
    inline = [<<EOF
      ${self.triggers.unmount_script}
EOF
    ]
  }

  provisioner "remote-exec" {
    inline = [templatefile("${path.module}/resources/mount.sh",
      {
        linux_device = local.storage_linux_device,
        mountpoint   = var.storage_mountpoint,
        format       = var.storage_format,
        volume_id    = local.storage_volume_id,
    })]
  }
}