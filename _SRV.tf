resource "cloudflare_record" "SRV" {
  for_each = {
    "_autodiscover" = {
      port   = 443
      target = "autodiscover.migadu.com"
      desc   = "Outlook"
    }
    "_submissions" = {
      port   = 465
      target = "smtp.migadu.com"
      desc   = "SMTP outgoing"
    }
    "_imaps" = {
      port   = 993
      target = "imap.migadu.com"
      desc   = "IMAP incoming"
    }
    "_pop3s" = {
      port   = 995
      target = "pop.migadu.com"
      desc   = "POP3 incoming"
    }
  }

  zone_id = var.zone_id
  type    = "SRV"
  name    = "${each.key}._tcp"

  data {
    priority = 0
    weight   = 1
    port     = each.value.port
    target   = each.value.target
    # these are deprecated values, but without them it won't work
    service = each.key
    proto   = "_tcp"
    name    = var.domain
  }

  # It should not be proxied
  proxied         = false
  ttl             = var.ttl
  allow_overwrite = var.allow_overwrite
  comment         = "migadu - service discovery for ${each.value.desc}"

  tags = var.tags
}

