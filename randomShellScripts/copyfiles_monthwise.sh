#!/bin/bash

function get_linux_month_name() {
  #given_name=$1
}

function copy_files() {
  pushd $1
    for f in `ls -lhrt | grep $2 | awk '{print $9}'`;do cp -v $f ./$2; done
  popd
}

function main() {
  copy_files "/home/ubuntu/a_directory_with_a_lot_of_files/" "Apr"
}

main()
