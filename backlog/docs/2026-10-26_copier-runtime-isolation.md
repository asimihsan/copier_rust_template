# Copier runtime isolation and generated tool ownership

The root tooling uses Copier 9.19.1 in a locked uv project environment on Python 3.14.7. Removing the Mise pipx request prevents unrelated global Python upgrades from reinstalling this project-only CLI against an incompatible interpreter. Local rendering and GitHub generation both invoke `uv run --locked copier`.

## Compatibility repairs exposed by the complete gate

- Generated uv is pinned to 0.12.20 because 0.11.2 cannot read the managed workstation's `tool-install-locks` preview setting.
- Go binding generation and security checks resolve the configured Mise binaries and run their version checks. The workstation had an x86 cbindgen and cargo-audit 0.21.2 in its Cargo bin directory; the latter could not parse current RustSec CVSS 4 advisories. Those unrelated host files remain untouched. The generated audit pin is now 0.22.2.
- The official Tailwind 4.1.18 macOS ARM asset matched its published SHA-256 digest but was killed by macOS. Tailwind 4.3.3 matched its official digest and passed real CSS generation. The build now checks the managed CLI before expensive Wasm compilation. No signing workaround was applied.
- macOS UniFFI smoke uses Xcode's Swift compiler with its matching SDK. The old Mise Swift 6.3.3 toolchain failed Foundation module loading against the current host SDK; Xcode Swift 6.4 passed the actual binding smoke. Linux retains its pinned Mise Swift 6.3.3 toolchain.
- Markdown lint explicitly runs compatible markdownlint-cli2 0.23.2 under Bun, avoiding inactive workstation shims. Version 0.24 rejects the existing JavaScript front-matter regex. The rules were preserved, including a failing MD009 negative control.
- Core and Go/Wasm template expressions now match Rustfmt output. Every profile checks Rust formatting before proceeding with its expensive build stages.

## Validation

The final cold `mise run template:ci` exited zero across the default, full optional, and Go/Wasm profiles. Evidence is `template-ci-terminal.log` in the private recovery directory. The default profile ran five Rust tests. The full profile passed ten Rust tests, one web test, three Python tests, native Go tests, actual Python/Swift/Kotlin UniFFI calls, coverage, freshness reporting, Cargo audit and Cargo deny. Go/Wasm passed nine tests covering greetings, concurrency, cancellation, timestamps and memory cleanup.

Fresh renders of all three profiles passed Rustfmt checks. Managed-tool regressions exercise shadowed host commands, incompatible and missing managed executables, early Tailwind failure, and security-tool ownership; GitHub CI runs these before rendering. ShellCheck and `git diff --check` passed.

The audit retains two existing allowed unmaintained-dependency warnings for `basic-toml` and `paste`. No advisory exceptions or weakened checks were added. This evidence is local macOS ARM runtime validation; remote Linux CI is a separate result.

## Review and recovery

Independent Codex review accepted the original migration and tool-discovery correction (session `01a177ce-7486-7dd3-bd7d-6fd9eafef493`) and the bounded late compatibility increment (session `01a1780e-51bd-7750-8730-f10d7f6af6de`) without actionable findings. The late frozen source revision was `04778789c9eec57f5c82c5c4b9ce55ea8613ef4f`.

The initial repository was clean at parent `18319fd9`; the existing remote default branch is `master`. Private recovery snapshots, terminal logs, and the original Tailwind asset are retained under `~/.local/state/dotfiles-recovery/20261026T102727Z/copier_rust_template`. Publication follows the accepted reviews and green local gate; remote CI must be reported separately.

## GNU Linux CI follow-up

The first published revision, `0f0fee2003fa3c127b748b670dc3db3eefc776cb`, passed the local macOS gate but its Linux CI full profile failed before building. Mise 2026.10.19 generated Swift lock metadata for the baseline lockfile's musl platforms, which Swift does not publish. The six dependent matrix jobs were skipped.

The optional SDK profile now declares four native lock targets: GNU Linux arm64/x64 and macOS arm64/x64. Other profiles retain their existing broader platform behavior. A three-profile rendering regression runs in the local gate and GitHub CI before generation; it also preserves Swift's Linux-only Mise host gate.

An isolated real Mise probe confirmed that this project policy overrides broader global settings and existing baseline coverage, resolved the four supported Swift targets, and reproduced the genuine backend rejection for an explicit musl target. Swift stores host-specific distro options in separate lock entries, so coverage must be checked across all entries. No toolchain was installed. Full lock resolution nevertheless cached large Swift archives; it must not be treated as a cheap HEAD-only operation. Subsequent inspection was capped at 16 MiB, and the committed regression only renders configurations. New exact-head Linux CI remains the application-level verification.

## Project-name formatting follow-up

Exact-head Linux CI at `71b7cfbad56ddd2c83222002c2c44c61d92412ba` passed generated Leptos compilation and Tailwind generation, then failed Rustfmt on Python and Leptos imports. The CI slug `test-project` sorts after external dependencies; the earlier local `foobaz` slug sorts before them. Project imports now occupy separate groups from external and standard-library imports, including the analogous Go/Wasm case. No runtime behavior changed.

