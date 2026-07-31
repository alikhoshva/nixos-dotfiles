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
    fi
done

if [ "$BLOAT_FOUND" -eq 0 ]; then
    echo "[OK] Anti-bloat static check passed cleanly."
fi
