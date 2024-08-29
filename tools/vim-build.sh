#!/usr/bin/bash
set -x
printf "$MSYSTEM"
#cd ./vim
#MINGW_ARCH=msys makepkg-mingw --cleanbuild --syncdeps --force --noconfirm
cd $APPVEYOR_BUILD_FOLDER/tools/vim
#export LUA_PREFIX=/ucrt64
#export rubyhome=/c/Ruby-on-Windows/3.2.5-1
echo $PATH
#PATH=/${MSYSTEM}/bin:/${MSYSTEM}/bin/site_perl/5.38.2:/${MSYSTEM}/bin/vendor_perl:/${MSYSTEM}/bin/core_perl:/usr/local/bin:/usr/bin:/bin
export PATH=$rubyhome/bin:$PATH
ridk.cmd install
echo $PATH
ls $rubyhome/bin/
MINGW_ARCH=ucrt64 makepkg-mingw -L --cleanbuild --syncdeps --force --noconfirm
