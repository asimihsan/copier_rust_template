#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
GENERATOR="${ROOT_DIR}/template/mise-tasks/"'{{"go" if include_go else "__skip_go__"}}/generate-bindings'
FIXTURE=$(mktemp -d "${TMPDIR:-/tmp}/copier-managed-tool.XXXXXX")
trap 'rm -rf "$FIXTURE"' EXIT
mkdir -p "$FIXTURE/bin" "$FIXTURE/managed" "$FIXTURE/project/crates/go"
export MISE_PROJECT_ROOT="$FIXTURE/project"
export MANAGED_CBINDGEN="$FIXTURE/managed/cbindgen"
export STALE_TOOL_MARKER="$FIXTURE/stale-tool-invoked"
export VERSION_MARKER="$FIXTURE/version-checked"
export MANAGED_TAILWIND="$FIXTURE/managed/tailwindcss"
export LEPTOS_BUILD_HELPER="$ROOT_DIR/template/mise-tasks/lib/web-leptos-build"
export MANAGED_AUDIT="$FIXTURE/managed/cargo-audit"
export MANAGED_DENY="$FIXTURE/managed/cargo-deny"
export SECURITY_MARKERS="$FIXTURE/managed"
export MANAGED_WASM_BINDGEN="$FIXTURE/managed/wasm-bindgen"
export MANAGED_WASM_PACK="$FIXTURE/managed/wasm-pack"

cat > "$FIXTURE/bin/mise" <<'SH'
#!/bin/sh
set -eu
[ "$#" = 2 ]
if [ "$1" = run ] && [ "$2" = rust:ensure-wasm-target ]; then exit 0; fi
[ "$1" = which ]
case "$2" in
    cbindgen) printf '%s\n' "$MANAGED_CBINDGEN" ;;
    tailwindcss) printf '%s\n' "$MANAGED_TAILWIND" ;;
    cargo-audit) printf '%s\n' "$MANAGED_AUDIT" ;;
    cargo-deny) printf '%s\n' "$MANAGED_DENY" ;;
    wasm-bindgen) printf '%s\n' "$MANAGED_WASM_BINDGEN" ;;
    wasm-pack) printf '%s\n' "$MANAGED_WASM_PACK" ;;
    *) exit 98 ;;
esac
SH
cat > "$FIXTURE/bin/cbindgen" <<'SH'
#!/bin/sh
touch "$STALE_TOOL_MARKER"
exit 99
SH
cat > "$MANAGED_CBINDGEN" <<'SH'
#!/bin/sh
set -eu
if [ "$1" = --version ]; then
    [ "${INCOMPATIBLE_TOOL:-0}" = 0 ] || exit 126
    touch "$VERSION_MARKER"
    printf '%s\n' 'cbindgen 0.29.2'
else
    [ -f "$VERSION_MARKER" ]
    [ "$#" = 4 ] && [ "$1" = --config ] && [ "$3" = --output ]
    printf '%s\n' 'generated header' > "$4"
fi
SH
chmod +x "$FIXTURE/bin/mise" "$FIXTURE/bin/cbindgen" "$MANAGED_CBINDGEN"
export PATH="$FIXTURE/bin:$PATH"

/bin/bash "$GENERATOR"
test -f "$FIXTURE/project/crates/go/binding.h"
test ! -e "$STALE_TOOL_MARKER"
rm "$FIXTURE/project/crates/go/binding.h" "$VERSION_MARKER"

if INCOMPATIBLE_TOOL=1 /bin/bash "$GENERATOR" > "$FIXTURE/incompatible.log" 2>&1; then
    echo 'incompatible managed tool unexpectedly succeeded' >&2
    exit 1
fi
test ! -e "$FIXTURE/project/crates/go/binding.h"
if MANAGED_CBINDGEN="$FIXTURE/missing" /bin/bash "$GENERATOR" > "$FIXTURE/missing.log" 2>&1; then
    echo 'missing managed tool unexpectedly succeeded' >&2
    exit 1
