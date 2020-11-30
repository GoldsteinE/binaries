#!/bin/sh
set -e
self_dir="$(dirname "$0")"
neovim_dir="${self_dir}/../opt/neovim"
VIMRUNTIME="${neovim_dir}/runtime" "${neovim_dir}/bin/nvim" "$@"
