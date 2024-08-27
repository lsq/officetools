#!/usr/bin/bash
set -x
printf "$MSYSTEM"
cd ./vim
MINGW_ARCH=msys makepkg-mingw --cleanbuild --syncdeps --force --noconfirm
cd $APPVEYOR_BUILD_FOLDER/tools/vim
export LUA_PREFIX=/ucrt64
MINGW_ARCH=ucrt64 makepkg-mingw --cleanbuild --syncdeps --force --noconfirm
