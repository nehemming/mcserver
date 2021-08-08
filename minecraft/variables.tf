# Variabless
variable "server_name" {
  description = "Server name"
  type        = string
  default     = "minecraft"
}

variable "server_location" {
  description = "Server locatiion"
  type        = string
  default     = "nbg1"
}

variable "server_image" {
  description = "Server o/s image"
  type        = string
  default     = "ubuntu-20.04"
}

variable "server_type" {
  description = "Server type"
  type        = string
  default     = "cx11"
}

variable "server_ssh_keys" {
  description = "Server SSH keys"
  type        = list(string)
}

variable "server_backups" {
  description = "Server backup count"
  type        = bool
  default     = false
}

variable "server_timezone" {
  description = "The server timezone"
  type        = string
  default     = "Europe/London"
}


# Storage name is the name of the attached volume store
variable "storage_name" {
  description = "Storage name"
  type        = string
  default     = "store"
}

variable "storage_format" {
  description = "Storage format"
  type        = string
  default     = "ext4"
}

variable "storage_mountpoint" {
  description = "Storage mountpoint"
  type        = string
  default     = "/mnt/data"
}

variable "minecraft_public_port" {
  description = "Public minecraft port"
  type        = string
  default     = "25565"
}
variable "minecraft_rcon_public_port" {
  description = "Public minecraft port"
  type        = string
  default     = "25575"
}
variable "minecraft_folder" {
  description = "Public minecraft folder"
  type        = string
  default     = "minecraft"
}

variable "minecraft_settings" {
  description = "Minecraft server settings"
  type        = map(string)
}

variable "minecraft_whitelist" {
  description = "Minecraft whilte list"
  type        = set(string)
}

variable "minecraft_opslist" {
  description = "Minecraft ops list"
  type        = set(string)
  default     = []
}
variable "minecraft_enable_rcon" {
  description = "Enabler RCON for minecraft"
  type        = string
  default     = "false"
}

variable "minecraft_rcon_password" {
  description = "Enabler RCON for minecraft"
  type        = string
  default     = "minecraft"
  sensitive   = true
}

variable "dns_enabled" {
  description = "Is DNS enabled"
  type        = bool
  default     = false
}

variable "dns_ttl" {
  description = "DNS TTL"
  type        = number
  default     = 60
}

variable "dns_records" {
  description = "DNS Records"
  type        = list(any)
  default = [
    # {
    #   type  = "A",
    #   name  = "@",
    #   value = "$(IP)",
    # }
  ]
}

variable "dns_zone" {
  description = "DNS root domain"
  type        = string
  default     = "none"
}

variable "minecraft_mods_folder" {
  description = "Minecraft MODs folder"
  type        = string
  default     = "mods"
}
variable "server_mods_folder" {
  description = "Server mods folder"
  type        = string
  default     = "/root/mods"
}

variable "minecraft_datapack_folder" {
  description = "Minecraft datapack folder"
  type        = string
  default     = "datapacks"
}
variable "server_datapack_folder" {
  description = "Server datapack folder"
  type        = string
  default     = "/root/datapacks"
}
