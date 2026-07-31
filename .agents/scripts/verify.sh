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

FAST_MODE="${1:-}"

# 1. Static Anti-Bloat Check
echo "--- Running Anti-Bloat Check ---" >> "$LOG_FILE"
"$SCRIPT_DIR/check-bloat.sh" >> "$LOG_FILE" 2>&1 || true

# 2. Pre-flight Syntax Parsing (<50ms)
echo "--- Running Pre-flight Nix Syntax Parsing ---" >> "$LOG_FILE"
SYNTAX_ERRORS=0
for nix_file in $(find host nixosModules homeManagerModules -name "*.nix" 2>/dev/null); do
    if ! nix-instantiate --parse "$nix_file" >/dev/null 2>&1; then
        echo "[FAIL] Syntax error in $nix_file" | tee -a "$LOG_FILE"
        nix-instantiate --parse "$nix_file" 2>&1 | tee -a "$LOG_FILE"
        SYNTAX_ERRORS=1
    fi
done

if [ "$SYNTAX_ERRORS" -ne 0 ]; then
    echo "Full log saved to: .agents/logs/last_verify.log"
    exit 1
fi
echo "[OK] All .nix files parsed cleanly."

if [ "$FAST_MODE" = "--fast" ] || [ "$FAST_MODE" = "-f" ]; then
    echo "=== Verification Result: FAST PASS (<100ms) ==="
    exit 0
fi

# 3. Check for untracked Nix files
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
