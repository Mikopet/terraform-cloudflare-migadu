resource "cloudflare_dns_record" "SRV" {
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
  name    = "${each.key}._tcp.${var.domain}"

  data = {
    priority = 0
    weight   = 1
    port     = each.value.port
    target   = each.value.target
  }

  # It should not be proxied
  proxied = false
  ttl     = var.ttl
  comment = "migadu - service discovery for ${each.value.desc}"

  tags = var.tags
}

