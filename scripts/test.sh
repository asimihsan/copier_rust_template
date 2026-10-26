#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
ROOT_DIR=$(dirname "$SCRIPT_DIR")
"$ROOT_DIR/scripts/test-managed-tool-discovery.sh"
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

uv run --project "$ROOT_DIR" --locked copier copy "$ROOT_DIR" "$DEFAULT_RENDER_DIR" \
    --data project_name="Foobaz Default" \
    --data project_slug=foobaz-default \
    --data project_slug_underscore=foobaz_default \
    --data author_name="Local Test" \
    --data github_username="local-test" \
    --defaults --force

cd "$DEFAULT_RENDER_DIR"
git init
mise trust -y "$DEFAULT_RENDER_DIR/mise.toml"
./scripts/dev-setup.sh
mise install
mise run rust:check-format
mise run rust:test

uv run --project "$ROOT_DIR" --locked copier copy "$ROOT_DIR" "$FULL_RENDER_DIR" \
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
    --defaults --force

cd "$FULL_RENDER_DIR"
git init

mise trust -y "$FULL_RENDER_DIR/mise.toml"
./scripts/dev-setup.sh
touch mise.lock
mise install
mise run rust:check-format

mise run setup
mise run copyright
mise run ci

GO_WASM_RENDER_DIR="${RENDER_DIR}/go-wasm"

uv run --project "$ROOT_DIR" --locked copier copy "$ROOT_DIR" "$GO_WASM_RENDER_DIR" \
    --data include_go_wasm=true \
    --data project_name="Foobaz Go Wasm" \
    --data project_slug=foobaz-go-wasm \
    --data project_slug_underscore=foobaz_go_wasm \
    --data author_name="Local Test" \
    --data github_username="local-test" \
    --defaults --force

cd "$GO_WASM_RENDER_DIR"
git init

mise trust -y "$GO_WASM_RENDER_DIR/mise.toml"
./scripts/dev-setup.sh
touch mise.lock
mise install
mise run rust:check-format

mise run go-wasm:setup
mise run go-wasm:test
