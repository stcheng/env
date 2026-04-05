# Minimal local config for the forked tmux-powerline checkout in ~/Workspace.

export TMUX_POWERLINE_PATCHED_FONT_IN_USE="true"
export TMUX_POWERLINE_THEME="stcheng"
export TMUX_POWERLINE_DIR_USER_THEMES="${XDG_CONFIG_HOME:-$HOME/.config}/tmux-powerline/themes"
export TMUX_POWERLINE_DIR_USER_SEGMENTS="${XDG_CONFIG_HOME:-$HOME/.config}/tmux-powerline/segments"

export TMUX_POWERLINE_STATUS_INTERVAL="2"
export TMUX_POWERLINE_STATUS_JUSTIFICATION="left"
export TMUX_POWERLINE_STATUS_LEFT_LENGTH="80"
export TMUX_POWERLINE_STATUS_RIGHT_LENGTH="120"
export TMUX_POWERLINE_WINDOW_STATUS_SEPARATOR=""

# Match the git branch icon color to the branch text color.
export TMUX_POWERLINE_SEG_VCS_BRANCH_GIT_SYMBOL_COLOUR="255"
