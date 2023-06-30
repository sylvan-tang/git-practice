#!/usr/bin/env bash

TARGET_PROJECT_PATH=$1
PROJECT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"
cp -r $PROJECT_PATH/git-hooks $TARGET_PROJECT_PATH/
if [[ -f $TARGET_PROJECT_PATH/Makefile ]]; then
  echo "" >> $TARGET_PROJECT_PATH/Makefile
fi
cat $PROJECT_PATH/Makefile >> $TARGET_PROJECT_PATH/Makefile
echo "## install git-flow hooks" >> $TARGET_PROJECT_PATH/README.md
echo "- install brew" >> $TARGET_PROJECT_PATH/README.md
echo "- `brew isntall git-flow`" >> $TARGET_PROJECT_PATH/README.md
echo "- `make git-flow config`" >> $TARGET_PROJECT_PATH/README.md
echo "" >> $TARGET_PROJECT_PATH/README.md
echo "### git-flow usage" >> $TARGET_PROJECT_PATH/README.md
echo "- make git-flow feature start xxx" >> $TARGET_PROJECT_PATH/README.md
echo "- make git-flow feature publish xxx" >> $TARGET_PROJECT_PATH/README.md
echo "- make git-flow release start vx.y.z" >> $TARGET_PROJECT_PATH/README.md
echo "- make git-flow release publish vx.y.z" >> $TARGET_PROJECT_PATH/README.md
echo "- make git-flow hotfix start vx.y.z.m" >> $TARGET_PROJECT_PATH/README.md
echo "- make git-flow hotfix publish vx.y.z.m" >> $TARGET_PROJECT_PATH/README.md
echo "" >> $TARGET_PROJECT_PATH/README.md
echo "### generate changelog" >> $TARGET_PROJECT_PATH/README.md
echo "- `make changelog`" >> $TARGET_PROJECT_PATH/README.md