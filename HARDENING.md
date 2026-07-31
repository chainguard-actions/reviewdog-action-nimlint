<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-nimlint/v1.20.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-nimlint/v1.20.0** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a) violation: `${{ github.repository }}` is interpolated directly inside a `run:` shell command string. An attacker who can control the repository name (e.g. via a fork or repository rename) could inject arbitrary shell commands. The offending line is: `run: docker build . --file Dockerfile --tag ${{ github.repository }}:$(date +%s)`. Fix by moving the value into an `env:` variable and double-quoting it in the shell: `env: REPO: ${{ github.repository }}` then `run: docker build . --file Dockerfile --tag "$REPO":$(date +%s)`.

Locations:

- `.github/workflows/dockerimage.yml:12`

### unpinned-uses (severity: high)

The step `uses: reviewdog/action-nimlint@master` references a mutable branch name (`master`) instead of a full 40-character commit SHA. This means the action can be silently updated (or compromised) without any change to the workflow file, enabling a supply-chain attack. Pin to a specific commit SHA, e.g. `uses: reviewdog/action-nimlint@<40-char-sha> # master`.

Locations:

- `.github/workflows/nimlint-action.yml:13`

### missing-permissions (severity: medium)

None of the workflow files define a `permissions:` block — neither at the top level nor on any individual job. Without explicit permissions, workflows run with the repository's default token permissions, which may be overly broad (e.g. `write` access to contents, pull-requests, etc.). Add a minimal `permissions:` block to each workflow (or to each job) granting only the scopes actually required.

Locations:

- `.github/workflows/depup.yml:1`
- `.github/workflows/dockerimage.yml:1`
- `.github/workflows/nimlint-action.yml:1`
- `.github/workflows/release.yml:1`
- `.github/workflows/reviewdog.yml:1`
- `.github/workflows/test.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, unpinned-uses, missing-permissions

**Notes:**

1. script-injection (dockerimage.yml line 12): Moved `${{ github.repository }}` into an `env:` block as `REPO` and referenced it as `"$REPO"` in the shell command. 2. unpinned-uses (nimlint-action.yml line 13): Pinned `reviewdog/action-nimlint@master` to full SHA `eec54c6010f7f660ff8aac5b3ef5d1d129a6d69d` with `# master` comment. 3. missing-permissions: Added minimal `permissions:` blocks to all 6 workflow files — depup.yml (contents:write, pull-requests:write), dockerimage.yml (contents:read), nimlint-action.yml (contents:read, pull-requests:write), release.yml (contents:write, pull-requests:write), reviewdog.yml (contents:read, pull-requests:write, checks:write), test.yml (contents:read, checks:write, pull-requests:write).

