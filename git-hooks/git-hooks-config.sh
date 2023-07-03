#!/usr/bin/env bash

set -e

HOOKS_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

git config core.hooksPath $HOOKS_PATH
git config gitflow.path.hooks $HOOKS_PATH

git config gitflow.hotfix.finish.message "Hotfix %tag%"
git config gitflow.release.finish.message "Release %tag%"