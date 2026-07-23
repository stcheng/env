#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash "$REPO_ROOT/vendor/tmux-agent-indicator/adapters/codex-notify.sh" "$@"

if [ -n "${TMUX_PANE:-}" ]; then
    bash "$REPO_ROOT/bin/tmux-sync-codex-window-name" --pane "$TMUX_PANE" --quiet || true
fi
