#!/bin/bash
# Installs the Claude Code status line into ~/.claude on this machine.
# Merges the statusLine entry into ~/.claude/settings.json, keeping every other setting.
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
claude_dir="$HOME/.claude"
settings="$claude_dir/settings.json"

command -v jq >/dev/null || { echo "jq is required (the status line script uses it too)" >&2; exit 1; }

mkdir -p "$claude_dir"
cp "$repo_dir/claude/statusline-command.sh" "$claude_dir/statusline-command.sh"
chmod +x "$claude_dir/statusline-command.sh"

[ -f "$settings" ] || echo '{}' > "$settings"
cp "$settings" "$settings.bak"

entry=$(sed "s|__HOME__|$HOME|g" "$repo_dir/claude/settings.statusLine.json")
tmp=$(mktemp)
jq --argjson entry "$entry" '. * $entry' "$settings" > "$tmp"
mv "$tmp" "$settings"

echo "Installed status line into $claude_dir (previous settings saved to $settings.bak)"
