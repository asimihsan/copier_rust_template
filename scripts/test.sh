#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
ROOT_DIR=$(dirname "$SCRIPT_DIR")
pushd "$ROOT_DIR"
trap 'popd' EXIT

cd ~/workplace

rm -rf ~/workplace/foobaz
copier copy ~/workplace/copier_rust_template ~/workplace/foobaz \
    --data include_wasm=true \
    --data include_python=true \
    --data include_go=true \
    --data project_name="Foobaz" \
    --data project_slug=foobaz \
    --data project_slug_underscore=foobaz \
    --data author_name="Local Test" \
    --data github_username="local-test" \
    --force

cd ~/workplace/foobaz
git init

./scripts/dev-setup.sh
touch mise.lock
mise trust
mise install

mise setup
mise copyright
mise ci
mise go-wasm:setup
mise go-wasm:test
