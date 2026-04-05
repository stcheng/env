# shellcheck shell=bash

run_segment() {
	local plugin_dir="${HOME}/Workspace/tmux-agent-indicator"
	local script="${plugin_dir}/scripts/indicator.sh"

	if [ ! -x "$script" ]; then
		return 0
	fi

	"$script" | tr '\n' ' ' | sed 's/[[:space:]]*$//'
}
