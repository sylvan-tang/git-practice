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
echo "fourth line into readme.md" >> README.md
git add .
git commit -m "fourth commit." --no-edit --quiet
git --no-pager log --decorate=short --pretty=oneline -n4

cherry_pick_commit_B=$(git --no-pager log --decorate=short --pretty=oneline -n4 | head -n 2 | tail -n 1 | awk '{print $1}')
cherry_pick_commit_A=$(git --no-pager log --decorate=short --pretty=oneline -n4 | head -n 3 | tail -n 1 | awk '{print $1}')

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
read -p "cherry pick ${cherry_pick_commit_A} from ${branch_name} into ${branch_name}-B?[y/N]: " confirm
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]];
then
  git cherry-pick ${cherry_pick_commit_A}^..${cherry_pick_commit_B}
else
  # ignore cherry_pick_commit_A, equal to: git cherry-pick ${cherry_pick_commit_B}
  git cherry-pick ${cherry_pick_commit_A}..${cherry_pick_commit_B}
fi

git --no-pager log --decorate=short --pretty=oneline -n4
