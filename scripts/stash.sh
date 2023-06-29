#!/usr/bin/env bash

current_branch=$(git rev-parse --abbrev-ref HEAD)
echo "current branch is $current_branch"

filename=$(basename "$0")
branch_name=feature/"${filename%%.*}"
git branch -D ${branch_name}
git branch -D ${branch_name}-B

echo ""
echo "Checkout to an new branch ${branch_name}..."
git checkout -b ${branch_name}

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
echo "fourth line into readme.md" >> README.md
git add .
git commit -m "Feature: fourth commit. Closes #2" --no-edit --quiet
git --no-pager log --decorate=short --pretty=oneline -n4

cherry_pick_commit_B=$(git --no-pager log --decorate=short --pretty=oneline -n4 | head -n 2 | tail -n 1 | awk '{print $1}')
cherry_pick_commit_A=$(git --no-pager log --decorate=short --pretty=oneline -n4 | head -n 3 | tail -n 1 | awk '{print $1}')

echo ""
echo "make change base on ${current_branch}..."
git checkout ${current_branch}
git checkout -b ${branch_name}-B
echo "first line into readme.md on ${branch_name}-B" >> README.md
git add .
echo "second line into readme.md on ${branch_name}-B" >> README.md
git add .

echo ""
echo "start stash your change..."
git stash

git stash list

echo ""
read -p "pop stash to ${branch_name}?[y/N]: " confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]];
then
  git checkout ${branch_name}
  git stash pop
  git add .
  git commit -m "Feature: lines from ${branch_name}-B commit. Closes #2" --no-edit --quiet
fi

git --no-pager log --decorate=short --pretty=oneline -n4
