#!/usr/bin/env bash

set -ex
branch_config_name=$1
current_branch=$(git rev-parse --abbrev-ref HEAD)
echo "current branch is $current_branch"

# make sure the branch is at the newest commit
base_branch=$(git config --list | grep $branch_config_name | tail -n 1 | cut -d '=' -f 2)

git fetch origin $base_branch:$base_branch

if [[ "${current_branch}" != "${base_branch}" ]]; then
  git rebase $base_branch
fi
