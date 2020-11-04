#!/bin/bash

git config credential.helper cache
git checkout master
git pull origin master --tags
git submodule init
git submodule update --recursive
git credential-cache exit
