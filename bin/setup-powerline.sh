#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMUX_POWERLINE_DIR="$HOME/.config/tmux-powerline"
CODEX_CONFIG_DIR="$HOME/.codex"
CODEX_CONFIG_FILE="$CODEX_CONFIG_DIR/config.toml"
TMUX_POWERLINE_VENDOR_DIR="$REPO_ROOT/vendor/tmux-powerline"
TMUX_AGENT_VENDOR_DIR="$REPO_ROOT/vendor/tmux-agent-indicator"
CODEX_NOTIFY_SCRIPT="$REPO_ROOT/codex/tmux-codex-notify.sh"
NOTIFY_LINE="notify = [\"bash\", \"$CODEX_NOTIFY_SCRIPT\"]"

backup_and_link() {
	local source_path="$1"
	local target_path="$2"
	local backup_path="${target_path}.bak-before-env-link"

	mkdir -p "$(dirname "$target_path")"

	if [ -L "$target_path" ]; then
		rm -f "$target_path"
	elif [ -e "$target_path" ] && [ ! -e "$backup_path" ]; then
		cp "$target_path" "$backup_path"
		rm -f "$target_path"
	elif [ -e "$target_path" ]; then
		rm -f "$target_path"
	fi

	ln -s "$source_path" "$target_path"
}

remove_managed_link() {
	local source_path="$1"
	local target_path="$2"

	if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
		rm -f "$target_path"
	fi
}

ensure_vendored_runtime() {
	local path="$1"
	local name="$2"

	if [ ! -f "$path" ]; then
		echo "Missing vendored runtime file: $path ($name)" >&2
		exit 1
	fi
}

ensure_codex_notify() {
	mkdir -p "$CODEX_CONFIG_DIR"

	python3 - "$CODEX_CONFIG_FILE" "$NOTIFY_LINE" <<'PY'
import pathlib
import re
import sys

config_path = pathlib.Path(sys.argv[1])
notify_line = sys.argv[2]
text = config_path.read_text(encoding="utf-8") if config_path.exists() else ""

exact_pattern = re.compile(r'(?m)^[ \t]*notify[ \t]*=[ \t]*\[\s*"bash"\s*,\s*".*/tmux-agent-indicator/adapters/codex-notify\.sh"\s*\][ \t]*$')
generic_pattern = re.compile(r'(?m)^[ \t]*notify[ \t]*=[ \t]*.*$')

if exact_pattern.search(text):
    text = exact_pattern.sub(notify_line, text, count=1)
elif generic_pattern.search(text):
    text = generic_pattern.sub(notify_line, text, count=1)
else:
    if text and not text.endswith("\n"):
        text += "\n"
    text += notify_line + "\n"

config_path.write_text(text, encoding="utf-8")
PY
}

main() {
	ensure_vendored_runtime "$TMUX_POWERLINE_VENDOR_DIR/main.tmux" "tmux-powerline"
	ensure_vendored_runtime "$TMUX_AGENT_VENDOR_DIR/agent-indicator.tmux" "tmux-agent-indicator"

	backup_and_link "$REPO_ROOT/.tmux.conf" "$HOME/.tmux.conf"
	backup_and_link "$REPO_ROOT/tmux-powerline/config.sh" "$TMUX_POWERLINE_DIR/config.sh"
	backup_and_link "$REPO_ROOT/tmux-powerline/themes/stcheng.sh" "$TMUX_POWERLINE_DIR/themes/stcheng.sh"
	backup_and_link "$REPO_ROOT/tmux-powerline/segments/agent_indicator.sh" "$TMUX_POWERLINE_DIR/segments/agent_indicator.sh"
	remove_managed_link "$REPO_ROOT/tmux-powerline/segments/tmux_session_info.sh" "$TMUX_POWERLINE_DIR/segments/tmux_session_info.sh"

	ensure_codex_notify

	tmux start-server \; source-file "$HOME/.tmux.conf"

	echo "Powerline setup linked from $REPO_ROOT"
	echo "tmux config: $HOME/.tmux.conf"
	echo "tmux-powerline config: $TMUX_POWERLINE_DIR"
	echo "codex notify: $CODEX_CONFIG_FILE"
}

main "$@"
