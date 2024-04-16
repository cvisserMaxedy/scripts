#!/bin/sh
# Install git lfs - https://git-lfs.github.com
#
# To run this script on Codeship, add the following
# command to your project's setup commands:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/git-lfs.sh | bash -s
#
# Add the following environment variable to your project configuration
# (otherwise the default below will be used).
# * GIT_LFS_VERSION
#
GIT_LFS_VERSION=${GIT_LFS_VERSION:="2.7.0"}
GIT_LFS_DIR=${GIT_LFS_DIR:="./git-lfs"}
REPO_DIR=$(readlink -f "./clone")
DOWNLOAD_URL_PREFIX="git-lfs-linux-amd64-"
STRIP_COMPONENTS=1

set -e

if [ "${GIT_LFS_VERSION:0:1}" -ge 2 ] && [ "${GIT_LFS_VERSION:2:1}" -ge 5 ]; then
        DOWNLOAD_URL_PREFIX="git-lfs-linux-amd64-v"
        STRIP_COMPONENTS=0
fi

mkdir -p "${GIT_LFS_DIR}"
wget --continue --output-document "https://github.com/github/git-lfs/releases/download/v${GIT_LFS_VERSION}/${DOWNLOAD_URL_PREFIX}${GIT_LFS_VERSION}.tar.gz"
tar -xaf --strip-components=${STRIP_COMPONENTS} --directory "${GIT_LFS_DIR}"

(
  cd "${GIT_LFS_DIR}" || exit 1
  PREFIX=${HOME} bash ./install.sh
)

(
  cd "${REPO_DIR}" || exit 1
  git lfs fetch
  git lfs checkout
)

git lfs version | grep "git-lfs/${GIT_LFS_VERSION}"
