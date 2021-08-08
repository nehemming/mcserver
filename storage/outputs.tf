# Storage output variables
output "storage_volume_id" {
  value = hcloud_volume.store.id
}

output "storage_linux_device" {
  value = hcloud_volume.store.linux_device
}

