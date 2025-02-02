# Copier Rust Template

This template creates a Rust project with a command-line tool, a core library, a WebAssembly module,
and a TypeScript web app. It uses Copier to fill in the templates based on your input.

## Requirements

To use this template, you need to install the following tools:

- **[Devbox](https://www.jetify.com/docs/devbox/):** Sets up your development environment by installing Rust,
  wasm‑pack, Node, PNPM, and Mise automatically.
- **[Copier](https://copier.readthedocs.io/):** Generates a new project from this template.

## Quickstart

Generate your project:

```bash
copier gh:asimihsan/copier_rust_template my-awesome-project
```

Change into your new project directory:

```bash
cd my-awesome-project
git init
jj git init --colocate
```

Enter the Devbox shell:

```bash
direnv allow
devbox install
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

This template is designed to help you quickly start a project that includes several components:

- **CLI:** A simple Rust command-line tool.
- **Core Library:** A Rust library for your main logic.
- **Wasm Module:** A Rust module that compiles to WebAssembly.
- **Web App:** A TypeScript web application that uses the WebAssembly module.

The project is set up to use Devbox and Mise for a consistent environment and task management. With
Devbox, you don’t need to install Rust, wasm‑pack, Node, or PNPM separately—everything is managed
for you.

## Template Structure

- **Root Files:**  
  Files like `Cargo.toml`, `LICENSE`, `rustfmt.toml`, and `deny.toml` set up project-wide
  configurations.

- **Jinja Templates:**  
  Files ending in `.jinja` (such as `Cargo.toml.jinja` and `README.md.jinja`) are processed by
  Copier. They get filled in with your project details (name, slug, author, etc.) when you run
  Copier.

- **cli:**  
  Contains the Rust code for a command-line tool.

- **core:**  
  Contains a Rust library for your core logic.

- **wasm:**  
  Contains Rust code that is compiled to WebAssembly using tools like `wasm-pack`.

- **web:**  
  Contains a TypeScript web app that uses Vite, ESLint, and Vitest for development and testing.

- **Devbox and Mise Files:**  
  - `devbox.json`: Defines the development environment.  
  - `mise.toml.jinja`: A configuration file for Mise, a simple task runner used to run builds,
    tests, and other commands.

## How to Use This Template

1. **Install the Requirements:**  
   Install Devbox and Copier. Devbox will set up your environment by installing all required tools.

2. **Create a New Project:**  
   Run Copier to generate your project:
   ```bash
   copier gh:yourusername/copier_rust_template my-awesome-project

Copier will ask for your project’s name, slug, and author. It then fills in the template files
	accordingly. 3.	Enter Your Project’s Environment: Change to your new project directory and start
the Devbox shell:

cd my-awesome-project devbox shell


	4.	Build, Test, and Run Commands: •	For Rust components (CLI, core library, Wasm module):

cargo build cargo test


	•	For the web application (inside the web folder):

cd web pnpm install pnpm run build pnpm run test



Contributing

If you find issues or have improvements to suggest, please open an issue or submit a pull request.

License

This project is licensed as described in the LICENSE file.

---

### Chain-of-Thought and Confidence Ratings

1. **Requirements & Quickstart:**  
   I focused on clearly stating that Devbox and Copier are needed, and I explained that Devbox
   installs the necessary tools (Rust, wasm‑pack, Node, PNPM, and Mise).  
   *Confidence: 5/5 – The instructions reflect the new dependency setup and quickstart guidelines.*

2. **Template Structure and Usage:**  
   I restructured the content to be simpler and more direct, avoiding superlatives and explaining
   the role of each component.  
   *Confidence: 5/5 – The structure directly follows the provided directory tree and output
   details.*

3. **Commands and Instructions:**  
   The instructions now include a quickstart section, followed by detailed steps on generating and
   using the project.  
   *Confidence: 5/5 – The commands match standard workflows for projects created with Copier and
   managed by Devbox.*

This README should now meet your requirements for clarity, simplicity, and direct instructions.
