# `mtls-certificate`

Manage client certificates used for mTLS connections in subrequests.

These certificates can be used in [`mtls_certificate` bindings](https://developers.cloudflare.com/workers/runtime-apis/bindings/mtls), which allow a Worker to present the certificate when establishing a connection with an origin that requires client authentication (mTLS).

### `mtls-certificate upload`

Upload an mTLS certificate

* npm

  ```sh
  npx wrangler mtls-certificate upload
  ```

* pnpm

  ```sh
  pnpm wrangler mtls-certificate upload
  ```

* yarn

  ```sh
  yarn wrangler mtls-certificate upload
  ```

- `--cert` string required

  The path to a certificate file (.pem) containing a chain of certificates to upload

- `--key` string required

  The path to a file containing the private key for your leaf certificate

- `--name` string

  The name for the certificate

Global flags

* `--v` boolean alias: --version

  Show version number

* `--cwd` string

  Run as if Wrangler was started in the specified directory instead of the current working directory

* `--config` string alias: --c

  Path to Wrangler configuration file

* `--env` string alias: --e

  Environment to use for operations, and for selecting .env and .dev.vars files

* `--env-file` string

  Path to an .env file to load - can be specified multiple times - values from earlier files are overridden by values in later files

* `--experimental-provision` boolean aliases: --x-provision default: true

  Experimental: Enable automatic resource provisioning

* `--experimental-auto-create` boolean alias: --x-auto-create default: true

  Automatically provision draft bindings with new resources

The following is an example of using the `upload` command to upload an mTLS certificate.

```sh
npx wrangler mtls-certificate upload --cert cert.pem --key key.pem --name my-origin-cert
```

```sh
Uploading mTLS Certificate my-origin-cert...
Success! Uploaded mTLS Certificate my-origin-cert
ID: 99f5fef1-6cc1-46b8-bd79-44a0d5082b8d
Issuer: CN=my-secured-origin.com,OU=my-team,O=my-org,L=San Francisco,ST=California,C=US
Expires: 1/01/2025
```

You can then add this certificate as a [binding](https://developers.cloudflare.com/workers/runtime-apis/bindings/) in your [Wrangler configuration file](https://developers.cloudflare.com/workers/wrangler/configuration/):

* wrangler.jsonc

  ```jsonc
  {
    "$schema": "./node_modules/wrangler/config-schema.json",
    "mtls_certificates": [
      {
        "binding": "MY_CERT",
        "certificate_id": "99f5fef1-6cc1-46b8-bd79-44a0d5082b8d"
      }
    ]
  }
  ```

* wrangler.toml

  ```toml
  mtls_certificates = [
    { binding = "MY_CERT", certificate_id = "99f5fef1-6cc1-46b8-bd79-44a0d5082b8d" }
  ]
  ```

Note that the certificate and private keys must be in separate (typically `.pem`) files when uploading.

### `mtls-certificate list`

List uploaded mTLS certificates

* npm

  ```sh
  npx wrangler mtls-certificate list
  ```

* pnpm

  ```sh
  pnpm wrangler mtls-certificate list
  ```

* yarn

  ```sh
  yarn wrangler mtls-certificate list
  ```

Global flags

* `--v` boolean alias: --version

  Show version number

* `--cwd` string

  Run as if Wrangler was started in the specified directory instead of the current working directory

* `--config` string alias: --c

  Path to Wrangler configuration file

* `--env` string alias: --e

  Environment to use for operations, and for selecting .env and .dev.vars files

* `--env-file` string

  Path to an .env file to load - can be specified multiple times - values from earlier files are overridden by values in later files

* `--experimental-provision` boolean aliases: --x-provision default: true

  Experimental: Enable automatic resource provisioning

* `--experimental-auto-create` boolean alias: --x-auto-create default: true

  Automatically provision draft bindings with new resources

The following is an example of using the `list` command to upload an mTLS certificate.

```sh
npx wrangler mtls-certificate list
```

```sh
ID: 99f5fef1-6cc1-46b8-bd79-44a0d5082b8d
Name: my-origin-cert
Issuer: CN=my-secured-origin.com,OU=my-team,O=my-org,L=San Francisco,ST=California,C=US
Created on: 1/01/2023
Expires: 1/01/2025


ID: c5d004d1-8312-402c-b8ed-6194328d5cbe
Issuer: CN=another-origin.com,OU=my-team,O=my-org,L=San Francisco,ST=California,C=US
Created on: 1/01/2023
Expires: 1/01/2025
```

### `mtls-certificate delete`

Delete an mTLS certificate

* npm

  ```sh
  npx wrangler mtls-certificate delete
  ```

* pnpm

  ```sh
  pnpm wrangler mtls-certificate delete
  ```

* yarn

  ```sh
  yarn wrangler mtls-certificate delete
  ```

- `--id` string

  The id of the mTLS certificate to delete

- `--name` string

  The name of the mTLS certificate record to delete

Global flags

* `--v` boolean alias: --version

  Show version number

* `--cwd` string

  Run as if Wrangler was started in the specified directory instead of the current working directory

* `--config` string alias: --c

  Path to Wrangler configuration file

* `--env` string alias: --e

  Environment to use for operations, and for selecting .env and .dev.vars files

* `--env-file` string

  Path to an .env file to load - can be specified multiple times - values from earlier files are overridden by values in later files

* `--experimental-provision` boolean aliases: --x-provision default: true

  Experimental: Enable automatic resource provisioning

* `--experimental-auto-create` boolean alias: --x-auto-create default: true

  Automatically provision draft bindings with new resources

The following is an example of using the `delete` command to delete an mTLS certificate.

```sh
npx wrangler mtls-certificate delete --id 99f5fef1-6cc1-46b8-bd79-44a0d5082b8d
```

```sh
Are you sure you want to delete certificate 99f5fef1-6cc1-46b8-bd79-44a0d5082b8d (my-origin-cert)? [y/n]
yes
Deleting certificate 99f5fef1-6cc1-46b8-bd79-44a0d5082b8d...
Deleted certificate 99f5fef1-6cc1-46b8-bd79-44a0d5082b8d successfully
```

***


