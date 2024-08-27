#!/usr/bin/bash
set -x
echo "$MSYSTEM"
cd ./tools/vim
export LUA_PREFIX=/ucrt64
MINGW_ARCH=ucrt64 makepkg-mingw --cleanbuild --syncdeps --force --noconfirm
