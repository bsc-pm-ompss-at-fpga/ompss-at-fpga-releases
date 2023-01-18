#!/bin/bash -e

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
  sed -i "s/\(user-guide-\)\([0-9]\|[.]\)*\(-rc[0-9]*\)\?/\1${VERSION}/" README.md

  #Enable the cache mode for credentials in metarepository and every submodule
  git config credential.helper cache
  git submodule foreach git config credential.helper cache

  #Stash the updated subrepos and commit the changes + create the tag
  git add ait mcxx nanox ompss-at-fpga-kernel-module xdma xtasks Changelog.md README.md
  git commit -m "OmpSs-at-FPGA release ${VERSION}"
  git tag ${VERSION}
  git push origin master --tags

  #Create a release tag in each subrepo and push them
  git submodule foreach git tag -m "OmpSs-at-FPGA release ${VERSION}" ompss-at-fpga-release/${VERSION}
  git submodule foreach git push origin tag ompss-at-fpga-release/${VERSION}

  #Clear the credentials cache
  git credential-cache exit

popd >/dev/null
