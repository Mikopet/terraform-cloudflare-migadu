resource "cloudflare_record" "MX" {
  count = 2

  zone_id  = var.zone_id
  type     = "MX"
  name     = var.domain
  content  = "aspmx${count.index + 1}.migadu.com"
  priority = (count.index + 1) * 10

  # It should not be proxied
  proxied         = false
  ttl             = var.ttl
  allow_overwrite = var.allow_overwrite
  comment         = "migadu - MX host #${count.index + 1}"

  tags = var.tags
}

resource "cloudflare_record" "MX-subdomain" {
  count = var.subdomain_mx ? 2 : 0

  zone_id  = var.zone_id
  type     = "MX"
  name     = "*"
  content  = "aspmx${count.index + 1}.migadu.com"
  priority = (count.index + 1) * 10

  # It should not be proxied
  proxied         = false
  ttl             = var.ttl
  allow_overwrite = var.allow_overwrite
  comment         = "migadu - MX host #${count.index + 1} (subdomain)"

  tags = var.tags
}

