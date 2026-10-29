# mii-claude

My personal Claude Code settings, so I can set up a new computer quickly.

## What's here

- `claude/statusline-command.sh`: three-line status line showing the path, the git branch/worktree, the model, context usage and the 5-hour rate limit
- `claude/settings.statusLine.json`: the `statusLine` entry for `~/.claude/settings.json` (`__HOME__` is replaced at install time)
- `install.sh`: copies the script into `~/.claude` and merges the entry into `settings.json`, keeping every other setting (a backup goes to `settings.json.bak`)

## Install on a new machine

Requires `bash`, `git` and `jq`.

```bash
git clone <repo-url> ~/sandbox/mii-claude
~/sandbox/mii-claude/install.sh
```

Restart Claude Code to pick up the new status line.
