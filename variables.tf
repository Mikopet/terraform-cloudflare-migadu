variable "zone_id" {
  description = "Zone ID for the zone to put records in"
  type        = string
}

variable "domain" {
  description = "apex domain name of the DNS settings"
  type        = string
}

variable "verification_code" {
  description = "verification code"
  type        = string
}

variable "ttl" {
  description = "TTL in seconds. Between 60 and 86400 seconds, or 1 for Automatic"
  type        = number
  default     = 1
}

variable "allow_overwrite" {
  description = "Enable/disable overwriting records"
  type        = bool
  default     = false
}

variable "tags" {
  description = "tags for DNS records"
  type        = list(string)
  default     = []
}

variable "subdomain_mx" {
  description = "MX records for Subdomain Addressing"
  type        = bool
  default     = false
}

variable "dmarc" {
  description = "email address for DMARC rua"
  type = object({
    p = string
    rua = optional(object({
      mailto = optional(list(string))
    }))
  })
  default = {
    p = "quarantine"
  }

  validation {
    error_message = "DMARC policy should be one of these: [none,quarantine,reject]"
    condition     = contains(["none", "quarantine", "reject"], var.dmarc.p)
  }

  validation {
    error_message = "DMARC policy emails in `mailto` should be valid"
    condition = alltrue([
      for a in coalesce(try(var.dmarc.rua.mailto, null), []) :
      can(regex("^[^@]+@[^@]+\\.[^@]+$", a))
    ])
  }
}

