#!/usr/bin/env bash

if [ "$1" == "" ] ; then
    echo "provide branch to remove from both origin and local"
else
    BRANCH=$1

    git checkout master
    git push --delete origin ${BRANCH}
    git branch -d ${BRANCH}
fi
