<h1 align="center">🦀 Rust Multi-Platform Starter</h1>
<p align="center">
  <em>Build Once, Run Everywhere: CLI • WASM • Python • Go</em>
</p>

<p align="center">
  <a href="https://github.com/asimihsan/copier_rust_template/actions/workflows/ci.yml">
    <img src="https://img.shields.io/github/actions/workflow/status/asimihsan/copier_rust_template/ci.yml?style=flat-square" alt="CI Status">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg?style=flat-square" alt="License">
  </a>
</p>

A unified Rust template for building native CLIs, WebAssembly modules,
Python extensions, and Go bindings from a single codebase.

### 🎯 Key Features

- 🦀 Cross-platform Rust core
- 🌐 WASM bindings with web integration _(Optional)_
- 🐍 Python bindings _(Optional)_
- 🦫 Go bindings _(Optional)_
- 🚀 GitHub Actions CI pipeline
- 🛠️ Zero-config setup
- 📊 Comprehensive testing

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
mise setup
```

Add copyright header:

```bash
mise copyright
```

Build and test your project:

```bash
mise ci
```

## Development Tools & Workflow

The template provides a comprehensive development environment powered by Mise.
No manual tool installation required—everything from Rust nightly to
WebAssembly toolchains is automatically configured.

**Testing & Quality** Comprehensive test suites run across all platforms, with
coverage tracking and fuzz testing for core components. Automated CI pipelines
ensure consistent quality on every commit.

**Development Loop** Fast iteration with hot reloading for web development,
watch mode for Rust, and automated rebuilds of Python extensions. The
development environment includes:

🔧 Cargo, pnpm, and uv for dependency management  
🔍 Clippy and ESLint for static analysis  
✨ rustfmt and Prettier keep code clean  
📊 Code coverage and performance profiling

## Project Configuration

Choose your project components when generating from the template:

```bash
# Full-featured project (default)
copier copy gh:asimihsan/copier_rust_template my-project

# Core + WebAssembly only
copier copy gh:asimihsan/copier_rust_template my-project \
  --data include_python=false \
  --data include_go=false

# Core + Python bindings only
copier copy gh:asimihsan/copier_rust_template my-project \
  --data include_wasm=false \
  --data include_go=false

# Core + Go bindings only
copier copy gh:asimihsan/copier_rust_template my-project \
  --data include_wasm=false \
  --data include_python=false

# Core functionality only
copier copy gh:asimihsan/copier_rust_template my-project \
  --data include_wasm=false \
  --data include_python=false \
  --data include_go=false
```

## Project Structure

Your generated project will include:

**Core Components**

- `core/`: Your main Rust library codebase
- `cli/`: Command-line interface implementation
- `Cargo.toml` & `deny.toml`: Rust project configuration
- `.rustfmt.toml`: Code formatting rules

**Optional Components**

- `wasm/`: WebAssembly module (when `include_wasm=true`)
- `web/`: TypeScript frontend (when `include_wasm=true`)
- `python/`: Python language bindings (when `include_python=true`)
- `go/`: Go language bindings (when `include_go=true`)

**Development Environment**

- `mise.toml`: Toolchain configuration and common operations
- `.envrc`: Automatic environment activation
- `.pre-commit-config.yaml`: Git hooks for quality checks

## Testing

```plain
cd ~/workplace && \
    rm -rf ~/workplace/foobaz && \
    copier copy ~/workplace/copier_rust_template ~/workplace/foobaz \
        --data include_wasm=true \
        --data include_python=true \
        --data include_go=true \
        --data project_name="Foobaz" \
        --data project_slug=foobaz \
        --data project_slug_underscore=foobaz \
        --data author_name="Local Test" \
        --force && \
    cd ~/workplace/foobaz && \
    git init && \
    ./scripts/dev-setup.sh && \
    mise install && \
    mise setup && \
    mise copyright && \
    mise ci ; \
    cd go-wasm && \
    mise go-wasm:setup && \
    mise go-wasm:test && \
    cd ..
```

## Contributing

If you find issues or have improvements to suggest, please open an issue or
submit a pull request.

## License

This project is licensed under the Mozilla Public License 2.0. See the
[LICENSE](LICENSE) file for details.
