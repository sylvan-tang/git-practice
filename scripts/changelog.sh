#!/usr/bin/env bash

current_branch=$(git rev-parse --abbrev-ref HEAD)
echo "current branch is $current_branch"

filename=$(basename "$0")
branch_name=feature/"${filename%%.*}"
echo ""
echo "Checkout to an new branch ${branch_name}..."

git checkout main
git tag -d v1.0.0
git tag v1.0.0

git branch -D ${branch_name}
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
git --no-pager log --decorate=short --pretty=oneline -n4

git tag -d v1.0.1
git tag v1.0.1


# generate change between two tag into a markdown table with commit, author, date and title
second_to_last_tag_commit=$(git show-ref --tags | tail -n 2 | head -n 1 | awk '{print $1}')
last_tag_commit=$(git show-ref --tags | tail -n 1  | awk '{print $1}')
last_tag=$(git show-ref --tags | tail -n 1 | awk '{print $2}' | cut -d / -f 3)

echo "# RELEASE $last_tag" > CHANGELOG.tmp.md
echo "| commit | commit author name | commit date | title |" >> CHANGELOG.tmp.md
echo "| ---- | ---- | ---- | ---- |" >> CHANGELOG.tmp.md

echo $(git --no-pager log --decorate=short --pretty=format:"| %h | %cn | %cs | %s |" $second_to_last_tag_commit..$last_tag_commit) >> CHANGELOG.tmp.md

if [[ -f CHANGELOG.md ]]; then
  cat CHANGELOG.md >> CHANGELOG.tmp.md
fi
mv CHANGELOG.tmp.md CHANGELOG.md
