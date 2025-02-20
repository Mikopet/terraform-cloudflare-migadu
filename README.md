# terraform-cloudflare-migadu

This `terraform` module aims to help configure DNS records for migadu on cloudflare much easier.

Plese keep try testing, and give feedback, but the module should work as expected.

## Usage

Perhaps the most simplistic configuration is something like this:

```hcl
data "cloudflare_zone" "zone" {
  filter = {
    name = "example.com"
  }
}

module "migadu_dns" {
  source = "mikopet/migadu/cloudflare"

  zone_id           = data.cloudflare_zone.zone.zone_id
  domain            = "example.com"
  verification_code = "<code from migadu>"
}
```
> [!NOTE]
> **At the time of writing the cloudflare documentation is incorrect!**  
> The currently working attribute is presented above: `.zone_id`.

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

The module itself is not fitted for reporting errors, so any error you encounter
is most probably coming from Cloudflare.

One of the problems could be that you don't have premium subscription to use tags.
Remove tag definitions.

### Migrating from v4 to v5

Fortunately (for you) I've suffered through the failures to present you a working solution.

#### Preparation
You must update your code as the [migration guide] suggests.
If you were getting the zone ID with data resource, the syntax changed to:
```terraform
data "cloudflare_zone" "zone" {
  filter = {
    name = "example.com"
  }
}
```

> [!NOTE]
> **At the time of writing the cloudflare documentation is incorrect!**  
> Where you are referencing this data resource, the evidently correct way may be not `.id` but `.zone_id`!

If you were also using `allow_overwrite`, remove that too.

#### The Hard Part
Cloudflare suggests, that you should update to the latest v4, before upgrading to v5.
I did that to no avail, even with refreshed state I encountered many errors.

But at this point you should not see more errors than this one type:
```
Error: no schema available for module.migadu.cloudflare_record.MX[0] while reading state; this is a bug in Terraform and should be reported
```

The only way I was able to solve this without outage, is to remove the problematic resources from the state
(including all related cloudflare resources listed at once):
```bash
$ terraform state rm data.cloudflare_zone.zone module.migadu
```

And apply the new code.
> [!WARNING]
> For actually be able to successfully run the apply plan, you have to delete all related records first!

> [!TIP]
> As the migration guide suggests, you may skip the reprovision with `import` statements.  
> I did not try that, as getting the IDs of the records seemed troublesonme...
> but if minor DNS downtime is unacceptable for you... you may try it!

## Contribute

Just open issues or PRs if you feel like that.

[migration guide]: https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/guides/version-5-upgrade
