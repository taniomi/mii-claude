# mii-claude

My personal Claude Code and tmux settings, so I can set up a new computer quickly.

## What's here

- `claude/statusline-command.sh`: three-line status line showing the path, the git branch/worktree, the model, context usage and the 5-hour rate limit
- `claude/settings.statusLine.json`: the `statusLine` entry for `~/.claude/settings.json` (`__HOME__` is replaced at install time)
- `tmux/tmux.conf`: tmux config (prefix `C-a`, mouse on, windows/panes numbered from 1)
- `install.sh`: copies the script into `~/.claude`, merges the entry into `settings.json` keeping every other setting, and installs `tmux.conf` as `~/.tmux.conf` (existing files are backed up as `.bak`)

## Install on a new machine

Requires `bash`, `git` and `jq`.

```bash
git clone <repo-url> ~/sandbox/mii-claude
~/sandbox/mii-claude/install.sh
```

Restart Claude Code to pick up the new status line, and run `tmux source-file ~/.tmux.conf` in any open tmux session.
