#!/usr/bin/env bash

# 下面的脚本执行之后可以初步看出 merge 和 rebase 之间的差别

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
echo "make change base on ${current_branch}..."
git checkout ${current_branch}
git branch -D ${branch_name}-B
git checkout -b ${branch_name}-B
echo "first line into readme.md on ${branch_name}-B" >> README.md
git add .
git commit -m "first commit on ${branch_name}-B." --no-edit --quiet
echo "second line into readme.md on ${branch_name}-B" >> README.md
git add .
git commit -m "second commit on ${branch_name}-B." --no-edit --quiet
git --no-pager log --decorate=short --pretty=oneline -n4


echo ""
read -p "rebase ${branch_name} into ${branch_name}-B?[y/N]: " confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]];
then
  git rebase ${branch_name}
else
  git merge ${branch_name}
fi

read -p "show git log graph ?[y/N]: " confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]];
then
  git log --graph
fi