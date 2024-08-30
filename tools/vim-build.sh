set -x
echo "$MSYSTEM"
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
#export PATH=$rubyhome/bin:$PATH
#ridk.cmd install
#echo $PATH
ls $rubyhome/bin/
rbpat=$(which ruby)
rbdir=${rbpat%/*}
rubyhm=${rbdir%/*}
rubyversion=$(ruby -v | sed -r -n 's/.* (([0-9]{1,2})\.([0-9]{1,2})\.)[0-9]{1,2} .*/\2\3/p')
rubyapiver=$(ruby -v | sed -r -n 's/.* (([0-9]{1,2})\.([0-9]{1,2})\.)[0-9]{1,2} .*/\10/p')
#sed -i "s|RUBY=\${ruby_home}|RUBY=${rubyhm}|" $APPVEYOR_BUILD_FOLDER/tools/vim/PKGBUILD
#sed -i "s|RUBY_VER=32|RUBY_VER=${rubyversion}|" $APPVEYOR_BUILD_FOLDER/tools/vim/PKGBUILD
#sed -i "s|RUBY_API_VER_LONG=3.2.0|RUBY_API_VER_LONG=${rubyapiver}|" $APPVEYOR_BUILD_FOLDER/tools/vim/PKGBUILD
sed -n 's/\r//p' $APPVEYOR_BUILD_FOLDER/tools/vim/PKGBUILD
export rubyversion rubyapiver rubyhm
pacboy  sync --noconfirm ci.ri2::ruby$rubyversion

pythonver=$(sed 's/\x0d\x0a//' <<< $(powershell '$webc=(iwr https://www.python.org/downloads/windows).content; $mstatus = $webc -match "Latest Python \d Release - Python (?<version>[\d.]+)"; $Matches["version"]'))
pypat=$(which python3)
pydir=${rbpat%/*}
pyhm=${rbdir%/*}
pyversion=$(echo ${pythonver} | sed -r -n 's/.*(([0-9]{1,2})\.([0-9]{1,2})\.)[0-9]{1,2}.*/\2\3/p')
pyapiver=$(echo ${pythonver} | sed -r -n 's/.*(([0-9]{1,2})\.([0-9]{1,2}))\.[0-9]{1,2}.*/\1/p')
export pyversion pyapiver pyhm
#sed -n 's/\r//p' $APPVEYOR_BUILD_FOLDER/tools/vim/PKGBUILD

luaversion=$(lua -v | sed -r -n 's/.*(([0-9]{1,2})\.([0-9]{1,2})\.)[0-9]{1,2}.*/\2\3/p')
tclshversionlong=$(tclsh - <<< 'puts $tcl_patchLevel')
tclversion=$(echo ${tclshversionlong} | sed -r -n 's/.*(([0-9]{1,2})\.([0-9]{1,2})\.)[0-9]{1,2}.*/\2\3/p')
tclapiver=$(echo ${tclshversionlong} | sed -r -n 's/.*(([0-9]{1,2})\.([0-9]{1,2}))\.[0-9]{1,2}.*/\1/p')
perlversion=$(perl -v | sed -r -n 's/.*(([0-9]{1,2})\.([0-9]{1,2})\.)[0-9]{1,2}.*/\2\3/p')
export luaversion perlversion tclversion tclapiver

racketBin=$(which racket)
if [[ ${racketBin} =~ "shim" ]] ;then
    racketB=$(cat ${racketBin}.shim)
    racketBHome=${racketB##*\ }
fi
racketbin=${racketBHome//\"/}
racketHome=$(cygpath -u ${racketbin%\\*})
echo ${racketHome}
racketlib=${racketHome}/lib
echo ${racketlib}
mzlib=$(ls ${racketlib}/libracket*.dll)
mzVer=$(sed 's|libracket||;s|\.dll||' <<< $(basename $mzlib))
echo $mzVer
export racketHome
export mzVer
MINGW_ARCH=ucrt64 makepkg-mingw -eo
MINGW_ARCH=ucrt64 makepkg-mingw -L --cleanbuild --syncdeps --force --noconfirm
