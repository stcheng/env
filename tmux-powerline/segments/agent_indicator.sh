# shellcheck shell=bash

resolve_repo_root() {
	local source_path="${BASH_SOURCE[0]}"
	while [ -L "$source_path" ]; do
		local source_dir
		source_dir="$(cd -P "$(dirname "$source_path")" && pwd)"
		source_path="$(readlink "$source_path")"
		case "$source_path" in
			/*) ;;
			*) source_path="${source_dir}/${source_path}" ;;
		esac
	done
	local source_dir
	source_dir="$(cd -P "$(dirname "$source_path")" && pwd)"
	cd "$source_dir/../.." && pwd
}

run_segment() {
	local plugin_dir
	plugin_dir="$(tmux show-environment -g TMUX_AGENT_INDICATOR_DIR 2>/dev/null | sed 's/^[^=]*=//')"
	if [ -z "$plugin_dir" ]; then
		plugin_dir="$(resolve_repo_root)/vendor/tmux-agent-indicator"
	fi
	local script="${plugin_dir}/scripts/indicator.sh"

	if [ ! -x "$script" ]; then
		return 0
	fi

	"$script" | tr '\n' ' ' | sed 's/[[:space:]]*$//'
}
