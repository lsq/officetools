#!/usr/bin/env bash

which python
pip install beautifulsoup4 requests json re

cd $APPVEYOR_BUILD_FOLDER/$APPVEYOR_JOB_ID
python $APPVEYOR_BUILD_FOLDER/tools/lzy_dl.py
