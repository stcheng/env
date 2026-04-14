#!/usr/bin/env bash

set -euo pipefail

CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
SESSIONS_DIR="$CODEX_HOME_DIR/sessions"

if [ ! -d "$SESSIONS_DIR" ]; then
    exit 0
fi

python3 - "$SESSIONS_DIR" <<'PY'
from collections import deque
from datetime import datetime
from pathlib import Path
import json
import os
import sys
from zoneinfo import ZoneInfo


def coerce_percent(value):
    if value is None:
        return None
    if isinstance(value, float) and value.is_integer():
        value = int(value)
    if isinstance(value, (int, float)):
        return int(round(value))
    return value


def format_reset(reset_at):
    if reset_at is None:
        return None
    try:
        timestamp = int(reset_at)
    except (TypeError, ValueError):
        return None

    tz_name = os.environ.get("CODEX_RATE_LIMIT_TZ") or os.environ.get("TZ")
    try:
        tzinfo = ZoneInfo(tz_name) if tz_name else datetime.now().astimezone().tzinfo
    except Exception:
        tzinfo = datetime.now().astimezone().tzinfo

    return datetime.fromtimestamp(timestamp, tz=tzinfo).strftime("%m-%d %H:%M")


def format_limit(label, percent, reset_at):
    percent_value = coerce_percent(percent)
    reset_value = format_reset(reset_at)
    if percent_value is None and reset_value is None:
        return None
    if reset_value is None:
        return f"{label}:{percent_value}%"
    if percent_value is None:
        return f"{label} @ {reset_value}"
    return f"{label}:{percent_value}% @ {reset_value}"


sessions_dir = Path(sys.argv[1])
latest_path = None
latest_mtime = None

for path in sessions_dir.rglob("*.jsonl"):
    try:
        mtime = path.stat().st_mtime
    except OSError:
        continue
    if latest_mtime is None or mtime > latest_mtime:
        latest_path = path
        latest_mtime = mtime

if latest_path is None:
    raise SystemExit(0)

recent_lines = deque(maxlen=200)
try:
    with latest_path.open("r", encoding="utf-8", errors="ignore") as handle:
        for line in handle:
            recent_lines.append(line)
except OSError:
    raise SystemExit(0)

primary = {}
secondary = {}
for line in recent_lines:
    try:
        event = json.loads(line)
    except json.JSONDecodeError:
        continue
    if event.get("type") != "event_msg":
        continue
    payload = event.get("payload") or {}
    if payload.get("type") != "token_count":
        continue
    rate_limits = payload.get("rate_limits") or {}
    if rate_limits.get("limit_id") != "codex":
        continue
    primary = rate_limits.get("primary") or {}
    secondary = rate_limits.get("secondary") or {}

parts = [
    part
    for part in (
        format_limit("5h", primary.get("used_percent"), primary.get("resets_at")),
        format_limit("1w", secondary.get("used_percent"), secondary.get("resets_at")),
    )
    if part
]

if parts:
    print(" ".join(parts))
PY
