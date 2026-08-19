<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-nimlint/v1.19.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-nimlint/v1.19.0** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The run: block in dockerimage.yml directly interpolates the GitHub Actions expression `${{ github.repository }}` into a shell command string. Although `github.repository` is not directly attacker-controlled, any `${{ ... }}` expression inside a run: block is a script-injection risk because the value is substituted by the template engine before the shell ever sees it, bypassing shell quoting. The offending line is: `run: docker build . --file Dockerfile --tag ${{ github.repository }}:$(date +%s)`. The fix is to pass the value via an env: variable and reference it as `"$REPO"` in the shell.

Locations:

- `.github/workflows/dockerimage.yml:9`

### unpinned-uses (severity: high)

The workflow nimlint-action.yml references `reviewdog/action-nimlint@master`, which is a mutable branch ref rather than an immutable 40-character commit SHA. If the upstream repository is compromised or the branch is force-pushed, this action will execute arbitrary attacker-controlled code in the workflow. All `uses:` references should be pinned to a full SHA (e.g. `reviewdog/action-nimlint@<40-hex-sha> # master`).

Locations:

- `.github/workflows/nimlint-action.yml:11`

### missing-permissions (severity: medium)

None of the 6 workflow files under .github/workflows/ declare a top-level `permissions:` block, and no individual job within any of these files declares its own `permissions:` block. Without explicit permissions, GitHub Actions uses the repository's default token permissions, which may be overly broad (e.g. write access to contents, pull-requests, etc.). Each workflow should declare the minimal required permissions at the top level or per-job. Affected files: depup.yml, dockerimage.yml, nimlint-action.yml, release.yml, reviewdog.yml, test.yml.

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

1. script-injection (dockerimage.yml line 9): Moved `${{ github.repository }}` out of the run: shell string into an env: block as `REPO`, then referenced it as `"$REPO"` in the docker build command. 2. unpinned-uses (nimlint-action.yml line 11): Pinned `reviewdog/action-nimlint@master` to its full commit SHA `533c90f5c9d0188f3de61bd3eb13db71efb2f366` with a `# master` comment for readability. 3. missing-permissions: Added `permissions: {}` top-level blocks to all 6 affected workflow files (depup.yml, dockerimage.yml, nimlint-action.yml, release.yml, reviewdog.yml, test.yml), restricting the default token to no permissions.

