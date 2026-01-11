#!/usr/bin/env bash

set -euo pipefail

cbindgen --config cbindgen.toml --output binding.h
