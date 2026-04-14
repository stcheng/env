# Vendored tmux runtime

This repo now owns the tmux runtime code it depends on.

## Layout

- `vendor/tmux-powerline`: minimal runtime subset used by this setup
- `vendor/tmux-agent-indicator`: agent indicator runtime used by tmux and Codex notify
- `tmux-powerline/`: local overlay config, custom theme, and custom segment wiring

## Import sources

### `vendor/tmux-powerline`

- Source repo: `https://github.com/stcheng/tmux-powerline.git`
- Imported from local checkout: `~/Workspace/tmux-powerline`
- Base commit at import time: `d700111`
- Scope imported: runtime files only

Imported files include:

- `main.tmux`, `powerline.sh`
- `config/*.sh`
- required `lib/*.sh`
- only the status segments used by this setup
- `themes/default.sh`

### `vendor/tmux-agent-indicator`

- Source repo: `https://github.com/stcheng/tmux-agent-indicator.git`
- Imported from local checkout: `~/Workspace/tmux-agent-indicator`
- Base commit at import time: `566dda6`
- Import note: local working tree changes were intentionally included

Local changes present in the source checkout at import time included:

- modified `scripts/indicator.sh`
- modified `tests/lib/tmux-test-lib.sh`
- modified `tests/run-all.sh`
- untracked `scripts/codex-rate-limits.sh`
- untracked `tests/test-codex-rate-limits.sh`

Only runtime files were vendored into this repo. Test and docs files were not imported.

## Ownership model

- This repo is now the source of truth for the tmux setup.
- `~/.tmux.conf` loads vendored runtime from this repo.
- `bin/setup-powerline.sh` links the overlay config into `$HOME` and writes the Codex notify path.
- No nested git repos or submodules are used.

## Suggested commit split

To keep git history readable, prefer this shape:

1. `vendor tmux runtime from local forks`
2. `rewire tmux config and setup scripts to vendored paths`
3. `refresh tmux docs for single-repo ownership`
