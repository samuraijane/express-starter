#!/bin/sh

build_type=$1
client_dir=$2
server_dir=${PWD##*/} # [1]

test -z $build_type && echo "Please specify which type of build as the first argument." && exit 1
test -z $client_dir && echo "Please specify the name of the client directory as the second argument." && exit 1
test -z $server_dir && echo "We are not able to detect the name of the parent directory. Ensure that the name includes only alphanumeric characters and only "-" and/or "_" if punctuation is used." && exit 1

if [[ "$build_type" != "dev" && "$build_type" != "prod" ]]
  then
    echo "You must specify a build using either 'dev' or 'prod' as the argument." && exit 1
fi

get_branch_name() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

current_branch=$(get_branch_name)

echo "\n======================================================\nBEGIN\nCommencing $build_type build...\n======================================================\n"

echo "\nCreating build directories on server and client...\n"
mkdir -p build/$build_type
npx rimraf build/$build_type/*
mkdir -p ../$client_dir/build

echo "\nProcessing build using client files...\n"
cd ../$client_dir
npx webpack --config webpack.$build_type.js
cd ../$server_dir

echo "\nMoving build files on client to server...\n"
mv ../$client_dir/build/$build_type/* build/$build_type/

echo "\nDeleting build files on client...\n"
npx rimraf ../$client_dir/build

echo "\n======================================================\nSUCCESS\nThe $build_type build for the $current_branch branch has completed\nsuccessfully. Congratulations.\n======================================================\n"

# NOTES
#   [1] See the answer by Charles Duffy at Stack Overflow.
#       https://stackoverflow.com/questions/1371261/get-current-
#       directory-or-folder-name-without-the-full-path
