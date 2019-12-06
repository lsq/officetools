#!/usr/bin/env bash

which python
pip3 install b4 requests 

cd $APPVEYOR_BUILD_FOLDER/$APPVEYOR_JOB_ID
url=$(python3 $APPVEYOR_BUILD_FOLDER/tools/lzy_dl.py)
wget -c --content-disposition "$url"
