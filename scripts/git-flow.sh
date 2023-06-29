#!/usr/bin/env bash

git branch -D main
git branch -D develop
git fetch origin main:main
git branch --set-upstream-to=origin/main main
git fetch origin develop:develop
git branch --set-upstream-to=origin/develop develop

set -e

pre_version=$(git show-ref --tags | tail -n 1 | awk '{print $2}' | cut -d / -f 3)
read -p "当前版本为：${pre_version}, 请输入本次release的版本号：" new_version

git checkout main

git-flow release start $new_version

echo ""
echo "make change and add commit"
echo "Hotfix: first line into readme.md" >> README.md
git add .
git commit -m "Hotfix: first commit Closes #1 Closes #2" --no-edit --quiet
echo "Hotfix: second line into readme.md" >> README.md
git add .
git commit -m "Hotfix: second commit Closes #2 Closes #2" --no-edit --quiet
echo "Hotfix: third line into readme.md" >> README.md
git add .
git commit -m "Hotfix: third commit Closes #3 Closes #2" --no-edit --quiet
git --no-pager log --decorate=short --pretty=oneline -n4

echo ""
echo "Start feature test-flow..."

git checkout develop
git-flow feature start test-flow-$new_version

echo ""
echo "make change and add commit"
echo "first line into readme.md" >> README.md
git add .
git commit -m "Feature: first commit. Closes #2" --no-edit --quiet
echo "second line into readme.md" >> README.md
git add .
git commit -m "Feature: second commit. Closes #2" --no-edit --quiet
echo "third line into readme.md" >> README.md
git add .
git commit -m "Feature: third commit. Closes #2" --no-edit --quiet
git --no-pager log --decorate=short --pretty=oneline -n4

git-flow feature finish test-flow-$new_version
git-flow release finish $new_version