The new formatting regression renders default, full optional, and Go/Wasm profiles with both `foobaz` and the exact CI slug `test-project`. All six passed the generated pinned Rustfmt check. A disposable negative control restored the old Python import order and failed Rustfmt as expected. Ruff, ShellCheck, shell syntax and `git diff --check` passed. Local and GitHub gates run the regression; GitHub also checks its actual generated project immediately after generation, before setup or compilation. Remote Linux CI for the new revision remains a separate required result.

## Early Rustfmt prerequisite

The next Linux CI run at `82ec7e3d163dd0cc054be51a153b4e658181cf06` reached the new early formatting check before generated setup had installed Rustfmt. Listing components in `rust-toolchain.toml` did not provision them in the active Mise toolchain. The early step now invokes the existing generated `rust/ensure-components` helper before checking formatting and running the six-render regression; the expensive setup and build remain later.

A disposable minimal Rust 1.96.1 toolchain with private `RUSTUP_HOME` and `CARGO_HOME` reproduced the missing `cargo-fmt` error. The generated helper installed its required components, after which the exact full CI render and all six name/profile renders passed formatting. The temporary toolchain was removed on exit, and no builds or live toolchain changes were required. Evidence is `early-format-components-clean-proof.log`; ShellCheck, shell syntax and `git diff --check` passed. The host proof is macOS ARM; exact-head Linux CI remains required.

## Mise owns early Rust component provisioning

The user correctly questioned the separate helper call: generated Mise configuration already declares Rust components and targets. Installed Mise2026.10.19 repairs missing configured components for an existing toolchain. The early CI check now runs `mise install --locked rust` before formatting, using the committed configuration directly and avoiding unrelated automatic lock generation.

A disposable APFS clone of the installed Rust1.96.1 toolchain reproduced missing cargo-fmt after explicit removal. Native locked Mise installation restored rustfmt from the declared component list, and the lockfile hash stayed unchanged. The clone and isolated Mise/Rustup/Cargo homes were cleaned; the live toolchain was untouched. The prior plain-install probe triggered unrelated lock resolution and exhausted temporary disk space before cleanup, so it is failed evidence, not proof of component repair. The successful locked probe is recorded in `mise-locked-components-proof.log` in private recovery storage.

## Generated Python documentation lint

Exact-head Linux CI86c18871 passed both early format checks and built the generated project, then strict Clippy identified Python interactive examples as prose. The underscore in CI's `test_project` name exposed `clippy::doc_markdown`, which the previous full local fixture name `foobaz` did not trigger. The examples now use an explicit fenced Python block. The local full fixture uses the exact CI project name and slug so the existing strict Clippy gate covers this naming boundary before publication.

The first rerun of the full local gate also exposed test-environment leakage: fixture `mise use`/unlocked installs regenerated workstation-global lock metadata under inherited global configuration. Tool membership and versions were unchanged, but additional platform metadata appeared. That task-owned run was intentionally stopped (143), its live state was backed up, and only the generated global lock drift was restored from the reviewed ChezMoi source. The whole ChezMoi diff returned to zero. The gate now uses its own global/system Mise configuration paths throughout the process, while reusing installed tool payloads and caches. Global configuration and lock hashes are checked before and after the isolated gate.

The isolated environment also exposed inherited trust in the six-render format probe. It now explicitly trusts each fixture it generates from the current repository before invoking Cargo through Mise's shim. Render-root paths are made absolute before they become Mise configuration paths.

## Locked Rust option coverage

Linux CI51a246bd rejected the native locked prerequisite because the shared lock contained only the base Rust component options. The full profile requests an additional Wasm target, making it a distinct locked request. This is an option mismatch, not Linux-specific platform coverage: an isolated installed-Mise dry-run reproduced it on macOS for Wasm, WASI, and combined targets. Native `mise lock rust` produced matching records for all four combinations without installing tools. Those records were added alongside the unchanged base entry, preserving all unrelated lock metadata.

The rendering regression now covers eight name/profile combinations, including combined Wasm/WASI. Each explicitly trusts its generated fixture, requires `mise install --locked --dry-run rust` to accept the exact options, and then runs actual Rustfmt. The prior complete isolated three-profile gate remains build/runtime evidence; the new option-binding checks exercise the final lock change directly.

The standalone rendering probe now also owns its Mise global/system configuration and trust-state paths, so direct invocation receives the same isolation as the full local gate. Installed payloads and download caches remain reusable; generated project installs cannot inherit workstation post-install hooks or rewrite its managed lock.

## Wasm-only managed CLI coverage

At850c5883 the full Linux profile and default matrix passed. Wasm-only exposed an undeclared tool: a restored orphan wasm-bindgen shim was visible to wasm-pack, while only Leptos declared the CLI. The Wasm crate also floated to0.2.129 while the shared managed CLI was0.2.126. Wasm now declares the same exact CLI and crate version as Leptos. Setup resolves absolute managed wasm-pack/wasm-bindgen binaries, prepends the latter's directory for child discovery, and uses wasm-pack's no-install mode. Rendering checks require exact CLI/crate alignment. Matrix fail-fast is disabled so independent profiles finish and report evidence even when another fails.

A real isolated Wasm-only render built bindings and passed its web test with a deliberately failing wasm-bindgen first on PATH; that stale executable was never invoked. Managed-tool regressions also reject a missing managed CLI. All eight locked Rust/format renders require CLI/crate alignment and pass, with Ruff/ShellCheck clean. Evidence: `wasm-only-real-poisoned-path.log` and `wasm-cli-eight-profile.log` in private recovery storage.
