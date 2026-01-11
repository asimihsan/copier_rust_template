#!/usr/bin/env bash

set -euo pipefail

if [[ "$OSTYPE" == "darwin"* ]]; then
    cargo +nightly llvm-cov nextest --no-fail-fast --text --show-missing-lines --mcdc
else
    cargo llvm-cov nextest --no-fail-fast --text --show-missing-lines --mcdc
fi
