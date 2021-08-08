#!/bin/sh
set -e

cd "$(dirname "$0")"

server=$1

if [ -z $server ]; then 
    echo "Usage: syncserver SERVERNAME"
    exit 1
fi

server_path="servers/$server"

echo "Checking dir $server_path exists"
mkdir -p $server_path

echo "Copying files"
rsync -avr -I --exclude='.*' --exclude='*.tfvars' --exclude='providers.tf' ./minecraft/ $server_path

if [ ! -e $server_path/providers.tf ]; then

cat > $server_path/providers.tf <<EOF
# Terraform and provider settings

terraform {
  backend "local" {
    path = "../../.state/servers/$server/terraform.tfstate"
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
EOF
fi

echo "Done files"