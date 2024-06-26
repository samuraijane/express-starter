#!/bin/sh

get_branch_name() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

current_branch=$(get_branch_name)

if [[ "$current_branch" != "prod" ]]
  then
    echo "DEPLOYMENT FAILED\nDeploying is allowed only while on branch prod.\n" && exit 1
fi

echo "\n======================================================\nBuilding version file..."
get_hash() {
  git rev-parse --short HEAD
}
get_hash_date() {
  git log -n1 --pretty='format:%cd' --date=format:'%b %d %Y %H:%M:%S (%z)'
}

# get hash and hash date for client
cd ../react-starter
_CH=$(get_hash)
_CHD=$(get_hash_date)

# get hash and hash date for server
cd ../express-starter
_SH=$(get_hash)
_SHD=$(get_hash_date)

create_version_summary() {
  echo "$(
    echo SERVER
    echo "• "$_SH
    echo "• "$_SHD
    echo
    echo CLIENT
    echo "• "$_CH
    echo "• "$_CHD
  )"
}
# colors
blue="\033[0;34m"
reset="\033[0m"

version_summary=$(create_version_summary)
filename="version.txt"
echo "$blue"
if [ -f "$filename" ]
  then
    rm $filename
    echo "Removing $filename since it already exists."
fi
echo "${version_summary}" >> $filename
echo "Creating new $filename to capture latest version information.$reset"

echo "\n======================================================\nDeploying to Heroku..."

git add build/ version.txt
git commit -m "update to $_SH / $_CH"
# If the push includes commits that were rebased from branch main, the
# next line will fail. In this scenario, you must force push and do so
# manually with `git push heroku +prod:main`.
git push heroku prod:main
