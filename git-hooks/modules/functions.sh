#!/usr/bin/env bash

COLOR_RED=$(printf '\e[0;31m')
COLOR_DEFAULT=$(printf '\e[m')
ICON_CROSS=$(printf $COLOR_RED'✘'$COLOR_DEFAULT)

script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_DIR=$(dirname $script_path)

if [ -f "$HOOKS_DIR/git-flow-hooks-config.sh" ]; then
    source "$HOOKS_DIR/git-flow-hooks-config.sh"
fi

if [ -f "$ROOT_DIR/.git/git-flow-hooks-config.sh" ]; then
    source "$ROOT_DIR/.git/git-flow-hooks-config.sh"
fi

export CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

function __print_fail {
    echo -e "  $ICON_CROSS $1"
}

function __get_commit_files {
    echo $(git diff-index --name-only --diff-filter=ACM --cached HEAD --)
}

function __get_version_file {
    if [ -z "$VERSION_FILE" ]; then
        VERSION_FILE="VERSION"
    fi

    echo "$ROOT_DIR/$VERSION_FILE"
}

function __get_hotfix_version_bumplevel {
    if [ -z "$VERSION_BUMPLEVEL_HOTFIX" ]; then
        VERSION_BUMPLEVEL_HOTFIX="HOTFIX"
    fi

    echo $VERSION_BUMPLEVEL_HOTFIX
}

function __get_release_version_bumplevel {
    if [ -z "$VERSION_BUMPLEVEL_RELEASE" ]; then
        VERSION_BUMPLEVEL_RELEASE="RELEASE"
    fi

    echo $VERSION_BUMPLEVEL_RELEASE
}

function __is_binary {
    P=$(printf '%s\t-\t' -)
    T=$(git diff --no-index --numstat /dev/null "$1")

    case "$T" in "$P"*) return 0 ;; esac

    return 1
}
