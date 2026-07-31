# Nix Flakes & Agentic Troubleshooting Guide

This guide details common evaluation pitfalls, Nix flake git-tracking behavior, and debugging procedures using `.agents/` tools.

---

## 1. Nix Flakes & Untracked Files

### Problem
Nix Flakes evaluate code strictly through Git tree snapshots. If a newly created `.nix` file or raw config file under `config/` is not tracked by Git, Nix will fail with:
`error: path '...' does not exist` or `error: file '...' was not found in the flake`.

### Fix
Stage untracked files immediately before executing Nix evaluation commands:
```bash
git add <newfile> # or git add .
```
*(Note: `.agents/scripts/verify.sh` automatically detects untracked `.nix` files and stages them).*

---

## 2. Log Offloading & Reading Full Failure Traces

### Procedure
To save context window tokens, `.agents/scripts/verify.sh` outputs only concise summaries and sanitized error lines to stdout.
Full verbose build logs, package download progress, and complete evaluation stack traces are saved to:
`.agents/logs/last_verify.log`.

If stdout reports a failure and you need to inspect full details:
1. View `.agents/logs/last_verify.log` using `view_file` or `grep`.
2. Use `.agents/scripts/filter-logs.sh .agents/logs/last_verify.log` to re-extract key traces.

---

## 3. Dry-Run Evaluation & Switch Diagnostics

- **Command**: `nh os switch --dry` (or `nixos-rebuild dry-build`).
- **Scope**: Evaluates both system NixOS modules and integrated Home Manager modules simultaneously.
- **Common Failure Causes**:
  - Missing file in `imports = [ ... ]` list.
  - Duplicate attribute definitions across modules.
  - Syntax errors (missing semicolon, unclosed string, or missing brace in `.nix` file).
