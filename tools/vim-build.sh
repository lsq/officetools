#!/usr/bin/bash
set -x
echo "$MSYSTEM"
cd ./vim
MINGW_ARCH=msys makepkg-mingw --cleanbuild --syncdeps --force --noconfirm
cd ./tools/vim
export LUA_PREFIX=/ucrt64
MINGW_ARCH=ucrt64 makepkg-mingw --cleanbuild --syncdeps --force --noconfirm
