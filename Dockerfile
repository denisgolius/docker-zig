FROM alpine:3.21.3

ARG ZIG_VERSION=0.14.0
ARG ZIG_URL=https://github.com/ziglang/zig/releases/download/${ZIG_VERSION}/zig-bootstrap-${ZIG_VERSION}.tar.xz
ARG ZIG_SHA256=bf3fcb22be0b83f4791748adb567d3304779d66d7bf9b1bd557ef6c2e0232807

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
