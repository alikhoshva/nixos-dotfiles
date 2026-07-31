#!/usr/bin/env bash
# Helper script to scan modified/untracked Nix files for redundant option defaults & bloat.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$REPO_DIR"

# Find modified or newly added .nix files
NIX_FILES=$(git status --porcelain | awk '{print $2}' | grep '\.nix$' || true)

if [ -z "$NIX_FILES" ]; then
    echo "[OK] No modified .nix files to scan for bloat."
    exit 0
fi

BLOAT_FOUND=0

for file in $NIX_FILES; do
    if [ -f "$file" ]; then
        # Check for explicit enable = false; which is usually redundant default
        if grep -Hn "enable = false;" "$file" >/dev/null 2>&1; then
            echo "[WARNING] Possible redundant default 'enable = false;' found in $file:"
            grep -Hn "enable = false;" "$file"
            BLOAT_FOUND=1
        fi
        
        # Check for empty extraConfig = "";
        if grep -Hn 'extraConfig = "";' "$file" >/dev/null 2>&1; then
            echo "[WARNING] Redundant empty string 'extraConfig = \"\";' found in $file:"
            grep -Hn 'extraConfig = "";' "$file"
            BLOAT_FOUND=1
        fi

        # Check for empty settings = {};
        if grep -Hn 'settings = {};' "$file" >/dev/null 2>&1; then
            echo "[WARNING] Redundant empty attribute set 'settings = {};' found in $file:"
            grep -Hn 'settings = {};' "$file"
            BLOAT_FOUND=1
        fi

        # Check for empty packages = [];
        if grep -Hn 'packages = \[\];' "$file" >/dev/null 2>&1; then
            echo "[WARNING] Redundant empty list 'packages = [];' found in $file:"
            grep -Hn 'packages = \[\];' "$file"
            BLOAT_FOUND=1
        fi

        # Check for legacy 'with pkgs;' scope pollution
        if grep -Hn 'with pkgs;' "$file" >/dev/null 2>&1; then
            echo "[WARNING] Anti-pattern 'with pkgs;' found in $file (use explicit pkgs. naming):"
            grep -Hn 'with pkgs;' "$file"
            BLOAT_FOUND=1
        fi
    fi
done

if [ "$BLOAT_FOUND" -eq 0 ]; then
    echo "[OK] Anti-bloat static check passed cleanly."
fi
