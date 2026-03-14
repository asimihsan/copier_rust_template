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
mise use "rust@1.94.0"
