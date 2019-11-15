#!/usr/bin/env bash

cd $APPVEYOR_BUILD_FOLDER
ruby  win32ole-excel.rb
mv $HOMEPATH/*.xls %APPVEYOR_JOB_ID%
