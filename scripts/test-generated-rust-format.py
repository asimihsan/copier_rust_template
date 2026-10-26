"""Check Rustfmt on every profile with names on both sides of dependency imports."""

from __future__ import annotations

import subprocess
import tempfile
from pathlib import Path

from copier import run_copy

ROOT = Path(__file__).resolve().parents[1]


def main() -> None:
    with tempfile.TemporaryDirectory(prefix="copier-rust-format-") as temporary:
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
                )
                subprocess.run(
                    ["cargo", "fmt", "--all", "--", "--check"],
                    cwd=destination,
                    check=True,
                )
                print(f"generated Rustfmt: PASS ({slug}, {profile})", flush=True)


if __name__ == "__main__":
    main()
