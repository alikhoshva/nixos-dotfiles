---
name: nix-verification
description: Use when verifying Nix flake code, checking syntax, or running pre-commit switch dry-runs.
---

# Nix Verification Skill

Use this skill whenever code modifications need evaluation or pre-commit verification.

## Execution Rules

1. **Do NOT run raw verbose nix commands directly**:
   Running raw `nix flake check` or `nh os switch` directly produces massive stdout logs that bloat chat history with input tokens.

2. **Execute the Verification Helper Script**:
   Run:
   ```bash
   .agents/scripts/verify.sh
   ```
   - Automatically detects untracked `.nix` files and stages them.
   - Runs `nix flake check`.
   - Runs `nh os switch --dry`.
   - Offloads raw stdout/stderr to `.agents/logs/last_verify.log`.

3. **Interpreting Results**:
   - If success: A concise 3-line success summary is printed.
   - If error: A filtered snippet of the exact error lines and file location is printed. If deep stack traces are needed, inspect `.agents/logs/last_verify.log`.
