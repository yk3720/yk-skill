#!/usr/bin/env bash
# 複数の git リポジトリを横断して fetch し、fast-forward 可能なものだけ自動 pull する。
# dirty / diverged / upstream 不明 / fetch 失敗は pull せず理由付きで報告する。
#
# Usage: bash sync-repos.sh <dir1> [<dir2> ...]
# Output: 1行1リポジトリ、タブ区切り "STATUS\tpath\tbranch\tahead\tbehind\tdetail"
set -uo pipefail

if [ "$#" -eq 0 ]; then
  echo "usage: sync-repos.sh <dir1> [<dir2> ...]" >&2
  exit 1
fi

for dir in "$@"; do
  if [ ! -d "$dir" ]; then
    printf 'NOT_FOUND\t%s\t-\t-\t-\t\n' "$dir"
    continue
  fi

  if ! git -C "$dir" rev-parse --git-dir >/dev/null 2>&1; then
    printf 'NOT_A_REPO\t%s\t-\t-\t-\t\n' "$dir"
    continue
  fi

  branch=$(git -C "$dir" branch --show-current 2>/dev/null)
  if [ -z "$branch" ]; then
    printf 'DETACHED_HEAD\t%s\t-\t-\t-\t\n' "$dir"
    continue
  fi

  fetch_err=$(git -C "$dir" fetch --all --prune 2>&1 1>/dev/null)
  if [ $? -ne 0 ]; then
    printf 'FETCH_FAILED\t%s\t%s\t-\t-\t%s\n' "$dir" "$branch" "$(echo "$fetch_err" | tr '\n' ' ')"
    continue
  fi

  upstream=$(git -C "$dir" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)
  if [ -z "$upstream" ]; then
    printf 'NO_UPSTREAM\t%s\t%s\t-\t-\t\n' "$dir" "$branch"
    continue
  fi

  counts=$(git -C "$dir" rev-list --left-right --count "HEAD...$upstream" 2>/dev/null)
  ahead=$(echo "$counts" | cut -f1)
  behind=$(echo "$counts" | cut -f2)

  if [ "$behind" = "0" ]; then
    printf 'UP_TO_DATE\t%s\t%s\t%s\t0\t\n' "$dir" "$branch" "$ahead"
    continue
  fi

  dirty=$(git -C "$dir" status --porcelain)
  if [ -n "$dirty" ]; then
    printf 'DIRTY\t%s\t%s\t%s\t%s\t\n' "$dir" "$branch" "$ahead" "$behind"
    continue
  fi

  if [ "$ahead" != "0" ]; then
    printf 'DIVERGED\t%s\t%s\t%s\t%s\t\n' "$dir" "$branch" "$ahead" "$behind"
    continue
  fi

  pull_err=$(git -C "$dir" pull --ff-only 2>&1 1>/dev/null)
  if [ $? -eq 0 ]; then
    printf 'PULLED\t%s\t%s\t0\t%s\t\n' "$dir" "$branch" "$behind"
  else
    printf 'PULL_FAILED\t%s\t%s\t%s\t%s\t%s\n' "$dir" "$branch" "$ahead" "$behind" "$(echo "$pull_err" | tr '\n' ' ')"
  fi
done
