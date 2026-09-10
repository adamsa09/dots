#!/usr/bin/env bash
# Resize the focused yabai window by growing/shrinking its width.
# Picks whichever edge is actually an internal split border (not the
# screen edge), so left- and right-side windows both resize correctly.
#
# Usage: resize.sh grow|shrink [amount]

set -euo pipefail

dir="$1"
amount="${2:-20}"

case "$dir" in
  grow)   sign=1 ;;
  shrink) sign=-1 ;;
  *) echo "usage: resize.sh grow|shrink [amount]" >&2; exit 1 ;;
esac

win=$(yabai -m query --windows --window)
win_x=$(jq -r '.frame.x' <<<"$win")
win_w=$(jq -r '.frame.w' <<<"$win")
display_id=$(jq -r '.display' <<<"$win")

display=$(yabai -m query --displays --display "$display_id")
disp_x=$(jq -r '.frame.x' <<<"$display")
disp_w=$(jq -r '.frame.w' <<<"$display")

tolerance=15
touches_left=$(awk -v a="$win_x" -v b="$disp_x" -v t="$tolerance" 'BEGIN{print (a<=b+t)?1:0}')
touches_right=$(awk -v ax="$win_x" -v aw="$win_w" -v bx="$disp_x" -v bw="$disp_w" -v t="$tolerance" \
  'BEGIN{print ((ax+aw)>=(bx+bw-t))?1:0}')

delta=$((sign * amount))
neg_delta=$(( -1 * sign * amount ))

if [ "$touches_left" = "1" ] && [ "$touches_right" = "1" ]; then
  # Only window on the display — nothing to resize against.
  exit 0
fi

if [ "$touches_left" = "1" ]; then
  yabai -m window --resize "right:${delta}:0"
elif [ "$touches_right" = "1" ]; then
  yabai -m window --resize "left:${neg_delta}:0"
else
  # Middle column: has borders on both sides.
  yabai -m window --resize "right:${delta}:0"
  yabai -m window --resize "left:${neg_delta}:0"
fi
