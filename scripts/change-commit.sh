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
echo "add new line into readme.md" >> README.md
git add .
git commit -m "Feature: this commit must be change! Closes #2" --no-edit --quiet
git --no-pager log --decorate=short --pretty=oneline -n1

echo ""
read -p "change your latest commit info?[y/N]: " confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]];
then
  git commit --amend --quiet
  git --no-pager log -n1
fi

echo ""
echo "change author of commit"
git commit --amend --author="sylvan.tang <sylvan2future@gmail.com>" --no-edit --quiet
git --no-pager log -n1

echo ""
echo "there is another way to change the commit message info which the message is not the latest one ..."
echo "first line into readme.md" >> README.md
git add .
git commit -m "Feature: this commit is latest! Closes #2" --no-edit --quiet

echo "second line into readme.md" >> README.md
git add .
git commit -m "Feature: this commit is latest! Closes #2" --no-edit --quiet

read -p "change your commit info?[y/N]: " confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]];
then
  git rebase -i HEAD~3 --quiet
fi
git --no-pager log --decorate=short --pretty=oneline -n3