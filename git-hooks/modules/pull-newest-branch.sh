#!/usr/bin/env bash

set -e

current_branch=$(git rev-parse --abbrev-ref HEAD)
echo "current branch is $current_branch"

# make sure the branch is at the newest commit
base_branch=$(git config --list | grep $1 | tail -n 1 | cut -d '=' -f 2)

git checkout $base_branch
git branch --set-upstream-to=origin/$base_branch $base_branch
git config pull.rebase true
git pull

if [[ "${current_branch}" != "${base_branch}" ]]; then
  git checkout $current_branch
  git rebase $base_branch
fi
