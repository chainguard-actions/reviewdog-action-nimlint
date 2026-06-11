<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-nimlint/v1.19.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **reviewdog--action-nimlint/v1.19.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile pipes a remotely fetched script directly to `sh` without first saving it to a file for inspection. The command `wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/.../install.sh | sh -s -- ...` executes whatever content is served at that URL immediately in a shell. Even though the URL references a specific commit SHA in the path, the pattern itself is unsafe-shell.

Locations:

- `Dockerfile:11`

### script-injection (severity: high)

Rule (b) violation: In entrypoint.sh, the variable `$INPUT_SRC` (sourced from the `src` action input, which is caller-controlled) is used unquoted in a `for` loop: `for f in $INPUT_SRC; do`. Without double-quoting, the shell performs word-splitting and glob expansion on the value, allowing an attacker to inject shell metacharacters (e.g. spaces, globs, semicolons) via the `src` input to manipulate the loop or inject additional arguments.

Locations:

- `entrypoint.sh:14`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell, script-injection

**Notes:**

1. Dockerfile (unsafe-shell): Replaced `wget -O - -q <url> | sh -s -- ...` with a two-step approach: download the script to /tmp/install-reviewdog.sh, execute it with `sh /tmp/install-reviewdog.sh`, then remove it. This eliminates the pipe-to-shell anti-pattern while preserving the same pinned commit SHA in the URL.
2. entrypoint.sh (script-injection): Changed `for f in $INPUT_SRC` to `for f in "$INPUT_SRC"` to prevent word-splitting and glob expansion on the caller-controlled `src` input, eliminating the shell metacharacter injection vector.

