#!/bin/sh

REPO_DIR=$(readlink -f "${HOME}/clone")

apt-get install git-lfs

(
  cd "${REPO_DIR}" || exit 1
  git lfs fetch
  git lfs checkout
)

git lfs version | grep "git-lfs/${GIT_LFS_VERSION}"
