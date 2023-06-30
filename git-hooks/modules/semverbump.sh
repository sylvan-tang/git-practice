#!/usr/bin/env bash
function __print_usage {
    echo "Usage: $(basename $0) [major|frame|release|hotfix|<semver>] [<version_file>] [<version_sort>]"
    echo "    major|frame|release|hotfix: Version will be bumped accordingly. "
    echo "    <semver>:          Exact version to use (it won't be bumped)."
    echo "    <version_file>:    File that contains the current version."
    echo "    <version_sort>:    Absolute path to sort binary with optional parameters."
    exit 1
}

function __print_version {
    echo $VERSION_BUMPED
    exit 0
}

# parse arguments

if [ $# -gt 3 ]; then
    __print_usage
fi

VERSION_ARG="$(echo "$1" | tr '[:lower:]' '[:upper:]')"
VERSION_FILE="$2"
VERSION_SORT="$3"
SEMVER_FORMAT='[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+'

# determine sort command

if [ -z "$VERSION_SORT" ]; then
    if [ -x "/opt/local/bin/gsort" ]; then
        VERSION_SORT="/opt/local/bin/gsort -V"
    elif [ -x "/usr/local/bin/gsort" ]; then
        VERSION_SORT="/usr/local/bin/gsort -V"
    else
        VERSION_SORT="/usr/bin/sort -V"
    fi
fi

# determine bump mode

if [ -z "$VERSION_ARG" ] || [ "$VERSION_ARG" == "HOTFIX" ]; then
    VERSION_UPDATE_MODE="HOTFIX"
elif [ "$VERSION_ARG" == "RELEASE" ]; then
    VERSION_UPDATE_MODE=$VERSION_ARG
elif [ "$VERSION_ARG" == "FRAME" ]; then
    VERSION_UPDATE_MODE=$VERSION_ARG
elif [ "$VERSION_ARG" == "MAJOR" ]; then
    VERSION_UPDATE_MODE=$VERSION_ARG
elif [ $(echo "$VERSION_ARG" | grep -E "^$SEMVER_FORMAT$") ]; then
    # semantic version passed as argument
    VERSION_BUMPED=$VERSION_ARG
    __print_version
else
    __print_usage
fi

# read git tags

git fetch --tags
VERSION_PREFIX=$(git config --get gitflow.prefix.versiontag)
TAG_VERSION=$(git tag -l "$VERSION_PREFIX*" | grep -E "$SEMVER_FORMAT$" | $VERSION_SORT | tail -1)

if [ ! -z "$TAG_VERSION" ]; then
    if [ ! -z "$VERSION_PREFIX" ]; then
        VERSION_CURRENT=${TAG_VERSION#$VERSION_PREFIX}
    else
        VERSION_CURRENT=$TAG_VERSION
    fi
fi

# read version from release branch and hotfix branch

RELEASE_VERSION=$(git branch -r --list | grep origin/release | cut -d / -f 3 | $VERSION_SORT | tail -n 1)
HOTFIX_VERSION=$(git branch -r --list | grep origin/hotfix/$RELEASE_VERSION | cut -d / -f 3 | $VERSION_SORT | tail -n 1)

# use 0.0.0 (if version not found by file)

# bump version
if [ -z "$VERSION_PREFIX" ];then
  VERSION_PREFIX="v"
fi


if [ -z "$TAG_VERSION" ];then
  TAG_VERSION="0.0.0"
fi

if [ -z "$RELEASE_VERSION" ];then
  RELEASE_VERSION="0.0.0"
fi

if [ -z "$HOTFIX_VERSION" ];then
  HOTFIX_VERSION="$RELEASE_VERSION.0"
fi

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

VERSION_BUMPED=$(python3 $SCRIPT_PATH/next_version.py $VERSION_PREFIX $TAG_VERSION $RELEASE_VERSION $HOTFIX_VERSION $VERSION_UPDATE_MODE)

__print_version
