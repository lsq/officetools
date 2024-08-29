#!/usr/bin/bash
set -x
printf "$MSYSTEM"
pacman --noconfirm --sync --needed pactoys
pacman-key --recv-keys BE8BF1C5
pacman-key --lsign-key BE8BF1C5
repman add ci.ri2 "https://github.com/oneclick/rubyinstaller2-packages/releases/download/ci.ri2"
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
rbpat=$(which ruby)
rbdir=${rbpat%/*}
rubyhm=${rbdir%/*}
rubyversion=$(ruby -v | sed -r -n 's/.* (([0-9]{1,2})\.([0-9]{1,2})\.)[0-9]{1,2} .*/\2\3/p')
rubyapiver=$(ruby -v | sed -r -n 's/.* (([0-9]{1,2})\.([0-9]{1,2})\.)[0-9]{1,2} .*/\10/p')
sed -i "s|RUBY=\${ruby_home}|RUBY=${rubyhm}|" $APPVEYOR_BUILD_FOLDER/tools/vim/PKGBUILD
sed -i "s|RUBY_VER=32|RUBY_VER=${rubyversion}" $APPVEYOR_BUILD_FOLDER/tools/vim/PKGBUILD
sed -i "s|RUBY_API_VER_LONG=3.2.0|RUBY_API_VER_LONG=${rubyapiver}" $APPVEYOR_BUILD_FOLDER/tools/vim/PKGBUILD
MINGW_ARCH=ucrt64 makepkg-mingw -L --cleanbuild --syncdeps --force --noconfirm
