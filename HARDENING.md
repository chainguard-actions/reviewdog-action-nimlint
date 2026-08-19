<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-nimlint/v1.18.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-nimlint/v1.18.3** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The `run:` block in dockerimage.yml directly interpolates the GitHub Actions expression `${{ github.repository }}` inside a shell command string: `docker build . --file Dockerfile --tag ${{ github.repository }}:$(date +%s)`. The `github.repository` value flows through YAML template substitution before the shell ever sees it, allowing an attacker who controls the repository name to inject shell metacharacters.

Locations:

- `.github/workflows/dockerimage.yml:11`

### unpinned-uses (severity: high)

The workflow references `reviewdog/action-nimlint@master` — a mutable branch name rather than a pinned 40-character commit SHA. This means the action can be silently updated (or compromised) without any change to the workflow file, creating a supply-chain risk.

Locations:

- `.github/workflows/nimlint-action.yml:13`

### missing-permissions (severity: medium)

None of the 6 workflow files define a top-level `permissions:` block, and no individual job within any of these files defines a `permissions:` block either. Without explicit permissions, workflows run with the repository's default token permissions (often `write-all` for private repos), granting more access than necessary.

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

Fixed 3 findings across 6 workflow files:
1. script-injection (dockerimage.yml line 11): Moved `${{ github.repository }}` into an `env:` block as REPOSITORY and referenced it as "$REPOSITORY" in the shell command, preventing shell metacharacter injection.
2. unpinned-uses (nimlint-action.yml line 13): Pinned `reviewdog/action-nimlint@master` to its full commit SHA `533c90f5c9d0188f3de61bd3eb13db71efb2f366` with `# master` comment for readability.
3. missing-permissions: Added `permissions: {}` top-level block to all 6 workflow files (depup.yml, dockerimage.yml, nimlint-action.yml, release.yml, reviewdog.yml, test.yml) to enforce least-privilege by default.

