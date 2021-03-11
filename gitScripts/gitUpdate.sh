#!/bin/bash

contains() {
        for item in ${repoList[@]}
        do
                echo "$item $2"
                if [ "$item" == "'$2'" ];then
                        return 0
                fi
        done
        return 1
}

repoMap=`jo -p appdir=~/app ci=~/ci`
repoList=(`echo $repoMap | jq -r 'keys | @sh'`)

function update() {
	curr_dir=$(pwd)
	echo "current dir is $curr_dir"
        repo_name=$1
	branch_name=$2

	if [ -z $branch_name ]; then echo "No branch name"; exit; fi
	contains $repoList "$1"
	if [ "$?" == 0 ];then
		repo_dir=`echo $repoMap | jq -r .$1` 
	        echo $repo_dir
		cd $repo_dir
	else
		echo "repo name not found!";
		exit
	fi

        echo "**************************************************"
	echo "Updating repo $repo_name and branch $branch_name"
	echo "**************************************************"
	ci_sha=$branch_name
	echo "In repo dir"
        pwd
        git clean -f 
        git checkout master
        git reset --hard HEAD
        git pull --all --tags --prune
        git checkout $ci_sha
        git pull --rebase origin $ci_sha
        git branch | grep $ci_sha
	git submodule update --init --recursive
        retval=$?
	cd $curr_dir
        return "$retval"
}
