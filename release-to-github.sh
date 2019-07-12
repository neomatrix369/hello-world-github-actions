#!/bin/bash

set -e
set -u
set -o pipefail

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TARGET_REPO="neomatrix369/hello-world-github-action"

function createNewRelease() {
    POST_DATA=$(printf '{
    "tag_name": "%s",
    "target_commitish": "master",
    "name": "%s",
    "body": "Release %s",
    "draft": false,
    "prerelease": false
  }' ${TAG_NAME} ${TAG_NAME} ${TAG_NAME})
  echo "~~~~ Creating release ${RELEASE_VERSION}: $POST_DATA"
  curl \
      -H "Authorization: token ${MY_GITHUB_TOKEN}" \
      -H "Content-Type: application/json" \
      -H "Accept: application/vnd.github.v3+json" \
      -X POST -d "${POST_DATA}" "https://api.github.com/repos/${TARGET_REPO}/releases"
}

if [[ -z ${MY_GITHUB_TOKEN} ]]; then
  echo "MY_GITHUB_TOKEN cannot be found in the current environment, please populate to proceed either in the startup bash script of your OS or in the environment variable settings of your CI/CD interface."
  exit -1
fi

RELEASE_VERSION="$(cat ${CURRENT_DIR}/version.txt)"
TAG_NAME="v$(cat ${CURRENT_DIR}/version.txt)"

echo "We will be reading version info from the version.txt file, to construct the tagname, please ensure it is the most actual."
echo "Current TAG_NAME=${TAG_NAME}"

echo ""
createNewRelease