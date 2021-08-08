# Variabless
variable "dns_zone" {
  description = "DNS zone"
  type        = string
}

variable "dns_ttl" {
  description = "DNS TTL"
  type        = number
  default     = 60
}

variable "dns_nameservers" {
  description = "DNS Nameservers"
  type        = list(string)
  default = [
    "hydrogen.ns.hetzner.com",
    "oxygen.ns.hetzner.com",
    "helium.ns.hetzner.de"
  ]
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
