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

### DMARC `rua`

Setting rua address is **strongly recommended**. When you are in the Cloudflare dashboard,
you could select `Email > DMARC Management`. With this feature you could add a rua address
to your DNS.

This is awesome, but you have to add to your terraform code too:

```hcl
module "migadu" {
  # ...

  dmarc = {
    p = "quarantine" # should be one of `none`, `quarantine`, `reject`
    rua = {
      mailto = [
        "<email given to you by cloudflare>@dmarc-reports.cloudflare.net",
      ]
    }
  }
}
```

If you want, you could add multiple addresses of course. Mind the limit of TXT DNS records (255 characters).

In the future more options will arrive, like setting `ruf` for DMARC.
Parameterize the sub-domain addressing, and other stuff...

## Troubleshoot

The module itself is not fitted for reporting errors, so any error uou encounter
is most probably coming from Cloudflare.

One of the problems could be that you don't have premium subscription to use tags.
Remove tag definitions.

## Contribute

Just open issues or PRs if you feel like that.

