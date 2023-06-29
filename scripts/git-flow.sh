#!/usr/bin/env bash
set -e
current_branch=$(git rev-parse --abbrev-ref HEAD)
echo "current branch is $current_branch"

git checkout main

git-flow release start v1.1.0

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

git-flow feature start test-flow

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

git-flow feature finish test-flow

git-flow release finish v1.1.0