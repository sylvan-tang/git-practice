#!/usr/bin/env bash
set -e

# check if commit message is the right format
compare_branch=$(git config --list | grep $1 | cut -d '=' -f 2)

msg_count=$(git --no-pager log $compare_branch..HEAD --decorate=short --pretty=oneline | wc | awk '{print $1}')
if [ $msg_count -ne 1 ]; then
  echo "please combine your commit into one with: git rebase -i HEAD~$msg_count"
  exit 1
fi

msg=$(git --no-pager log $compare_branch..HEAD --decorate=short --pretty=format:"%s")
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
python3 $SCRIPT_PATH/commit_msg.py <<EOF
$msg
EOF