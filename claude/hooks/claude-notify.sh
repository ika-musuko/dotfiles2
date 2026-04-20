#!/usr/bin/env bash
# Enqueues a notification event for the LaunchAgent daemon to deliver.
# Handles: focus suppression, session name/color, message extraction.

set -u

EVENT="${1:-notification}"
QUEUE="$HOME/.claude/hooks/queue"
mkdir -p "$QUEUE"

INPUT=""
if [ ! -t 0 ]; then INPUT="$(cat || true)"; fi

TMUX_BIN="$(command -v tmux || true)"
[ -z "$TMUX_BIN" ] && [ -x /opt/homebrew/bin/tmux ] && TMUX_BIN=/opt/homebrew/bin/tmux

SESSION=""
WINDOW_IDX=""
WINDOW_NAME=""
PANE_ID=""
if [ -n "${TMUX:-}" ] && [ -n "$TMUX_BIN" ]; then
  SESSION="$("$TMUX_BIN"     display-message -p '#S' 2>/dev/null || true)"
  WINDOW_IDX="$("$TMUX_BIN"  display-message -p '#I' 2>/dev/null || true)"
  WINDOW_NAME="$("$TMUX_BIN" display-message -p '#W' 2>/dev/null || true)"
  PANE_ID="${TMUX_PANE:-$("$TMUX_BIN" display-message -p '#D' 2>/dev/null || true)}"
fi

# --- Focus suppression ---
# Skip if kitty is the frontmost app AND our tmux pane is the active/visible one
if [ -n "$PANE_ID" ] && [ -n "$TMUX_BIN" ]; then
  FRONT_APP="$(/usr/bin/osascript -e 'tell application "System Events" to name of first application process whose frontmost is true' 2>/dev/null || true)"
  if [ "$FRONT_APP" = "kitty" ]; then
    PANE_FLAGS="$("$TMUX_BIN" display-message -t "$PANE_ID" -p '#{window_active}#{pane_active}#{session_attached}' 2>/dev/null || true)"
    # 111 = window is active, pane is active, session is attached (being viewed)
    if [ "$PANE_FLAGS" = "111" ]; then
      exit 0
    fi
  fi
fi

# --- Session metadata (name + color) from transcript ---
/usr/bin/python3 - "$INPUT" "$EVENT" "$SESSION" "$WINDOW_IDX" "$WINDOW_NAME" "$PANE_ID" \
    "$TMUX_BIN" "$QUEUE" <<'PY'
import sys, json, os, glob, re, textwrap

raw_input, event, session, window_idx, window_name, pane_id, tmux_bin, queue_dir = sys.argv[1:]

# Parse hook JSON
try:
    d = json.loads(raw_input) if raw_input else {}
except Exception:
    d = {}

session_id    = d.get("session_id", "")
transcript    = d.get("transcript_path", "")
hook_msg      = d.get("message", "")

# Look up session name from ~/.claude/sessions/*.json
session_name = ""
if session_id:
    for f in glob.glob(os.path.expanduser("~/.claude/sessions/*.json")):
        try:
            meta = json.load(open(f))
            if meta.get("sessionId") == session_id:
                session_name = meta.get("name", "")
                break
        except Exception:
            pass

# Look up session color from transcript (last /color command)
COLOR_EMOJI = {
    "orange": "🟧", "red": "🟥", "green": "🟩", "blue": "🟦",
    "yellow": "🟨", "purple": "🟪", "white": "⬜", "black": "⬛",
    "brown": "🟫", "pink": "🩷", "cyan": "🩵",
}
color_emoji = ""
if transcript and os.path.isfile(transcript):
    try:
        color = ""
        with open(transcript) as tf:
            for line in tf:
                try:
                    entry = json.loads(line)
                    # /color sets a local_command system message
                    if entry.get("type") == "system" and entry.get("subtype") == "local_command":
                        c = entry.get("content", "")
                        m = re.search(r'<command-name>/color</command-name>.*?<command-args>(\w+)</command-args>', c, re.S)
                        if m:
                            color = m.group(1).lower()
                except Exception:
                    pass
        color_emoji = COLOR_EMOJI.get(color, "")
    except Exception:
        pass

# Build message body
body = ""
if event == "notification":
    body = hook_msg or "Waiting for input"
else:
    # Stop: grab last assistant message text from transcript
    if transcript and os.path.isfile(transcript):
        try:
            last_text = ""
            with open(transcript) as tf:
                for line in tf:
                    try:
                        entry = json.loads(line)
                        if entry.get("type") == "assistant":
                            for block in entry.get("message", {}).get("content", []):
                                if isinstance(block, dict) and block.get("type") == "text":
                                    last_text = block["text"].strip()
                    except Exception:
                        pass
            if last_text:
                # First non-empty line, truncated
                first_line = next((l.strip() for l in last_text.splitlines() if l.strip()), "")
                body = textwrap.shorten(first_line, width=80, placeholder="…")
        except Exception:
            pass
    if not body:
        body = "Done"

# Build title
prefix = color_emoji + " " if color_emoji else ""
label  = session_name or "Claude Code"
suffix = " — done" if event == "stop" else " — needs you"
title  = prefix + label + suffix

# Build subtitle
subtitle = ""
if session and window_idx:
    subtitle = f"{session}:{window_idx} ({window_name})" if window_name else f"{session}:{window_idx}"

# Build click execute command
execute = "/usr/bin/open -a kitty"
if session and tmux_bin:
    safe = lambda s: s.replace("'", "")
    execute += f"; {tmux_bin} switch-client -t '{safe(session)}'"
    execute += f"; {tmux_bin} select-window -t '{safe(session)}:{window_idx}'"
    if pane_id:
        execute += f"; {tmux_bin} select-pane -t '{safe(pane_id)}'"

# Write event file
import time
ts = int(time.time() * 1e9)
out_path = os.path.join(queue_dir, f"{ts}-{event}.json")
json.dump({
    "event":    event,
    "title":    title,
    "body":     body,
    "subtitle": subtitle,
    "execute":  execute,
}, open(out_path, "w"))
PY

exit 0
