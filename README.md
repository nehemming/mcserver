# mcserver

Terraform scripts to run a Minecraft server on a HETZNER Cloud server.  

## Cloud based Minecraft Server

This project contains Terraform scripts that create a Minecraft server using HETZNER Cloud hosting.

 * Creates a virtual cloud machine to host the Minecraft server
 * World data is stored on a separate data volume.  This allows the server to be expanded or removed when not in use, saving costs.
 * Uses the popular docker image [itzg/minecraft-server](https://hub.docker.com/r/itzg/minecraft-server) to deploy Minecraft

## Getting Started
In order to create a server the following steps need to be followed.

 1. Get a copy of this repo

 ```sh
git clone https://github.com/nehemming/mcserver
 ```

  2. Install [Terraform CLI](https://www.terraform.io/downloads.html)

  3. Open a [HETZNER Cloud Hosting](https://www.hetzner.com/cloud) account

  4. Create a SSH Public Key

  5. Register your public key with your HETZNER account

  6. Generate a HETZNER API token and a DNS API Token.  Remember to copy the token as only shown once.  (Will need shortly)

  7. Create a file called `terraform.tfvars` in the `minecraft` folder (use the 'sample-terraform.tfvars' as a template)

```txt
hcloud_token = "<PASTE TOKEN HERE>"
hetznerdns_token "<PASTE DNS TOKEN HERE>"
server_ssh_keys = ["<SSH KEY NAME IN HETZNER (not the public key just the NAME)>"]
```
  8. Copy the file also into the `storage` folder.

  9. Create the storage volume.  At a command prompt go to the `storage` and run the commands below.  *The Volume size is by default 10Gb, this can be increased see volume sizing below*

```sh
terraform init
terraform apply
```
==> when prompted type `yes`

  10. Create the server (at last!)  Move back to the `minecraft` folder and run

```
terraform init
terraform apply
```

==> when prompted type `yes`

If you successfully followed the steps above the server should have been created.

The IP Address of the server will be near the final output on the screen.

The server will be starting once you see the IP Address.   Please allow a couple of minutes for it to complete the start up process

## Server Sizing
The size of the server deployed in HETZNER depends on the settings defined in `terraform.tfvars`

By default the smallest lowest cost server is used.  To scale to a bigger server add the following entry to the file.  In this case we want to uses a "cx21" server

```
server_type = "cx21"
```

## Volume Sizing
The default storage volume is 10Gb.  

If this needs to be increased by editing the `storage` `terraform.tfvars` file.

If the volume already exists it will be resized by `terraform apply` but the space available will not increase.   (Google how to extend ext4 file systems to solve)

## DNS Support
The deployment supports registering DNS entries with HETZNER DNS.  To use this facility you will need a free domain that can be be registered with delegated admin by HETZNER.  To do this the domains name servers need to be registered as 

```
  hydrogen.ns.hetzner.com
  oxygen.ns.hetzner.com
  helium.ns.hetzner.de
```

The `dnszone` sub folder contains a terraform script to create the DNS Zone for top level domain.

In order to use, add a `terraform.tfvars` file containing

```
hetznerdns_token = "<DNS API TOKEN>"
dns_zone         = "<THE DOMAIN>"
```

In `dnszone` run

```
terraform init
terraform apply
```

==> when prompted type `yes`

The in the `minecraft` folder update `terraform.tfvars` to include

```
dns_enabled = true
dns_zone  = "<THE DOMAIN>"
```

Terraform will then register the IP Address or the server against the domain.

## Mods support
Mods can be added to the subfolder `mods`.  These will be imported into the server.

## Contributing
We would welcome contributions to this project.  Please read our [CONTRIBUTION](https://github.com/nehemming/mcserver/blob/master/CONTRIBUTING.md) file for further details on how you can participate or report any issues.

## License
his software is licensed under the [MIT](https://choosealicense.com/licenses/mit/) license.   See [LICENSE](https://github.com/nehemming/mcserver/blob/master/LICENSE) for more details.

## Acknowledgments 
This project is heavily indebted to the work done by the following open source contributors.

 * [ITZG's Minecraft Docker Image](https://hub.docker.com/r/itzg/minecraft-server) source [Github](https://github.com/itzg/docker-minecraft-server).
 * [Timo Hirt's HETZNER DNS Terraform provider](https://github.com/timohirt/terraform-provider-hetznerdns)
 * [HETZNER Cloud](https://www.hetzner.com/cloud) for providing excellent low cost cloud services backed by a [Terraform provider](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs).
 * [Terraform Open Source CLI](https://www.hashicorp.com/products/terraform/editions/open-source) for just glueing it together



