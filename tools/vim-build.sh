#!/usr/bin/bash
set -x
printf "$MSYSTEM"
#cd ./vim
#MINGW_ARCH=msys makepkg-mingw --cleanbuild --syncdeps --force --noconfirm
cd $APPVEYOR_BUILD_FOLDER/tools/vim
#export LUA_PREFIX=/ucrt64
#export rubyhome=/c/Ruby-on-Windows/3.2.5-1
echo $PATH
export PATH=$rubyhome/bin:$PATH
echo $PATH
MINGW_ARCH=ucrt64 makepkg-mingw -L --cleanbuild --syncdeps --force --noconfirm
