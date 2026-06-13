<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-nimlint/v1.18.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **reviewdog--action-nimlint/v1.18.3** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile contains a RUN instruction that downloads a remote shell script and pipes it directly to `sh` without first saving it to a file for inspection. This pattern (`wget ... | sh`) allows arbitrary code execution if the remote URL is compromised or tampered with. The specific line is: `RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/fd59714416d6d9a1c0692d872e38e7f8448df4fc/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}`

Locations:

- `Dockerfile:9`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell

**Notes:**

Fixed the unsafe `wget | sh` pattern in the Dockerfile. The remote install script is now downloaded to `/tmp/install-reviewdog.sh` first, then executed separately with `sh`, and cleaned up afterward. The script URL was already pinned to a specific commit SHA (fd59714416d6d9a1c0692d872e38e7f8448df4fc), preserving integrity. This eliminates the risk of arbitrary code execution from a piped remote stream.

