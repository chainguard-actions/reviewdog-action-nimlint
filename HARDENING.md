<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-nimlint/v1.22.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-nimlint/v1.22.0** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile pipes a remotely fetched shell script directly into `sh` without first saving it to disk for inspection. The pattern `wget -O - -q https://...install.sh | sh` executes whatever content is returned by the remote URL, making the build vulnerable to supply-chain attacks if the remote content is tampered with. The script should be downloaded to a file, its integrity verified (e.g. via checksum), and then executed separately.

Locations:

- `Dockerfile:10`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell

**Notes:**

Fixed Dockerfile line 10: replaced `wget -O - -q ... | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}` with a two-step approach that downloads the install script to /tmp/install-reviewdog.sh first, then executes it separately as `sh /tmp/install-reviewdog.sh -b /usr/local/bin/ ${REVIEWDOG_VERSION}`, and finally removes the temp file. The `-s` and `--` shell options were dropped (they were stdin-reading and option-terminator flags for the pipe form; keeping `--` would have passed it as $1 to the script, breaking the installer).

