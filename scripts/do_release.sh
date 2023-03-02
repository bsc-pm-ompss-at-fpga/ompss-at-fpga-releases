#!/bin/bash

if [ "$#" -ne "1" ]; then
  echo -e "USAGE:\t$0 <release version>"
  exit 0
fi
VERSION=$1

#NOTE: Ensure running in the repo root dir
pushd `dirname ${BASH_SOURCE[0]}`/../ >/dev/null

  CHANGELOG_DIFF=`git diff Changelog.md`
  if [ "x$CHANGELOG_DIFF" == "x" ]; then
    echo -e "ERROR:\tThe changelog does not contain the release changes"
    exit 0
  fi

  #Set user-guide URL
  sed -i "s/\(user-guide-\)\([0-9]\|[.]\)*\(-rc[0-9]\?\)\?/\1${VERSION}/" README.md

  git config credential.helper cache
  git checkout master
  git submodule init
  git submodule update --remote --checkout --recursive
  pushd ait
    #NOTE: The default branch in private AIT repo is master-public instead of master
    git fetch origin master
    git checkout FETCH_HEAD
  popd
  ./scripts/commit_release.sh ${VERSION}
  # NOTE: Done at the end of commit_release.sh
  #git credential-cache exit

popd >/dev/null
