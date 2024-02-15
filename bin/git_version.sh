#!/bin/bash

# This script generates a string which can help to identify the sources the SWU
# file was built from.
# It generates the version string as:
#   TAG-b.M.m-COMMIT-DATE
# or, if there is no TAGs in the repo:
#   b.M.m-COMMIT-DATE
# where:
#   - b is the SHORT branch identification - the first 6 characters of the branch
#       or the developer's name (i.e. 'john' if the branch name is john/development).
#       Note that 'main' branch will not be shown.
#   - M is the major version defined in this file (see below MAJOR variable definition)
#   - m is the minor version caculated as number of commits since that variable was changed.
#
# In addition, if the repository had uncommited changes the version string will get
# the user's name as a suffix, for example
# f217e84-20220929-bill.1.23-bill.smith

# Increment this number periodically or on a certain milestones.
# Note that we could use several a complex string too, i.e. "3.14", "R12", etc.
MAJOR="1"

BASE_DIR="$(cd "$(dirname "$0")/.."; pwd)"
cd $BASE_DIR

# Get minor version
getMinorVersion() {
    # Get SHA for the MAJOR version line
    MAJOR_SHA=$(git blame $0 | grep MAJOR=| grep -v 00000000| awk '{ print $1}')
    # Get current SHA
    HEAD_SHA=$(git log -1|grep ^commit |awk '{ print substr($2,0,8)}')
    # Print number of commits since MAJOR has been changed:
    NUMBER=$(git rev-list $HEAD_SHA...$MAJOR_SHA|wc -l)
    echo $NUMBER
}
MINOR=$(getMinorVersion)

# Determine the branch identifier
BRANCH=$(git branch|grep "^*"|awk '{ print substr($2,0,6) }' | awk -F/ '{ print $1}')
if [[ "$BRANCH" == "main" ]]; then
    BRANCH_ID=""
else
    BRANCH_ID="$BRANCH."
fi

LONG_COMMIT=$(git rev-parse HEAD)
TAG=$(git describe --abbrev=0 --tags ${LONG_COMMIT} 2>/dev/null || true)
COMMIT=$(git rev-parse --short HEAD)
DATE=$(git log -1 --format=%cd --date=format:\"%Y%m%d\" | tr -d '"')
CHANGES=$(git status --untracked-files=no --porcelain)

cd - > /dev/null

SUFFIX=""

if [ ! -z "$CHANGES" ]; then
    SUFFIX="-dirty"
fi

if [ -z "$TAG" ]; then
    VERSION=$BRANCH_ID$MAJOR.$MINOR-$COMMIT-$DATE$SUFFIX
else
    VERSION=$TAG-$MAJOR.$MINOR-$COMMIT-$DATE$SUFFIX
fi

echo $VERSION

