#!/usr/bin/bash
set -x
echo "$MSYSTEM"
cd ./tools/vim
MINGW_ARCH=ucrt64 makepkg-mingw --cleanbuild --syncdeps --force --noconfirm
