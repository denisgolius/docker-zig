FROM alpine:3.22.1

ARG ZIG_VERSION=0.14.1
ARG ZIG_URL=https://github.com/ziglang/zig/releases/download/${ZIG_VERSION}/zig-bootstrap-${ZIG_VERSION}.tar.xz
ARG ZIG_SHA256=89b2fce50bfbb1eee29c382193d22c6eb0c7da3a96b5ba6d05e0af2945b3ca3d

LABEL version=0.14.1
LABEL maintainer="Denys Holius <https://x.com/dengolius>"

WORKDIR /usr/src

COPY docker-zig-manager /usr/local/bin/docker-zig-manager

RUN set -ex \
	&& /usr/local/bin/docker-zig-manager fetch $ZIG_URL $ZIG_SHA256 \
	&& /usr/local/bin/docker-zig-manager extract

ENV PATH "/usr/local/bin/zig:${PATH}"

WORKDIR /app

ENTRYPOINT ["/usr/local/bin/zig/zig"]
