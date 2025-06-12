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

# Need to install rust first
mise use "rust@prefix:1.87"