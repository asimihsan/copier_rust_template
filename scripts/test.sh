#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
ROOT_DIR=$(dirname "$SCRIPT_DIR")
RENDER_DIR=${OUTPUT_DIR:-}
AUTO_RENDER_DIR=false

if [[ -z "$RENDER_DIR" ]]; then
    RENDER_DIR=$(mktemp -d "${TMPDIR:-/tmp}/copier-rust-template.XXXXXX")
    AUTO_RENDER_DIR=true
else
    if [[ -e "$RENDER_DIR" ]]; then
        echo "OUTPUT_DIR already exists: $RENDER_DIR" >&2
        exit 1
    fi
    mkdir -p "$(dirname "$RENDER_DIR")"
    mkdir -p "$RENDER_DIR"
fi

cleanup() {
    local exit_code=$?

    if [[ $exit_code -eq 0 && "$AUTO_RENDER_DIR" == "true" ]]; then
        rm -rf "$RENDER_DIR"
    else
        echo "Rendered project preserved at: $RENDER_DIR"
    fi

    return "$exit_code"
}

trap cleanup EXIT

DEFAULT_RENDER_DIR="${RENDER_DIR}/default"
FULL_RENDER_DIR="${RENDER_DIR}/full"

copier copy "$ROOT_DIR" "$DEFAULT_RENDER_DIR" \
    --data project_name="Foobaz Default" \
    --data project_slug=foobaz-default \
    --data project_slug_underscore=foobaz_default \
    --data author_name="Local Test" \
    --data github_username="local-test" \
    --force

cd "$DEFAULT_RENDER_DIR"
git init
./scripts/dev-setup.sh
mise install
mise run rust:test

copier copy "$ROOT_DIR" "$FULL_RENDER_DIR" \
    --data include_wasm=true \
    --data include_python=true \
    --data include_go=true \
    --data include_go_wasm=false \
    --data include_web_leptos=true \
    --data include_uniffi_sdk=true \
    --data project_name="Foobaz" \
    --data project_slug=foobaz \
    --data project_slug_underscore=foobaz \
    --data author_name="Local Test" \
    --data github_username="local-test" \
    --force

cd "$FULL_RENDER_DIR"
git init

mise trust -y "$FULL_RENDER_DIR/mise.toml"
./scripts/dev-setup.sh
touch mise.lock
mise install

mise run setup
mise run copyright
mise run ci
