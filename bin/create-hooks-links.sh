#!/usr/bin/env bash
set -e

PROJECT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

function create_hook_link() {
  scriptName=$1

  if [[ ! -L $PROJECT_PATH/.git/hooks/$scriptName && -f $PROJECT_PATH/.git/hooks/$scriptName ]]; then
    read -p "$PROJECT_PATH/.git/hooks/$scriptName already exists; will you delete it?: Y/N" input
    if [[ $input == "N" ]]; then
      exit 0;
    fi
    rm $PROJECT_PATH/.git/hooks/$scriptName
  fi
  ln -sf $PROJECT_PATH/bin/$scriptName $PROJECT_PATH/.git/hooks/$scriptName
}

create_hook_link pre-commit
create_hook_link pre-push