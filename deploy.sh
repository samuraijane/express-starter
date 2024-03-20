#!/bin/sh

server_dir=${PWD##*/}

get_branch_name() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

current_branch=$(get_branch_name)

if [[ "$current_branch" != "prod" ]]
  then
    echo "DEPLOYMENT FAILED\nDeploying is allowed only while on branch prod.\n" && exit 1
fi

echo "\n======================================================\nBEGIN\nCommencing deployment to Heroku...\n======================================================\n"

git add build/
git commit -m "add latest build"
git push heroku prod:main
