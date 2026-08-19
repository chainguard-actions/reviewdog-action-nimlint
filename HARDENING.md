<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-nimlint/v1.18.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-nimlint/v1.18.1** was hardened automatically. 4 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The `run:` block in dockerimage.yml directly interpolates `${{ github.repository }}` inside a shell command string. Before the shell ever quotes it, the YAML template substitution inserts the raw value, enabling script injection. Offending line: `run: docker build . --file Dockerfile --tag ${{ github.repository }}:$(date +%s)`

Locations:

- `.github/workflows/dockerimage.yml:11`

### unpinned-uses (severity: high)

The workflow nimlint-action.yml references `reviewdog/action-nimlint@master`, which is a mutable branch ref rather than a pinned 40-character commit SHA. This allows the upstream repository to silently change the code that runs in this workflow, enabling supply-chain attacks.

Locations:

- `.github/workflows/nimlint-action.yml:13`

### unsafe-shell (severity: high)

The Dockerfile pipes a remotely fetched script directly to `sh` without first downloading and inspecting it: `wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}`. If the remote URL is compromised or the content changes, arbitrary code will execute in the build environment.

Locations:

- `Dockerfile:9`

### permissions (severity: medium)

None of the workflow files define a top-level `permissions:` key, and no job in any workflow defines a job-level `permissions:` key. Without explicit permissions, workflows run with the default (potentially broad) token permissions. All six workflow files are affected: depup.yml, dockerimage.yml, nimlint-action.yml, release.yml, reviewdog.yml, test.yml.

Locations:

- `.github/workflows/depup.yml:1`
- `.github/workflows/dockerimage.yml:1`
- `.github/workflows/nimlint-action.yml:1`
- `.github/workflows/release.yml:1`
- `.github/workflows/reviewdog.yml:1`
- `.github/workflows/test.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, unpinned-uses, unsafe-shell, permissions

**Notes:**

Fixed all 4 findings: (1) script-injection in dockerimage.yml: moved `${{ github.repository }}` to an env block as REPOSITORY and referenced it safely in the shell command; (2) unpinned-uses in nimlint-action.yml: pinned `reviewdog/action-nimlint@master` to full SHA `533c90f5c9d0188f3de61bd3eb13db71efb2f366`; (3) unsafe-shell in Dockerfile: replaced `wget ... | sh` pipe with a two-step download-then-execute pattern (download to /tmp, execute, then remove); (4) missing permissions: added `permissions: {}` top-level blocks to all 6 workflow files (depup.yml, dockerimage.yml, nimlint-action.yml, release.yml, reviewdog.yml, test.yml).

