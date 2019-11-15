#!/usr/bin/env bash

cd $APPVEYOR_BUILD_FOLDER
gem install pry
pry <win32ole-excel.rb
mv `cygpath -u $HOMEPATH`/*.xls $APPVEYOR_JOB_ID
