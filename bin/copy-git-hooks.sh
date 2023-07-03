#!/usr/bin/env bash

TARGET_PROJECT_PATH=$1
PROJECT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"
cp -r $PROJECT_PATH/git-hooks $TARGET_PROJECT_PATH/
if [[ -f $TARGET_PROJECT_PATH/Makefile ]]; then
  echo "" >> $TARGET_PROJECT_PATH/Makefile
fi
cat $PROJECT_PATH/Makefile >> $TARGET_PROJECT_PATH/Makefile
echo "## install git-flow hooks" >> $TARGET_PROJECT_PATH/README.md
echo "`make git-flow config`" >> $TARGET_PROJECT_PATH/README.md
echo "### git-flow usage"
echo "- make git-flow feature start xxx"
echo "- make git-flow feature publish xxx"
echo "- make git-flow release start vx.y.z"
echo "- make git-flow release publish vx.y.z"
echo "- make git-flow hotfix start vx.y.z.m"
echo "- make git-flow hotfix publish vx.y.z.m"