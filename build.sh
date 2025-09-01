#!/usr/bin/env bash

set -eux

version() {
    echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'
}

# get the current list of releases
RELEASES=$(curl -s https://zig.squirl.dev/index.json)

# get the details for the master build
MASTER_RELEASE=$(echo "$RELEASES" | jq '.master')
MASTER_VERSION=$(echo "$MASTER_RELEASE" | jq --raw-output '.version')
MASTER_HASH=$(echo "$MASTER_VERSION" | sed 's/.*+//')
MASTER_LINUX_URL=$(echo "$MASTER_RELEASE" | jq --raw-output '."x86_64-linux".tarball')
MASTER_LINUX_SHA=$(echo "$MASTER_RELEASE" | jq --raw-output '."x86_64-linux".shasum')

# check to see if we have details for a previous master
LAST_BUILD_MASTER_HASH=''
if [ -f './last_master' ]; then
    LAST_BUILD_MASTER_HASH=$(cat './last_master')
fi

if [ "${MASTER_HASH}" != "${LAST_BUILD_MASTER_HASH}" ]; then
    echo "Building image for master with hash: ${MASTER_HASH}"

    docker build -f Dockerfile \
        --build-arg "ZIG_VERSION=master" \
        --build-arg "ZIG_URL=${MASTER_LINUX_URL}" \
        --build-arg "ZIG_SHA256=${MASTER_LINUX_SHA}" \
        -t "denisgolius/zig:master-${MASTER_HASH}" \
        -t 'denisgolius/zig:master' \
        -t "ghcr.io/denisgolius/zig:master-${MASTER_HASH}" \
        -t 'ghcr.io/denisgolius/zig:master' \
        .

    docker push "denisgolius/zig:master-${MASTER_HASH}"
    docker push 'denisgolius/zig:master'
    
    docker push "ghcr.io/denisgolius/zig:master-${MASTER_HASH}"
    docker push 'ghcr.io/denisgolius/zig:master'

    echo "${MASTER_HASH}" > ./last_master
fi

# loop over each of the other keys, as each one is a release
OTHER_RELEASES=$(echo "$RELEASES" | jq --raw-output 'keys | map(select(. != "master")) | .[]')

# check to see if we have details for a previous version
LAST_VERSION='0.13.0'
if [ -f './last_version' ]; then
    LAST_VERSION=$(cat './last_version')
fi

LAST_VERSION_NUM=$(version "${LAST_VERSION}")

while read release; do
    if [ $(version "${release}") -gt $LAST_VERSION_NUM ]; then
        echo "Building image for release: ${release}"

        VERSION_RELEASE=$(echo "$RELEASES" | jq ".\"${release}\"")
        VERSION_RELEASE_LINUX_URL=$(echo "$VERSION_RELEASE" | jq --raw-output '."x86_64-linux".tarball')
        VERSION_RELEASE_LINUX_SHA=$(echo "$VERSION_RELEASE" | jq --raw-output '."x86_64-linux".shasum')

        docker build -f Dockerfile \
            --build-arg "ZIG_VERSION=${release}" \
            --build-arg "ZIG_URL=${VERSION_RELEASE_LINUX_URL}" \
            --build-arg "ZIG_SHA256=${VERSION_RELEASE_LINUX_SHA}" \
            -t "denisgolius/zig:${release}" \
            -t "ghcr.io/denisgolius/zig:${release}" \
            .

        docker push "denisgolius/zig:${release}"

        docker push "ghcr.io/denisgolius/zig:${release}"

        echo "${release}" > ./last_version
    fi
done <<< "${OTHER_RELEASES}"
