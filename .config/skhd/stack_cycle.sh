#!/usr/bin/env bash
# Cycle focus through all windows in the focused window's stack, wrapping
# around in both directions. yabai's stack.next/stack.prev only move one
# step and silently no-op at the ends, which makes a naive "next, or on
# failure prev" binding get stuck oscillating between the last two windows
# instead of visiting every window. This computes the true next/prev index
# in stack order and focuses it directly.
#
# Usage: stack_cycle.sh next|prev

set -euo pipefail

dir="$1"

win=$(yabai -m query --windows --window)
win_id=$(jq -r '.id' <<<"$win")
space_index=$(jq -r '.space' <<<"$win")

stack_ids=()
while IFS= read -r id; do
  stack_ids+=("$id")
done < <(
  yabai -m query --windows --space "$space_index" \
    | jq -r 'map(select(."stack-index" != 0)) | sort_by(."stack-index") | .[].id'
)

count=${#stack_ids[@]}
if [ "$count" -le 1 ]; then
  exit 0
fi

current=-1
for i in "${!stack_ids[@]}"; do
  if [ "${stack_ids[$i]}" = "$win_id" ]; then
    current=$i
    break
  fi
done

if [ "$current" -eq -1 ]; then
  exit 0
fi

case "$dir" in
  next) target=$(( (current + 1) % count )) ;;
  prev) target=$(( (current - 1 + count) % count )) ;;
  *) echo "usage: stack_cycle.sh next|prev" >&2; exit 1 ;;
esac

yabai -m window --focus "${stack_ids[$target]}"
