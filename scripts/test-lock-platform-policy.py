"""Ensure optional SDK locks target native hosts without narrowing other profiles."""

from __future__ import annotations

import tempfile
import tomllib
from pathlib import Path

from copier import run_copy

ROOT = Path(__file__).resolve().parents[1]
SDK_PLATFORMS = ["linux-arm64", "linux-x64", "macos-arm64", "macos-x64"]


def main() -> None:
    with tempfile.TemporaryDirectory(prefix="copier-platform-policy-") as temporary:
        for profile, choices in (
            ("default", {}),
            ("sdk", {"include_uniffi_sdk": True}),
            ("go-wasm", {"include_go_wasm": True}),
        ):
            destination = Path(temporary) / profile
            run_copy(
                str(ROOT),
                destination,
                data={
                    "project_name": "Lock Probe",
                    "project_slug": "lock-probe",
                    "project_slug_underscore": "lock_probe",
                    "author_name": "Test",
                    "github_username": "test",
                    **choices,
                },
                defaults=True,
                overwrite=True,
                quiet=True,
                skip_tasks=True,
            )
            config = tomllib.loads((destination / "mise.toml").read_text())
            platforms = config["settings"].get("lockfile_platforms")
            if profile == "sdk":
                if platforms != SDK_PLATFORMS:
                    raise AssertionError("SDK lock platforms changed unexpectedly")
                if config["tools"]["swift"]["os"] != ["linux"]:
                    raise AssertionError("Swift host gate changed")
            elif platforms is not None:
                raise AssertionError(f"{profile} lost its broader platform policy")
    print("generated lock platform policy: PASS (default, SDK, Go/Wasm)")


if __name__ == "__main__":
    main()
