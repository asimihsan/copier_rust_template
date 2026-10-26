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
