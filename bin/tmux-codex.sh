#!/usr/bin/env bash
set -euo pipefail

SESSION="codex"
WORKDIR="${1:-$PWD}"
WINDOWS=("codex-1" "codex-2" "codex-3")

if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux is not installed or not on PATH" >&2
  exit 1
fi

if ! command -v codex >/dev/null 2>&1; then
  echo "codex is not installed or not on PATH" >&2
  exit 1
fi

attach_or_switch() {
  if [[ -n "${TMUX:-}" ]]; then
    exec tmux switch-client -t "$SESSION"
  else
    exec tmux attach-session -t "$SESSION"
  fi
}

if tmux has-session -t "$SESSION" 2>/dev/null; then
  attach_or_switch
fi

tmux new-session -d -s "$SESSION" -n "${WINDOWS[0]}" -c "$WORKDIR"
tmux send-keys -t "$SESSION:${WINDOWS[0]}" -- 'codex --yolo' Enter

for window in "${WINDOWS[@]:1}"; do
  tmux new-window -d -t "$SESSION:" -n "$window" -c "$WORKDIR"
  tmux send-keys -t "$SESSION:$window" -- 'codex --yolo' Enter
done

attach_or_switch
