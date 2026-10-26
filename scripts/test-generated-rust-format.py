"""Check Rustfmt on every profile with names on both sides of dependency imports."""

from __future__ import annotations

import os
import subprocess
import tempfile
from pathlib import Path

from copier import run_copy

ROOT = Path(__file__).resolve().parents[1]


def main() -> None:
    with tempfile.TemporaryDirectory(prefix="copier-rust-format-") as temporary:
        env = os.environ.copy()
        for key, directory in (
            ("MISE_CONFIG_DIR", "mise-config"),
            ("MISE_SYSTEM_CONFIG_DIR", "mise-system"),
            ("MISE_STATE_DIR", "mise-state"),
        ):
            env[key] = str(Path(temporary) / directory)
        env["MISE_GLOBAL_CONFIG_FILE"] = str(Path(env["MISE_CONFIG_DIR"]) / "config.toml")
        for slug in ("foobaz", "test-project"):
            for profile, choices in (
                ("default", {}),
                (
                    "full",
                    {
                        "include_wasm": True,
                        "include_python": True,
                        "include_go": True,
                        "include_web_leptos": True,
                        "include_uniffi_sdk": True,
                    },
                ),
                ("go-wasm", {"include_go_wasm": True}),
                ("wasm-and-wasi", {"include_wasm": True, "include_go_wasm": True}),
            ):
                destination = Path(temporary) / slug / profile
                run_copy(
                    str(ROOT),
                    destination,
                    data={
                        "project_name": "Test Project",
                        "project_slug": slug,
                        "project_slug_underscore": slug.replace("-", "_"),
                        "author_name": "CI Bot",
                        "github_username": "ci-bot",
                        **choices,
                    },
                    defaults=True,
                    overwrite=True,
                    quiet=True,
                    skip_tasks=True,
                )
                subprocess.run(
                    ["mise", "trust", str(destination / "mise.toml")],
                    check=True,
                    env=env,
                )
                subprocess.run(
                    ["mise", "install", "--locked", "--dry-run", "rust"],
                    cwd=destination,
                    check=True,
                    env=env,
                )
                subprocess.run(
                    ["cargo", "fmt", "--all", "--", "--check"],
                    cwd=destination,
                    check=True,
                    env=env,
                )
                print(f"generated Rustfmt: PASS ({slug}, {profile})", flush=True)


if __name__ == "__main__":
    main()
