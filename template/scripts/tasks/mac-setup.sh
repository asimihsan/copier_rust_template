#!/usr/bin/env bash

set -euo pipefail

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "This script is only for macOS."
    exit 1
fi

if ! command -v brew &> /dev/null; then
    echo "brew command not found, please install Homebrew first."
    exit 1
fi

brew install libiconv llvm
rustup component add llvm-tools-preview
rustup component add llvm-tools-preview --toolchain nightly-aarch64-apple-darwin
if ! xcode-select -p >/dev/null 2>&1; then
    xcode-select --install
    sudo xcode-select --switch /Library/Developer/CommandLineTools
fi
