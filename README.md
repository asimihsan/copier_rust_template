# Copier Rust Template

This template creates a Rust project with a command-line tool, a core library, a
WebAssembly module, and a TypeScript web app. It uses Copier to fill in the
templates based on your input.

## Requirements

To use this template, you need to install the following tools:

- **[Devbox](https://www.jetify.com/docs/devbox/):** Sets up your development
  environment by installing Rust, wasm‑pack, Node, PNPM, and Mise automatically.
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

Enter the Devbox shell:

```bash
devbox install
devbox run direnv allow
```

Set up tools:

```bash
just setup
```

Add copyright header:

```bash
just copyright
```

Build and test your project:

```bash
just ci
```

## Overview

This template is designed to help you quickly start a project that includes
several components:

- **CLI:** A simple Rust command-line tool.
- **Core Library:** A Rust library for your main logic.
- **Wasm Module:** A Rust module that compiles to WebAssembly.
- **Web App:** A TypeScript web application that uses the WebAssembly module.

The project is set up to use Devbox and Mise for a consistent environment and
task management. With Devbox, you don’t need to install Rust, wasm‑pack, Node,
or PNPM separately—everything is managed for you.

## Template Structure

- **Root Files:**  
  Files like `Cargo.toml`, `LICENSE`, `rustfmt.toml`, and `deny.toml` set up
  project-wide configurations.

- **Jinja Templates:**  
  Files ending in `.jinja` (such as `Cargo.toml.jinja` and `README.md.jinja`)
  are processed by Copier. They get filled in with your project details (name,
  slug, author, etc.) when you run Copier.

- **cli:**  
  Contains the Rust code for a command-line tool.

- **core:**  
  Contains a Rust library for your core logic.

- **wasm:**  
  Contains Rust code that is compiled to WebAssembly using tools like
  `wasm-pack`.

- **web:**  
  Contains a TypeScript web app that uses Vite, ESLint, and Vitest for
  development and testing.

- **Devbox and Mise Files:**
  - `devbox.json`: Defines the development environment.
  - `mise.toml.jinja`: A configuration file for Mise, a simple task runner used
    to run builds, tests, and other commands.

## How to Use This Template

1. **Install the Requirements:**  
   Install Devbox and Copier. Devbox will set up your environment by installing
   all required tools.

2. **Create a New Project:**  
   Run Copier to generate your project:
   ```bash
    copier copy gh:asimihsan/copier_rust_template my-awesome-project
   ```
   Copier will ask for your project’s name, slug, and author. It then fills in
   the template files accordingly.
3. **Enter Your Project’s Environment**: Change to your new project directory
   and set up Devbox:
   ```bash
   cd my-awesome-project
   devbox install
   devbox run direnv allow
   ```
4. **Set Up Tools**: Run the setup command to install dependencies and set up
   your project:
   ```bash
   just setup
   ```
5. **Add Copyright Header**: Run the copyright command to add a copyright header
   to your files:
   ```bash
   just copyright
   ```
6. **Build, Test, and Run Commands**:
   ```bash
   just ci
   ```

## Contributing

If you find issues or have improvements to suggest, please open an issue or
submit a pull request.

## License

This project is licensed under the Mozilla Public License 2.0. See the
[LICENSE](LICENSE) file for details.
