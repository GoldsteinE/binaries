#!/bin/sh

set -ex

cd "$(basename "$(dirname "$0")")"

CONTAINER_TAG='binaries-pack'
NEOVIM_VERSION='aec61074a97bac3290f1afef309429b35a71d1a2'
RIPGREP_VERSION='12.1.1'
FD_VERSION='v8.1.1'
YADM_VERSION='3ddea208535be182af8cb53095d237bce55267f8'

docker build -t "$CONTAINER_TAG" \
	--build-arg "NEOVIM_VERSION=${NEOVIM_VERSION}" \
	--build-arg "RIPGREP_VERSION=${RIPGREP_VERSION}" \
	--build-arg "FD_VERSION=${FD_VERSION}" \
	--build-arg "YADM_VERSION=${YADM_VERSION}" \
	.

mkdir -p out
docker run --rm -it -v "$(pwd)/out:/binaries" binaries-pack
