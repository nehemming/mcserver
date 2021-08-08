# Terraform and provider settings

terraform {
  backend "local" {
    path = "../.state/storage/terraform.tfstate"
  }
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.26"
    }
  }
}

variable "hcloud_token" {
  description = "Hetzner API Token"
  type        = string
  sensitive   = true
}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

