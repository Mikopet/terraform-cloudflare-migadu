# terraform-cloudflare-migadu

This `terraform` module aims to help configure DNS records for migadu on cloudflare much easier.

Plese keep try testing, and give feedback, but the module should work as expected.

## Usage

Perhaps the most simplistic configuration is something like this:

```hcl
data "cloudflare_zone" "zone" {
  name = "example.com"
}

module "migadu_dns" {
  source = "mikopet/migadu/cloudflare"

  zone_id           = data.cloudflare_zone.zone.id
  domain            = "example.com"
  verification_code = "<code from migadu>"
}
```

In the future more options will arrive, like setting the `rua` and `ruf` for DMARC.
Parameterize the sub-domain addressing, and other stuff...

## Troubleshoot

The module itself is not fitted for reporting errors, so any error uou encounter
is most probably coming from Cloudflare.

One of the problems could be that you don't have premium subscription to use tags.
Remove tag definitions.

## Contribute

Just open issues or PRs if you feel like that.

