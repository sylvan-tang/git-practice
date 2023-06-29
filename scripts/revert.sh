#!/usr/bin/env bash

current_branch=$(git rev-parse --abbrev-ref HEAD)
echo "current branch is $current_branch"

filename=$(basename "$0")
branch_name=feature/"${filename%%.*}"
git branch -D ${branch_name}

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

revert_commit_B=$(git --no-pager log --decorate=short --pretty=oneline -n4 | head -n 2 | tail -n 1 | awk '{print $1}')
revert_commit_A=$(git --no-pager log --decorate=short --pretty=oneline -n4 | head -n 3 | tail -n 1 | awk '{print $1}')

read -p "revert ${revert_commit_A}?[y/N]: " confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]];
then
  git revert ${revert_commit_A}^..${revert_commit_B}
else
  # ignore revert_commit_A, equal to: git revert ${cherry_pick_commit_B}
  git revert ${revert_commit_A}..${revert_commit_B}
fi

git --no-pager log --decorate=short --pretty=oneline -n4
