#!/usr/bin/env bash

curl -sOL https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_12130-20272.exe
ls -al
7z x officedeploymenttool_12130-20272.exe
cat >installOffice.bat <<EOF
setup.exe /download o2019.xml
setup.exe /configure o2019.xml
EOF
cmd //c installOffice.bat
ls -al
df -h

cd $APPVEYOR_BUILD_FOLDER
type gem
gem install pry
type pry
which pry | cygpath -w -f -
#ruby win32ole-excel.rb
pry <win32ole-excel.rb
mv `cygpath -u $HOMEPATH`/*.xls $APPVEYOR_JOB_ID
