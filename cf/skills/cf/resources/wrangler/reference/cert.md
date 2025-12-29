# `cert`

Manage mTLS client certificates and Certificate Authority (CA) chain certificates used for secured connections.

These certificates can be used in Hyperdrive configurations, enabling them to present the certificate when connecting to an origin database that requires client authentication (mTLS) or a custom Certificate Authority (CA).

### `cert upload mtls-certificate`

Upload an mTLS certificate

* npm

  ```sh
  npx wrangler cert upload mtls-certificate
  ```

* pnpm

  ```sh
  pnpm wrangler cert upload mtls-certificate
  ```

* yarn

  ```sh
  yarn wrangler cert upload mtls-certificate
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
npx wrangler cert upload --cert cert.pem --key key.pem --name my-origin-cert
```

```sh
Uploading mTLS Certificate my-origin-cert...
Success! Uploaded mTLS Certificate my-origin-cert
ID: 99f5fef1-6cc1-46b8-bd79-44a0d5082b8d
Issuer: CN=my-secured-origin.com,OU=my-team,O=my-org,L=San Francisco,ST=California,C=US
Expires: 1/01/2025
```

Note that the certificate and private keys must be in separate (typically `.pem`) files when uploading.

### `cert upload certificate-authority`

Upload a CA certificate chain

* npm

  ```sh
  npx wrangler cert upload certificate-authority
  ```

* pnpm

  ```sh
  pnpm wrangler cert upload certificate-authority
  ```

* yarn

  ```sh
  yarn wrangler cert upload certificate-authority
  ```

- `--name` string

  The name for the certificate

- `--ca-cert` string required

  The path to a certificate file (.pem) containing a chain of CA certificates to upload

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

The following is an example of using the `upload` command to upload an CA certificate.

```sh
npx wrangler cert upload certificate-authority --ca-cert server-ca-chain.pem --name SERVER_CA_CHAIN
```

```sh
Uploading CA Certificate SERVER_CA_CHAIN...
Success! Uploaded CA Certificate SERVER_CA_CHAIN
ID: 99f5fef1-6cc1-46b8-bd79-44a0d5082b8d
Issuer: CN=my-secured-origin.com,OU=my-team,O=my-org,L=San Francisco,ST=California,C=US
Expires: 1/01/2025
```

### `cert list`

List uploaded mTLS certificates

* npm

  ```sh
  npx wrangler cert list
  ```

* pnpm

  ```sh
  pnpm wrangler cert list
  ```

* yarn

  ```sh
  yarn wrangler cert list
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

The following is an example of using the `list` command to upload an mTLS or CA certificate.

```sh
npx wrangler cert list
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

### `cert delete`

Delete an mTLS certificate

* npm

  ```sh
  npx wrangler cert delete
  ```

* pnpm

  ```sh
  pnpm wrangler cert delete
  ```

* yarn

  ```sh
  yarn wrangler cert delete
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

The following is an example of using the `delete` command to delete an mTLS or CA certificate.

```sh
npx wrangler cert delete --id 99f5fef1-6cc1-46b8-bd79-44a0d5082b8d
```

```sh
Are you sure you want to delete certificate 99f5fef1-6cc1-46b8-bd79-44a0d5082b8d (my-origin-cert)? [y/n]
yes
Deleting certificate 99f5fef1-6cc1-46b8-bd79-44a0d5082b8d...
Deleted certificate 99f5fef1-6cc1-46b8-bd79-44a0d5082b8d successfully
```

***


