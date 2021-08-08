# Variables

variable "storage_size" {
  description = "Storage size in GB"
  type        = number
  default     = 10
}

# Must match storage_name specified in server tf vars
variable "storage_name" {
  description = "Storage name"
  type        = string
  default     = "store"
}

# Must match storage_format specified in server tf vars
variable "storage_format" {
  description = "Storage format"
  type        = string
  default     = "ext4"
}

# Must match parent server_location, 
# or volume will not mount
variable "storage_location" {
  description = "Storage locatiion, musst match server where being mounted"
  type        = string
  default     = "nbg1"
}


