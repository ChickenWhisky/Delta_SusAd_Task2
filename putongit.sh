#!/bin/sh
# A script to simplify pushing to github

git add .
git commit -m "$1"
git push origin master
