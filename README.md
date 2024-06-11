# Zig

[![Nightly Build](https://github.com/denisgolius/docker-zig/actions/workflows/nightly.yml/badge.svg)](https://github.com/denisgolius/docker-zig/actions/workflows/nightly.yml)

A docker image for [Zig](https://ziglang.org) based upon [Alpine Linux](https://www.alpinelinux.org/releases/) `3.20.0` .

## Using this image

### Building an executable

```
docker run -v $PWD:/app denisgolius/zig:0.13.0 build-exe hello.zig
```

## Available tags

There are two variants of tags provided by this repository - release tags such as `0.13.0`, and `master` branch builds such as `master-6a65561e3`.

The most recent `master-X` build is always tagged as simply `master` as well as having a tag including the Git hash for the release.

The most recent stable release is always tagged as `latest`.

## Building the Docker image(s)

A bash script (`build.sh`) is ran by GitHub actions nightly in order to check for new versions and to then build and push images for them.