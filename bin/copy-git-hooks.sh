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
echo "- \`brew install git-flow\`" >> $TARGET_PROJECT_PATH/README.md
echo "- \`make git-flow config\`" >> $TARGET_PROJECT_PATH/README.md
echo "" >> $TARGET_PROJECT_PATH/README.md
echo "### git-flow usage" >> $TARGET_PROJECT_PATH/README.md
echo "- make git-flow feature start xxx" >> $TARGET_PROJECT_PATH/README.md
echo "- make git-flow feature publish xxx" >> $TARGET_PROJECT_PATH/README.md
echo "- make git-flow release start x.y.z" >> $TARGET_PROJECT_PATH/README.md
echo "- make git-flow release publish x.y.z" >> $TARGET_PROJECT_PATH/README.md
echo "- make git-flow hotfix start x.y.z.k" >> $TARGET_PROJECT_PATH/README.md
echo "- make git-flow hotfix publish x.y.z.k" >> $TARGET_PROJECT_PATH/README.md
echo "" >> $TARGET_PROJECT_PATH/README.md
echo "### generate changelog" >> $TARGET_PROJECT_PATH/README.md
echo "- \`make changelog\`" >> $TARGET_PROJECT_PATH/README.md
echo "" >> $TARGET_PROJECT_PATH/README.md
echo "### admin user finish git flow" >> $TARGET_PROJECT_PATH/README.md
echo "- \`make git-flow [feature/hotfix/release] finish xxxx\`" >> $TARGET_PROJECT_PATH/README.md