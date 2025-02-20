variable "zone_id" {
  description = "The ID of the Zone to put the records in"
  type        = string
}

variable "domain" {
  description = "The Apex domain name for the DNS settings"
  type        = string
}

variable "verification_code" {
  description = "Migadu DNS verification code"
  type        = string
}

variable "ttl" {
  description = "The TTL of DNS records in seconds"
  type        = number
  default     = 1

  validation {
    error_message = "The TTL of the records should be between 60 and 86400 seconds (omit for default automatic)"
    condition     = var.ttl == 1 || (var.ttl >= 60 && var.ttl <= 86400)
  }
}

# TODO: remove this at some point
variable "allow_overwrite" {
  description = "deprecated"
  type        = bool
  default     = false
  nullable    = true
}

variable "tags" {
  description = "The list of tags for the DNS records"
  type        = list(string)
  default     = []
}

variable "subdomain_mx" {
  description = "Switch for Subdomain Addressing (MX)"
  type        = bool
  default     = false
}

variable "dmarc" {
  description = "The DMARC policy configuration (p, rua.mailto)"
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

