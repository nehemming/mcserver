# Terraform and provider settings

terraform {
  backend "local" {
    path = "../.state/minecraft/terraform.tfstate"
  }
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.26"
    }
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = "1.1.0"
    }
  }
  required_version = ">= 0.13"
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

variable "hetznerdns_token" {
  description = "Hetzner DNS API Token"
  type        = string
  sensitive   = true
}

provider "hetznerdns" {
  apitoken = var.hetznerdns_token
}