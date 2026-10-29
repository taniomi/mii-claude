#!/bin/bash
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
worktree=$(echo "$input" | jq -r '.workspace.git_worktree // empty')
rate_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rate_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

blue=$'\033[01;34m'
orange=$'\033[38;5;208m'
green=$'\033[00;32m'
magenta=$'\033[01;35m'
reset=$'\033[00m'

home="$HOME"
display_path="${cwd/#$home/\~}"

branch=$(git -C "$cwd" branch --show-current 2>/dev/null)

# Render a 10-block progress bar for a given integer percentage
build_bar() {
    local pct_int=$1 bar_width=10
    local filled=$((pct_int * bar_width / 100))
    local empty=$((bar_width - filled))
    local bar=""
    [ "$filled" -gt 0 ] && printf -v fill "%${filled}s" && bar="${fill// /▓}"
    [ "$empty" -gt 0 ] && printf -v pad "%${empty}s" && bar="${bar}${pad// /░}"
    echo "$bar"
}

ctx_seg=""
if [ -n "$ctx_pct" ]; then
    ctx_int=$(printf '%.0f' "$ctx_pct")
    ctx_seg="ctx:$(build_bar "$ctx_int") ${ctx_int}%"
fi

rate_seg=""
if [ -n "$rate_pct" ]; then
    rate_int=$(printf '%.0f' "$rate_pct")
    rate_seg="5h:$(build_bar "$rate_int") ${rate_int}%"
    if [ -n "$rate_reset" ]; then
        rate_reset_fmt=$(date -d "@$rate_reset" '+%H:%M' 2>/dev/null)
        [ -n "$rate_reset_fmt" ] && rate_seg="${rate_seg} • resets ${rate_reset_fmt}"
    fi
fi

# Branch and worktree share one field, joined with ">" when both are present
branch_worktree=""
if [ -n "$branch" ] && [ -n "$worktree" ]; then
    branch_worktree="${green}${branch}${reset} → ${magenta}${worktree}${reset}"
elif [ -n "$branch" ]; then
    branch_worktree="${green}${branch}${reset}"
elif [ -n "$worktree" ]; then
    branch_worktree="${magenta}${worktree}${reset}"
fi

row1_parts=("${blue}${display_path}${reset}")

row2_parts=()
[ -n "$branch_worktree" ] && row2_parts+=("$branch_worktree")

row3_parts=()
[ -n "$model" ] && row3_parts+=("${orange}${model}${reset}")
[ -n "$ctx_seg" ] && row3_parts+=("$ctx_seg")
[ -n "$rate_seg" ] && row3_parts+=("$rate_seg")

join_with_pipe() {
    local out="$1"
    shift
    for part in "$@"; do
        out="${out} • ${part}"
    done
    printf "%s" "$out"
}

row1=$(join_with_pipe "${row1_parts[@]}")
row2=$(join_with_pipe "${row2_parts[@]}")
row3=$(join_with_pipe "${row3_parts[@]}")

printf "%s\n%s\n%s" "$row1" "$row2" "$row3"
