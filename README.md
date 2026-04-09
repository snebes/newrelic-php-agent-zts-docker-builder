# frankenphp-unofficial-newrelic

Unofficial multi-arch Docker images that ship the **New Relic PHP agent built with ZTS (Zend Thread Safety)** so it can run on **FrankenPHP** and other thread-safe PHP stacks. Images are published for tags that track [`dunglas/frankenphp`](https://hub.docker.com/r/dunglas/frankenphp) on Docker Hub (for example `1-php8.4`, `1.2-php8.3-bookworm`).

## Why this exists

The stock New Relic PHP agent targets NTS (non-thread-safe) PHP. **FrankenPHP** uses a ZTS PHP build, so you need an agent and extension compiled accordingly. This repository automates building and publishing those artifacts as Docker images.

## Agent source (credit)

The ZTS-capable agent sources come from **[Théophile Diot](https://github.com/theophileds)**’s fork:

**[theophileds/newrelic-php-agent-zts](https://github.com/theophileds/newrelic-php-agent-zts) — branch [`zts-support`](https://github.com/theophileds/newrelic-php-agent-zts/tree/zts-support)**

The [`prepare`](.github/workflows/prepare.yaml) workflow checks out that branch, merges in the current [`newrelic/newrelic-php-agent`](https://github.com/newrelic/newrelic-php-agent) `main`, and uses the result as the build context. Thanks to Théophile for maintaining the ZTS work this project relies on.

## What gets built

[`Dockerfile.zts-build`](Dockerfile.zts-build) compiles the Go **newrelic-daemon** and the **PHP extension** (`newrelic.so`) against the FrankenPHP base image you select. The CI build targets **`linux/amd64`**, **`linux/arm64`**, **`linux/arm/v7`**, and **`linux/386`** and pushes a manifest to Docker Hub.

The `package` stage is **`FROM scratch`** and contains only `newrelic.so` and `newrelic-daemon` for extraction or multi-stage copies into your own images.

## CI overview

| Workflow | Role |
| -------- | ---- |
| [`sync.yaml`](.github/workflows/sync.yaml) | On a schedule (and manual dispatch): discovers matching tags from `dunglas/frankenphp`, skips tags already present on this project’s Docker Hub repo, then builds and pushes the rest. |
| [`matrix.yaml`](.github/workflows/matrix.yaml) | Scheduled (and manual) builds for a fixed matrix of FrankenPHP-style tags. |
| [`adhoc.yaml`](.github/workflows/adhoc.yaml) | Build and push a **single** tag you choose. |

Reusable pieces: [`prepare.yaml`](.github/workflows/prepare.yaml) (checkout + merge + artifact), [`build.yaml`](.github/workflows/build.yaml) (buildx + push).

### GitHub configuration

Publishing requires a Docker Hub **username** in repository **Variables** (`DOCKERHUB_USERNAME`) and a **token** in **Secrets** (`DOCKERHUB_TOKEN`), as referenced in [`build.yaml`](.github/workflows/build.yaml).

## Using the images

Set your image to:

`YOUR_DOCKERHUB_USERNAME/frankenphp-unofficial-newrelic:<frankenphp-tag>`

where `<frankenphp-tag>` matches the upstream FrankenPHP tag you run (e.g. `1-php8.4`). Configure New Relic as usual (license key, app name, `newrelic.ini`, etc.).

To build locally from a clone with the agent tree present, see the comments at the top of [`Dockerfile.zts-build`](Dockerfile.zts-build).

## License

This repository is licensed under the MIT License — see [`LICENSE`](LICENSE). The New Relic agent and related upstream code remain under their respective licenses.
