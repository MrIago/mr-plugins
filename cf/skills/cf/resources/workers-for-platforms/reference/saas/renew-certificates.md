# Renew certificates


The exact method for certificate renewal depends on whether that hostname is active[1](#user-content-fn-1) and whether it is a wildcard certificate.

Custom hostnames certificates have a 90-day validity period and are available for renewal 30 days before their expiration.

## Non-wildcard hostnames

If you are using a non-wildcard hostname and the hostname is active, Cloudflare will try to perform DCV automatically on the hostname's behalf by serving the [HTTP token](https://developers.cloudflare.com/cloudflare-for-platforms/cloudflare-for-saas/security/certificate-management/issue-and-validate/validate-certificates/http/).

If the custom hostname is not active, then the custom hostname domain owner will need to add the TXT or HTTP DCV token for the new certificate to validate and issue. As the SaaS provider, you will be responsible for sharing this token with the custom hostname domain owner.

## Wildcard hostnames

With wildcard hostnames, you cannot use HTTP. In this case, you will have to use TXT DCV tokens.

These tokens can be fetched through the API or the dashboard when the certificates are in a [pending validation](https://developers.cloudflare.com/ssl/reference/certificate-statuses/#new-certificates) state during custom hostname creation or during certificate renewals.

If your hostname is using another validation method, you will need to [update](https://developers.cloudflare.com/api/resources/custom_hostnames/methods/edit/) the `"method"` field in the SSL object to be `"txt"`.

After this step, follow the normal steps for [TXT validation](https://developers.cloudflare.com/cloudflare-for-platforms/cloudflare-for-saas/security/certificate-management/issue-and-validate/validate-certificates/txt/).

Note

To allow Cloudflare to auto-renew all future certificate orders, consider [DCV delegation](https://developers.cloudflare.com/cloudflare-for-platforms/cloudflare-for-saas/security/certificate-management/issue-and-validate/validate-certificates/delegated-dcv/).

## Footnotes

1. Meaning Cloudflare could verify your customer's ownership of the hostname and the [hostname status](https://developers.cloudflare.com/cloudflare-for-platforms/cloudflare-for-saas/domain-support/hostname-validation/validation-status/) is active. [↩](#user-content-fnref-1)


