<h1 align="center">Rust Core + CLI Starter</h1>
<p align="center">
  <em>Rust-first projects with opt-in WASM, Leptos, Python, Go, and UniFFI surfaces</em>
</p>

<p align="center">
  <a href="https://github.com/asimihsan/copier_rust_template/actions/workflows/ci.yml">
    <img src="https://img.shields.io/github/actions/workflow/status/asimihsan/copier_rust_template/ci.yml?style=flat-square" alt="CI Status">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg?style=flat-square" alt="License">
  </a>
</p>

A Rust-first Copier template for starting projects with a typed core crate and
CLI by default. Browser, language-binding, and SDK surfaces are opt-in instead
of part of the default render.

### Key Features

- Cross-platform Rust core and CLI by default
- Strict but usable workspace lints, Rust 1.96.1, resolver 3, and kache 0.8.0
- WASM and TypeScript web integration _(Optional)_
- Leptos CSR web app built without Trunk _(Optional)_
- Python and Go bindings _(Optional)_
- UniFFI SDK facade and generated binding checks _(Optional)_
- GitHub Actions CI pipeline and script-backed `mise` tasks

## Requirements

To use this template, you need to install the following tools:

- **[Mise](https://mise.jdx.dev/):** Installs and manages Rust, Node, Python, PNPM, and every other tool used by this template.
  If you don't have Mise yet, simply run `scripts/dev-setup.sh` and follow the prompts.
- **[Copier](https://copier.readthedocs.io/):** Generates a new project from
  this template.

## Quickstart

Generate your project:

```bash
copier copy gh:asimihsan/copier_rust_template my-awesome-project
```

Change into your new project directory:

```bash
cd my-awesome-project
git init
jj git init --colocate
```

Install dependencies (Mise will take care of everything):

```bash
./scripts/dev-setup.sh   # one-time, installs mise if missing
mise install             # installs the toolchain versions specified in mise.toml
```

Set up tools:

```bash
mise run setup
```

Add copyright header:

```bash
mise run copyright
```

Build and test your project:

```bash
mise run ci
```

## Development Tools & Workflow

The template provides a comprehensive development environment powered by Mise.
No manual tool installation required—everything from Rust nightly to
WebAssembly toolchains is automatically configured.

**Testing & Quality** Comprehensive test suites run across all platforms, with
coverage tracking and fuzz testing for core components. Automated CI pipelines
ensure consistent quality on every commit.

**Development Loop** Fast iteration with watch mode for Rust, explicit no-Trunk
Leptos builds when enabled, and automated rebuilds of Python extensions. Commands are
discovered from `mise-tasks/`, so `mise tasks` shows the generated workflow
surface directly.

🔧 Cargo, bun, and uv for dependency management  
🔍 Clippy and ESLint for static analysis  
✨ rustfmt and Prettier keep code clean  
📊 Code coverage and performance profiling

## Project Configuration

Choose your project components when generating from the template:

```bash
# Rust core + CLI default
copier copy gh:asimihsan/copier_rust_template my-project

# Core + WebAssembly and TypeScript web
copier copy gh:asimihsan/copier_rust_template my-project \
  --data include_wasm=true

# Core + Leptos web app without Trunk
copier copy gh:asimihsan/copier_rust_template my-project \
  --data include_web_leptos=true

# Core + Python bindings
copier copy gh:asimihsan/copier_rust_template my-project \
  --data include_python=true

# Core + Go bindings
copier copy gh:asimihsan/copier_rust_template my-project \
  --data include_go=true

# Core + UniFFI SDK facade and generated binding checks
copier copy gh:asimihsan/copier_rust_template my-project \
  --data include_uniffi_sdk=true
```

## Project Structure

Your generated project will include:

**Core Components**

- `crates/core/`: Your main Rust library codebase
- `crates/cli/`: Command-line interface implementation
- `Cargo.toml` & `deny.toml`: Rust project configuration
- `.rustfmt.toml`: Code formatting rules
- `mise-tasks/`: Script-backed developer commands

**Optional Components**

- `crates/wasm/`: WebAssembly module (when `include_wasm=true`)
- `web/`: TypeScript frontend (when `include_wasm=true`)
- `crates/python/`: Rust extension crate for Python bindings (when `include_python=true`)
- `python/`: Python packaging and tests (when `include_python=true`)
- `crates/go/`: Rust crate for Go bindings (when `include_go=true`)
- `crates/go-wasm/`: Rust crate for Go/WASI bindings (when `include_go_wasm=true`)
- `crates/web-leptos/`: Leptos CSR app built without Trunk (when `include_web_leptos=true`)
- `crates/sdk-ffi/` and `crates/uniffi-bindgen/`: UniFFI SDK facade and generator (when `include_uniffi_sdk=true`)

Flutter Rust Bridge is intentionally left to the sibling `flutter_template`
project, which owns the Flutter app, checked-in generated code policy, Dart
facades, and platform packaging.

**Development Environment**

- `mise.toml`: Toolchain configuration and common operations
- `.envrc`: Automatic environment activation
- `.watchmanconfig`: File-watcher ignore defaults carried over from `sheeptext`

## Testing

Run the full rendered-project validation locally:

```bash
mise run template:ci
```

If you want to inspect the rendered project after the run, set `OUTPUT_DIR`:

```bash
OUTPUT_DIR=/tmp/copier-rust-template-check mise run template:ci
```

## Contributing

If you find issues or have improvements to suggest, please open an issue or
submit a pull request.

## License

This project is licensed under the Mozilla Public License 2.0. See the
[LICENSE](LICENSE) file for details.
