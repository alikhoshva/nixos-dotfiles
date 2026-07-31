---
name: systematic-debugging
description: Use when diagnosing build errors, Nix evaluation failures, or unexpected system behavior.
---

# Systematic Debugging Skill

Follow this protocol when troubleshooting errors or unexpected failures in `nixos-dotfiles`.

## Debugging Protocol

1. **Do NOT Guess or Patch Symptoms**:
   - Never modify code blindly or swallow errors without inspecting the log trace first.

2. **Inspect Filtered & Raw Log Traces**:
   - Execute `.agents/scripts/verify.sh`.
   - Read output summary. If deep inspection is needed, read `.agents/logs/last_verify.log` or run `.agents/scripts/filter-logs.sh .agents/logs/last_verify.log`.

3. **Form & Validate Hypothesis**:
   - Identify the exact file name and line number emitted by the Nix evaluation error trace.
   - Cross-reference with [.agents/knowledge/troubleshooting.md](file:///.agents/knowledge/troubleshooting.md).

4. **Verify Fix**:
   - Re-run `.agents/scripts/verify.sh` to confirm clean evaluation before reporting resolution.
