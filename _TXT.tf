locals {
  rua_list = flatten(
    [for k, l in coalesce(var.dmarc.rua, {}) :
      [for v in coalesce(l, []) :
        format("%s:%s", k, v)
      ]
    ]
  )

  rua_string = local.rua_list == [] ? "" : format(" rua=%s;", join(",", local.rua_list))
}

resource "cloudflare_record" "TXT" {
  for_each = {
    "SPF"          = "v=spf1 include:spf.migadu.com -all"
    "verification" = "hosted-email-verify=${var.verification_code}"
    "dmarc"        = format("v=DMARC1; p=%s;%s", var.dmarc.p, local.rua_string)
  }

  zone_id = var.zone_id
  type    = "TXT"
  name    = each.key == "dmarc" ? "_dmarc" : var.domain
  content = "\"${each.value}\""

  # It should not be proxied
  proxied         = false
  ttl             = var.ttl
  allow_overwrite = var.allow_overwrite
  comment         = "migadu - ${each.key} record"

  tags = var.tags
}

