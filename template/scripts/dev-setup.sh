#!/usr/bin/env bash

set -euo pipefail

# Install mise
if command -v mise >/dev/null 2>&1; then
    echo "mise is already installed"
else
    echo "mise is not installed"
    if command -v brew >/dev/null 2>&1; then
        echo "brew is installed"
        brew install mise
    else
        echo "brew is not installed"
        curl https://mise.run | sh
    fi
fi

mise settings add idiomatic_version_file_enable_tools rust

# Need to install rust first
if [[ -f rust-toolchain.toml ]]; then
    rust_version=$(awk -F'"' '/channel/ { print $2; exit }' rust-toolchain.toml)
elif [[ -f template/rust-toolchain.toml ]]; then
    rust_version=$(awk -F'"' '/channel/ { print $2; exit }' template/rust-toolchain.toml)
else
    rust_version="1.94.1"
fi

mise use "rust@${rust_version}"
