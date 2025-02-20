resource "cloudflare_dns_record" "DKIM" {
  count = 3

  zone_id = var.zone_id
  type    = "CNAME"
  name    = "key${count.index + 1}._domainkey"
  content = "key${count.index + 1}.${var.domain}._domainkey.migadu.com."

  # It should not be proxied
  proxied = false
  ttl     = var.ttl
  comment = "migadu - DKIM key #${count.index + 1}"

  tags = var.tags
}

resource "cloudflare_dns_record" "autoconfig" {
  zone_id = var.zone_id
  type    = "CNAME"
  name    = "autoconfig"
  content = "autoconfig.migadu.com."

  # It should not be proxied
  proxied = false
  ttl     = var.ttl
  comment = "migadu - autoconfig for Thunderbird"

  tags = var.tags
}

