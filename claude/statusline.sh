#!/bin/bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "?"')
ctx_raw=$(echo "$input" | jq -r '.context_window.used_percentage // ""')
ctx_pct=$([[ -n "$ctx_raw" ]] && printf "%.0f" "$ctx_raw" || echo "?")

five_raw=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // ""')
five_pct=$([[ -n "$five_raw" ]] && printf "%.0f" "$five_raw" || echo "?")
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // ""')
seven_raw=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // ""')
seven_pct=$([[ -n "$seven_raw" ]] && printf "%.0f" "$seven_raw" || echo "?")
seven_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // ""')

[[ -n "$five_reset" ]] && five_reset_fmt=$(date -r "$five_reset" "+%H:%M" 2>/dev/null)
[[ -n "$seven_reset" ]] && seven_reset_fmt=$(date -r "$seven_reset" "+%a %m-%d %H:%M" 2>/dev/null)

echo "5h: ${five_pct}% (${five_reset_fmt:-?}) | 7d: ${seven_pct}% (${seven_reset_fmt:-?}) | ctx: ${ctx_pct}% | ${model}"
