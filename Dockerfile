FROM alpine:3.21.3

ARG ZIG_VERSION=0.14.0
ARG ZIG_URL=https://ziglang.org/download/${ZIG_VERSION}/zig-linux-x86_64-${ZIG_VERSION}.tar.xz
ARG ZIG_SHA256=d731dc81e1dff2d5f9b1d1979d554648df6d05f7723d1cc9e37430c7ca88d573

LABEL version=0.14.0
LABEL maintainer="Denys Holius <https://x.com/dengolius>"

WORKDIR /usr/src

COPY docker-zig-manager /usr/local/bin/docker-zig-manager

RUN set -ex \
	&& /usr/local/bin/docker-zig-manager fetch $ZIG_URL $ZIG_SHA256 \
	&& /usr/local/bin/docker-zig-manager extract

ENV PATH "/usr/local/bin/zig:${PATH}"

WORKDIR /app

ENTRYPOINT ["/usr/local/bin/zig/zig"]
