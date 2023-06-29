#!/usr/bin/env bash

current_branch=$(git rev-parse --abbrev-ref HEAD)
echo "current branch is $current_branch"

filename=$(basename "$0")
branch_name=feature/"${filename%%.*}"
echo ""
echo "Checkout to an new branch ${branch_name}..."

git branch -D ${branch_name}

git checkout -b ${branch_name}

echo ""
echo "make change and add commit"
echo "first line into readme.md" >> README.md
git add .
git commit -m "first commit." --no-edit --quiet
echo "second line into readme.md" >> README.md
git add .
git commit -m "second commit." --no-edit --quiet
echo "third line into readme.md" >> README.md
git add .
git commit -m "third commit." --no-edit --quiet
git --no-pager log --decorate=short --pretty=oneline -n4

echo ""
read -p "combine your commit info?[y/N]: " confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]];
then
  commit_count=$(git rev-list --left-right --count "$current_branch"...@ | awk '{print $2}')
  git rebase -i HEAD~${commit_count} --quiet
  git --no-pager log -n${commit_count}
fi