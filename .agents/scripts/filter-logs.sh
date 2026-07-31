#!/usr/bin/env bash
# Helper script to sanitize verbose Nix logs and extract high-signal errors/warnings.

LOG_FILE="${1:-}"

filter_stream() {
    grep -E -i "(error:|failed|trace:|line [0-9]+|cannot|syntax error|undefined variable|attribute '.*' missing)" \
    | grep -v -E "(fetching|downloading|unpacking|coping path|building ')" \
    | head -n 30
}

if [ -n "$LOG_FILE" ] && [ -f "$LOG_FILE" ]; then
    filter_stream < "$LOG_FILE"
else
    filter_stream
fi
