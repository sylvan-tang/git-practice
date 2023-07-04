#!/usr/bin/env bash

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# Runs at the end of git flow release finish
# generate change between two tag into a markdown table with commit, author, date and title
last_tag_commit=$(git show-ref --tags | tail -n 1 | head -n 1 | awk '{print $1}')
last_commit=HEAD
current_tag=$(git rev-parse --abbrev-ref HEAD | cut -d / -f 2)

if [[ $# -eq 1 ]];then
  current_tag=$1
fi
if [[ $# -eq 2 ]];then
  last_commit=$2
fi
if [[ $# -eq 3 ]];then
  last_tag_commit=$3
fi

tag_exists=""
if [[ -f CHANGELOG.md ]]; then
  tag_exists=$(grep $current_tag CHANGELOG.md)
fi
if [[ ! -z $tag_exists ]]; then
  exit 0
fi

TITLE="RELEASE"
n=${#current_tag}
if [[ $n -eq 8 ]]; then
  TITLE="HOTFIX"
fi
echo "# $TITLE $current_tag" > CHANGELOG.tmp.md
echo "" >> CHANGELOG.tmp.md
echo "| commit | commit author name | commit date | title |" >> CHANGELOG.tmp.md
echo "| ---- | ---- | ---- | ---- |" >> CHANGELOG.tmp.md

git --no-pager log --decorate=short --pretty=format:"| %h | %cn | %cs | %s |" $last_tag_commit..$last_commit >> CHANGELOG.tmp.md
echo "" >> CHANGELOG.tmp.md

if [[ -f CHANGELOG.md ]]; then
  echo "" >> CHANGELOG.tmp.md
  cat CHANGELOG.md >> CHANGELOG.tmp.md
fi
mv CHANGELOG.tmp.md CHANGELOG.md
