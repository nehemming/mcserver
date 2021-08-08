# Create a persistent volume to store data

resource "hcloud_volume" "store" {
  name     = var.storage_name
  size     = var.storage_size
  location = var.storage_location
  format   = var.storage_format
}
