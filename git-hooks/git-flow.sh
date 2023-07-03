#!/usr/bin/env bash
set -e

END_KEY_WORDS=("branch" "delete" "finish" "publish" "pull" "start" "track")
GIT_HOOK_PATH=$(git config --list | grep "gitflow.path.hooks=" | cut -d "=" -f 2)

LAST_WORD="${@: -1}"
if [[ $LAST_WORD == [hH] || $LAST_WORD == [hH][eE][lL][pP] ]];then
  # 'make git-flow --help' or 'make git-flow -h' will set off Makefile's own help document
  # so use 'make git-flow [command] help' instead
  git-flow ${@:1:$#-1} -h
  exit 0
fi

commands=()
i=1

for var in "$@"; do
  commands+=($var)
  let "i=i+1"
  if [[ ${END_KEY_WORDS[@]} =~ $var ]]; then
    break
  fi
done
middle_command=$(printf ",%s" "${commands[@]}" | sed -e 's/,/-/g')
middle_command=${middle_command:1}

if [[ -z "${middle_command}" ]]; then
  echo "Usage:"
  git-flow -h
  exit 0
fi

${GIT_HOOK_PATH}/pre-flow-$middle_command ${@:$i}
git-flow $@
${GIT_HOOK_PATH}/post-flow-$middle_command ${@:$i}
