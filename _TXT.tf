resource "cloudflare_record" "TXT" {
  for_each = {
    "SPF"          = "v=spf1 include:spf.migadu.com -all"
    "verification" = "hosted-email-verify=${var.verification_code}"
    "dmarc"        = "v=DMARC1; p=quarantine;"
  }

  zone_id = var.zone_id
  type    = "TXT"
  name    = each.key == "dmarc" ? "_dmarc" : "@"
  value   = each.value

  # It should not be proxied
  proxied         = false
  ttl             = var.ttl
  allow_overwrite = var.allow_overwrite
  comment         = "migadu - ${each.key} record"

  tags = var.tags
}

