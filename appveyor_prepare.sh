#!/usr/bin/env bash

set -exuo pipefail
PKG_PREFIX="mingw-w64-$MSYS2_ARCH"
pacman -Syu --noconfirm
pacman -Syuu --noconfirm
pacman -S --noconfirm --needed base-devel\
       ${PKG_PREFIX}-json-c \
       ${PKG_PREFIX}-glib2 \
       ${PKG_PREFIX}-gobject-introspection\
	   bash pacman msys2-runtime
pacman -S --noconfirm git subversion \
     mingw64/mingw-w64-x86_64-ruby \
	   mingw64/mingw-w64-x86_64-libxslt python3 python\
	   mingw64/mingw-w64-x86_64-sqlite3 msys/libsqlite-devel unzip mingw64/mingw-w64-x86_64-aria2
pacman -Sy bash man pacman msys2-runtime base-devel --noconfirm --needed
pacman -Sy mingw64/mingw-w64-x86_64-clang mingw64/mingw-w64-x86_64-sqlite3 \
		  mingw64/mingw-w64-x86_64-libxml2 msys/libxml2-devel mingw64/mingw-w64-x86_64-libxslt msys/libxslt-devel\
		  mingw64/mingw-w64-x86_64-sqlcipher msys/libsqlite-devel mingw64/mingw-w64-x86_64-ruby \
		  mingw64/mingw-w64-x86_64-polipo \
		  --noconfirm --needed
# sys-utils
pacman -Sy mingw64/mingw-w64-x86_64-python2 mingw-w64-x86_64-make\
		  mingw-w64-x86_64-toolchain libraries development compression VCS  net-utils msys2-devel\
		  mingw-w64-x86_64-cmake mingw-w64-x86_64-gcc mingw64/mingw-w64-x86_64-python3-pip  \
		  --noconfirm --needed

# 
echo ---------------
# echo %path%
#which set
#echo -----set-------
#set  | grep access_token
#which env
#echo ++++++env++++++
#env | grep access_token
#echo $PATH
#cat >~/.git-credentials <<EOF
#https://$access_token:x-oauth-basic@github.com
#EOF
#echo ---------------
#bash -x get_hugo.sh
## which hugo && /usr/bin/hugo -t hugo-theme-den --baseUrl="https://github.com/lsq/lsq.github.io"
#mkdir $APPVEYOR_JOB_ID
##bash -x get_latest.sh 2dust/v2rayNG v2rayNG_1.1.9_arm64-v8a.apk
#bash -x get_latest.sh src/readme content/posts/downloaded.md
