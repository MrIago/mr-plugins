# Image Management


## Pushing images during `wrangler deploy`

When running `wrangler deploy`, if you set the `image` attribute in your [Wrangler configuration](https://developers.cloudflare.com/workers/wrangler/configuration/#containers) to a path to a Dockerfile, Wrangler will build your container image locally using Docker, then push it to a registry run by Cloudflare. This registry is integrated with your Cloudflare account and is backed by [R2](https://developers.cloudflare.com/r2/). All authentication is handled automatically by Cloudflare both when pushing and pulling images.

Just provide the path to your Dockerfile:

* wrangler.jsonc

  ```jsonc
  {
    "containers": {
      "image": "./Dockerfile"
      // ...rest of config...
    }
  }
  ```

* wrangler.toml

  ```toml
  [containers]
  image = "./Dockerfile"
  ```

And deploy your Worker with `wrangler deploy`. No other image management is necessary.

On subsequent deploys, Wrangler will only push image layers that have changed, which saves space and time.

Note

Docker or a Docker-compatible CLI tool must be running for Wrangler to build and push images. This is not necessary if you are using a pre-built image, as described below.

## Using pre-built container images

Currently, we support images stored in the Cloudflare managed registry at `registry.cloudflare.com` and in [Amazon ECR](https://aws.amazon.com/ecr/). Support for additional external registries is coming soon.

If you wish to use a pre-built image from another registry provider, first, make sure it exists locally, then push it to the Cloudflare Registry:

```plaintext
docker pull <public-image>
docker tag <public-image> <image>:<tag>
```

Wrangler provides a command to push images to the Cloudflare Registry:

* npm

  ```sh
  npx wrangler containers push <image>:<tag>
  ```

* yarn

  ```sh
  yarn wrangler containers push <image>:<tag>
  ```

* pnpm

  ```sh
  pnpm wrangler containers push <image>:<tag>
  ```

Or, you can use the `-p` flag with `wrangler containers build` to build and push an image in one step:

* npm

  ```sh
  npx wrangler containers build -p -t <tag> .
  ```

* yarn

  ```sh
  yarn wrangler containers build -p -t <tag> .
  ```

* pnpm

  ```sh
  pnpm wrangler containers build -p -t <tag> .
  ```

This will output an image registry URI that you can then use in your Wrangler configuration:

* wrangler.jsonc

  ```jsonc
  {
    "containers": {
      "image": "registry.cloudflare.com/your-account-id/your-image:tag"
      // ...rest of config...
    }
  }
  ```

* wrangler.toml

  ```toml
  [containers]
  image = "registry.cloudflare.com/your-account-id/your-image:tag"
  ```

### Using Amazon ECR container images

To use container images stored in [Amazon ECR](https://aws.amazon.com/ecr/), you will need to configure the ECR registry domain with credentials. These credentials get stored in [Secrets Store](https://developers.cloudflare.com/secrets-store) under the `containers` scope. When we prepare your container, these credentials will be used to generate an ephemeral token that can pull your image. We do not currently support public ECR images. To generate the necessary credentials for ECR, you will need to create an IAM user with a read-only policy. The following example grants access to all image repositories under AWS account `123456789012` in `us-east-1`.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["ecr:GetAuthorizationToken"],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      // arn:${Partition}:ecr:${Region}:${Account}:repository/${Repository-name}
      "Resource": [
        "arn:aws:ecr:us-east-1:123456789012:repository/*"
        // "arn:aws:ecr:us-east-1:123456789012:repository/example-repo"
      ]
    }
  ]
}
```

You can then use the credentials for the IAM User to [configure a registry in Wrangler](https://developers.cloudflare.com/workers/wrangler/commands/#containers-registries). Wrangler will prompt you to create a Secrets Store store if one does not already exist, and then create your secret.

* npm

  ```sh
  npx wrangler containers registries configure 123456789012.dkr.ecr.us-east-1.amazonaws.com --aws-access-key-id=AKIAIOSFODNN7EXAMPLE
  ```

* yarn

  ```sh
  yarn wrangler containers registries configure 123456789012.dkr.ecr.us-east-1.amazonaws.com --aws-access-key-id=AKIAIOSFODNN7EXAMPLE
  ```

* pnpm

  ```sh
  pnpm wrangler containers registries configure 123456789012.dkr.ecr.us-east-1.amazonaws.com --aws-access-key-id=AKIAIOSFODNN7EXAMPLE
  ```

Once this is setup, you will be able to use ECR images in your wrangler config.

* wrangler.jsonc

  ```jsonc
  {
    "containers": {
      "image": "123456789012.dkr.ecr.us-east-1.amazonaws.com/example-repo:tag"
      // ...rest of config...
    }
  }
  ```

* wrangler.toml

  ```toml
  [containers]
  image = "123456789012.dkr.ecr.us-east-1.amazonaws.com/example-repo:tag"
  ```

Note

Currently, the Cloudflare Vite-plugin does not support registry links in local development, unlike `wrangler dev`. As a workaround, you can create a minimal Dockerfile that uses `FROM <registry-link>`. Make sure to `EXPOSE` a port in local dev as well.

## Pushing images with CI

To use an image built in a continuous integration environment, install `wrangler` then build and push images using either `wrangler containers build` with the `--push` flag, or using the `wrangler containers push` command.

## Registry Limits

Images are limited to 2 GB in size and you are limited to 50 total GB in your account's registry.

Note

These limits will likely increase in the future.

Delete images with `wrangler containers images delete` to free up space, but reverting a Worker to a previous version that uses a deleted image will then error.


