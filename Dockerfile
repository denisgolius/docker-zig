FROM alpine:3.22.1

ARG ZIG_VERSION=0.15.1
ARG ZIG_URL=https://github.com/ziglang/zig/releases/download/${ZIG_VERSION}/zig-bootstrap-${ZIG_VERSION}.tar.xz
ARG ZIG_SHA256=c61c5da6edeea14ca51ecd5e4520c6f4189ef5250383db33d01848293bfafe05

LABEL version=0.15.1
LABEL maintainer="Denys Holius <https://x.com/dengolius>"

WORKDIR /usr/src

COPY docker-zig-manager /usr/local/bin/docker-zig-manager

RUN set -ex \
	&& /usr/local/bin/docker-zig-manager fetch $ZIG_URL $ZIG_SHA256 \
	&& /usr/local/bin/docker-zig-manager extract

ENV PATH "/usr/local/bin/zig:${PATH}"

WORKDIR /app

ENTRYPOINT ["/usr/local/bin/zig/zig"]
