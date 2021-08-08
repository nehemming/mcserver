# Terraform and provider settings
terraform {
  backend "local" {
    path = "../.state/dnszone/terraform.tfstate"
  }
  required_providers {
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = "1.1.0"
    }
  }
  required_version = ">= 0.13"
}

variable "hetznerdns_token" {
  description = "Hetzner DNS API Token"
  type        = string
  sensitive   = true
}

provider "hetznerdns" {
  apitoken = var.hetznerdns_token
}