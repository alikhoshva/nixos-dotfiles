#!/usr/bin/env bash
# Fast, token-efficient verification script for NixOS & Home Manager flake setup.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
LOG_DIR="$REPO_DIR/.agents/logs"
LOG_FILE="$LOG_DIR/last_verify.log"

mkdir -p "$LOG_DIR"
echo "=== Verification Run: $(date) ===" > "$LOG_FILE"

cd "$REPO_DIR"

# 1. Static Anti-Bloat Check
echo "--- Running Anti-Bloat Check ---" >> "$LOG_FILE"
"$SCRIPT_DIR/check-bloat.sh" >> "$LOG_FILE" 2>&1 || true

# 2. Check for untracked Nix files
UNTRACKED=$(git status --porcelain | grep '^??.*\.nix$' || true)
if [ -n "$UNTRACKED" ]; then
    echo "[WARNING] Untracked Nix files detected! Nix Flakes will ignore them until staged:" >> "$LOG_FILE"
    echo "$UNTRACKED" >> "$LOG_FILE"
    echo "[!] Notice: Untracked .nix files exist. Staging them automatically for flake check..."
    git add $UNTRACKED
fi

# 3. Run nix flake check
echo "--- Running nix flake check ---" >> "$LOG_FILE"
if ! nix flake check --extra-experimental-features 'nix-command flakes' >> "$LOG_FILE" 2>&1; then
    echo "[FAIL] nix flake check failed. Error summary:"
    "$SCRIPT_DIR/filter-logs.sh" "$LOG_FILE"
    echo "Full log saved to: .agents/logs/last_verify.log"
    exit 1
fi
echo "[OK] nix flake check passed cleanly."

# 4. Run dry-run switch / unified evaluation check
echo "--- Running nh os switch --dry ---" >> "$LOG_FILE"
if command -v nh >/dev/null 2>&1; then
    if ! nh os switch --dry >> "$LOG_FILE" 2>&1; then
        echo "[FAIL] nh os switch --dry failed. Error summary:"
        "$SCRIPT_DIR/filter-logs.sh" "$LOG_FILE"
        echo "Full log saved to: .agents/logs/last_verify.log"
        exit 1
    fi
    echo "[OK] nh os switch --dry evaluation successful."
else
    if ! nixos-rebuild dry-build >> "$LOG_FILE" 2>&1; then
        echo "[FAIL] nixos-rebuild dry-build failed. Error summary:"
        "$SCRIPT_DIR/filter-logs.sh" "$LOG_FILE"
        echo "Full log saved to: .agents/logs/last_verify.log"
        exit 1
    fi
    echo "[OK] nixos-rebuild dry-build evaluation successful."
fi

echo "=== Verification Result: SUCCESS ==="
