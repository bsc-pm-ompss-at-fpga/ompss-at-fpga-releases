#!/bin/bash

git config credential.helper cache
git checkout master
git submodule init
git submodule update --remote --checkout --recursive
git credential-cache exit
