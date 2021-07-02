#!/bin/sh

set -ex

cd "$(basename "$(dirname "$0")")"

CONTAINER_TAG='binaries-pack'
NEOVIM_VERSION='7685fc9ecd2a1a0b6c62fe56a14de8441d9f3a58'
RIPGREP_VERSION='13.0.0'
FD_VERSION='v8.2.1'
YADM_VERSION='a4d39c75045bfca9277284ff0513eb022237a88e'

docker build -t "$CONTAINER_TAG" \
	--build-arg "NEOVIM_VERSION=${NEOVIM_VERSION}" \
	--build-arg "RIPGREP_VERSION=${RIPGREP_VERSION}" \
	--build-arg "FD_VERSION=${FD_VERSION}" \
	--build-arg "YADM_VERSION=${YADM_VERSION}" \
	.

mkdir -p out
docker run --rm -it -v "$(pwd)/out:/binaries" binaries-pack
