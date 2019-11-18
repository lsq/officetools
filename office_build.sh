#!/usr/bin/env bash

cd $APPVEYOR_BUILD_FOLDER
type gem
gem install pry
type pry
which pry | cygpath -w -f -
ruby win32ole-excel.rb
mv `cygpath -u $HOMEPATH`/*.xls $APPVEYOR_JOB_ID
