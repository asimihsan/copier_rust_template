#!/usr/bin/env bash

set -euo pipefail

rustup target add wasm32-wasip1

cd "${MISE_PROJECT_ROOT}/go-wasm/go"

go mod tidy
