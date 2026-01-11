#!/usr/bin/env bash

set -euxo pipefail

source "${MISE_PROJECT_ROOT}/scripts/tasks/go-env.sh"

go test ./...