fi
test ! -e "$FIXTURE/project/crates/go/binding.h"
test ! -e "$STALE_TOOL_MARKER"

cat > "$MANAGED_TAILWIND" <<'SH'
#!/bin/sh
exit 126
SH
chmod +x "$MANAGED_TAILWIND"
leptos_status=0
/bin/bash -c '
set -euo pipefail
source "$LEPTOS_BUILD_HELPER"
project_repo_root() { printf "%s\n" "$MISE_PROJECT_ROOT"; }
project_build_web_leptos
' > "$FIXTURE/tailwind.log" 2>&1 || leptos_status=$?
test "$leptos_status" = 126
test ! -e "$MISE_PROJECT_ROOT/target"

cp "$FIXTURE/bin/cbindgen" "$FIXTURE/bin/cargo"
cat > "$MANAGED_AUDIT" <<'SH'
#!/bin/sh
set -eu
case "$1" in
    --version) echo 'cargo-audit 0.22.2' ;;
    audit) touch "$SECURITY_MARKERS/audit-completed" ;;
    *) exit 98 ;;
esac
SH
cat > "$MANAGED_DENY" <<'SH'
#!/bin/sh
set -eu
case "$1" in
    --version) echo 'cargo-deny 0.19.0' ;;
    deny) test "$2" = check; touch "$SECURITY_MARKERS/deny-completed" ;;
    *) exit 98 ;;
esac
SH
chmod +x "$FIXTURE/bin/cargo" "$MANAGED_AUDIT" "$MANAGED_DENY"
/bin/bash "$ROOT_DIR/template/mise-tasks/rust/audit"
test -f "$SECURITY_MARKERS/audit-completed"
test -f "$SECURITY_MARKERS/deny-completed"
test ! -e "$STALE_TOOL_MARKER"
mkdir -p "$FIXTURE/project/crates/wasm" "$FIXTURE/project/web"
cat > "$FIXTURE/bin/wasm-bindgen" <<'SH'
#!/bin/sh
touch "$STALE_TOOL_MARKER"
exit 99
SH
cat > "$MANAGED_WASM_BINDGEN" <<'SH'
#!/bin/sh
[ "$1" = --version ]
printf '%s\n' 'wasm-bindgen 0.2.126'
SH
cat > "$MANAGED_WASM_PACK" <<'SH'
#!/bin/sh
set -eu
[ "$(command -v wasm-bindgen)" = "$MANAGED_WASM_BINDGEN" ]
case " $* " in *" --mode no-install "*) ;; *) exit 98 ;; esac
wasm-bindgen --version
touch "$SECURITY_MARKERS/wasm-completed"
SH
cat > "$FIXTURE/bin/bun" <<'SH'
#!/bin/sh
[ "$1" = install ]
SH
chmod +x "$FIXTURE/bin/wasm-bindgen" "$FIXTURE/bin/bun" "$MANAGED_WASM_BINDGEN" "$MANAGED_WASM_PACK"
WASM_SETUP="$ROOT_DIR/template/mise-tasks/"'{{"web" if include_wasm else "__skip_web__"}}/setup.jinja'
/bin/bash "$WASM_SETUP"
test -f "$SECURITY_MARKERS/wasm-completed"
test ! -e "$STALE_TOOL_MARKER"
rm "$SECURITY_MARKERS/wasm-completed"
if MANAGED_WASM_BINDGEN="$FIXTURE/missing" /bin/bash "$WASM_SETUP" > "$FIXTURE/missing-wasm.log" 2>&1; then
    echo 'missing managed wasm-bindgen unexpectedly succeeded' >&2
    exit 1
fi
test ! -e "$SECURITY_MARKERS/wasm-completed"
test ! -e "$STALE_TOOL_MARKER"
echo 'managed tool discovery: PASS (shadowed, incompatible, missing, Tailwind, security and Wasm tools)'
