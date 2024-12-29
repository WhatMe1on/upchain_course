#!/bin/bash

script_dir=$(dirname "$0")
cd $script_dir
TORAP=$(pwd)
cd -
echo "TORAP=$TORAP" >>./.env
