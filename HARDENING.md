<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-nimlint/v1.18.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-nimlint/v1.18.2** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): A GitHub Actions expression `${{ github.repository }}` is interpolated directly inside a `run:` shell command string. Before the shell executes the command, GitHub Actions substitutes the expression value verbatim into the script text, allowing an attacker who can control the repository name to inject arbitrary shell commands. Offending line: `run: docker build . --file Dockerfile --tag ${{ github.repository }}:$(date +%s)`. Fix: move the value into an `env:` variable and reference it as a quoted shell variable, e.g. `env: REPO: ${{ github.repository }}` then `run: docker build . --file Dockerfile --tag "$REPO":$(date +%s)`.

Locations:

- `.github/workflows/dockerimage.yml:12`

### unpinned-uses (severity: high)

The workflow uses `reviewdog/action-nimlint@master`, which is a mutable branch reference. If the upstream repository is compromised or the branch is force-pushed, the action will silently execute arbitrary code in all future workflow runs. Pin this reference to a full 40-character commit SHA (e.g. `reviewdog/action-nimlint@<sha> # master`) to ensure supply-chain integrity.

Locations:

- `.github/workflows/nimlint-action.yml:13`

### missing-permissions (severity: medium)

None of the 6 workflow files define a top-level `permissions:` block, and no individual job within any of these files defines a `permissions:` block. Without explicit permissions, workflows run with the repository's default token permissions, which are often overly broad (e.g. `write` access to contents, pull-requests, etc.). Each workflow should declare the minimal permissions required, e.g. `permissions: contents: read`. Affected files: depup.yml, dockerimage.yml, nimlint-action.yml, release.yml, reviewdog.yml, test.yml.

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

Fixed all three findings:
1. script-injection (dockerimage.yml line 12): Moved `${{ github.repository }}` into an `env:` block as `REPO`, then referenced it as `"$REPO"` in the run command.
2. unpinned-uses (nimlint-action.yml line 13): Pinned `reviewdog/action-nimlint@master` to full SHA `533c90f5c9d0188f3de61bd3eb13db71efb2f366 # master`.
3. missing-permissions (all 6 workflow files): Added top-level `permissions:` blocks with minimal required permissions — `contents: read` for dockerimage.yml; `contents: read` + `pull-requests: write` for nimlint-action.yml; `contents: write` + `pull-requests: write` for depup.yml and release.yml; `contents: read` + `checks: write` + `pull-requests: write` for reviewdog.yml and test.yml.

