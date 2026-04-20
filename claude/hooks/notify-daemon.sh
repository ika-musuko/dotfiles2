#!/usr/bin/env bash
# LaunchAgent daemon in Aqua GUI session.
# Reads ~/.claude/hooks/queue/*.json and fires native notifications.

set -u

QUEUE_DIR="$HOME/.claude/hooks/queue"
NOTIFIER=/opt/homebrew/bin/terminal-notifier

mkdir -p "$QUEUE_DIR"

dispatch() {
  local file="$1" event title body subtitle execute sound
  IFS=$'\t' read -r event title body subtitle execute < <(
    /usr/bin/python3 -c '
import sys, json
d = json.load(open(sys.argv[1]))
fields = ["event","title","body","subtitle","execute"]
print("\t".join(d.get(f,"").replace("\t"," ").replace("\n"," ") for f in fields))
' "$file"
  )

  sound=Pop
  [ "$event" = "notification" ] && sound=Glass

  if [ -x "$NOTIFIER" ]; then
    "$NOTIFIER" \
      -title "$title" \
      -subtitle "$subtitle" \
      -message "$body" \
      -sound "$sound" \
      -execute "$execute" >/dev/null 2>&1
  else
    /usr/bin/osascript -e "display notification \"${body//\"/\'}\" with title \"${title//\"/\'}\" subtitle \"${subtitle//\"/\'}\" sound name \"$sound\"" >/dev/null 2>&1
  fi
}

while true; do
  shopt -s nullglob
  for f in "$QUEUE_DIR"/*.json; do
    dispatch "$f"
    rm -f "$f"
  done
  shopt -u nullglob
  sleep 0.5
done
