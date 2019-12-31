#!/usr/bin/env bash
#set -euxo pipefail
trap 'exit' INT QUIT
#pacman -Syu
pacman -Syu
pacman -Sy bash man pacman msys2-runtime base-devel --noconfirm --needed
pacman -Sy mingw64/mingw-w64-x86_64-clang mingw64/mingw-w64-x86_64-sqlite3 \
		  mingw64/mingw-w64-x86_64-libxml2 msys/libxml2-devel mingw64/mingw-w64-x86_64-libxslt msys/libxslt-devel\
		  mingw64/mingw-w64-x86_64-sqlcipher msys/libsqlite-devel mingw64/mingw-w64-x86_64-ruby \
		  mingw64/mingw-w64-x86_64-polipo \
		  --noconfirm --needed
pacman -Sy mingw64/mingw-w64-x86_64-python2 mingw-w64-x86_64-make\
		  mingw-w64-x86_64-toolchain libraries development compression VCS sys-utils net-utils msys2-devel\
		  mingw-w64-x86_64-cmake mingw-w64-x86_64-gcc mingw64/mingw-w64-x86_64-python3-pip \
		  --noconfirm --needed
# pacman -S git subversion mingw64/mingw-w64-x86_64-ruby --noconfirm
pacman -Sy git subversion  --noconfirm --needed
wget -c https://bootstrap.pypa.io/get-pip.py
python2 get-pip.py
pip2 install requests
pip3 install bs4
cat >~/.polipo <<EOF
socksParentProxy="127.0.0.1:10808"
socksProxyType="socks5"
proxyAddress="127.0.0.1"
proxyPort=8123
EOF
ps aux|grep polipo
if [ $? -eq 0 ]; then
	echo "already running"
else
	polipo.exe -c ~/.polipo &
fi
cd  $USERPROFILE
mkdir -p github
cd github
ALL_PROXY=socks5://127.0.0.1:10808
git config --global http.proxy 'socks5://127.0.0.1:10808'
git config --global https.proxy 'socks5://127.0.0.1:10808'
# git config --global http.proxy "http://127.0.0.1:8123"
[ ! -d robust_excel_ole ] && git clone https://github.com/Thomas008/robust_excel_ole.git
# [ ! -d prawn ] && git clone https://github.com/prawnpdf/prawn.git
[ ! -d pdfkit ] && git clone https://github.com/pdfkit/pdfkit.git
[ ! -d axlsx ] && git clone https://github.com/randym/axlsx.git
[ ! -d axlsx_styler ] && git clone https://github.com/axlsx-styler-gem/axlsx_styler.git
[ ! -d sqlite3-ruby ] && git clone https://github.com/sparklemotion/sqlite3-ruby.git
[ ! -d roo ] && git clone https://github.com/roo-rb/roo.git
[ ! -d roo-xls ] && git clone https://github.com/roo-rb/roo-xls.git
gem update --system
gem -v
# CAfile: C:/msys64/mingw64/ssl/certs/ca-bundle.crt
gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
gem sources -l
cd  "$USERPROFILE\github\robust_excel_ole" && gem build robust_excel_ole.gemspec && gem install robust_excel_ole*.gem
# cd /c/Users/Administrator/github/prawn && gem build prawn.gemspec && gem install prawn*.gem
cd  "$USERPROFILE\github\pdfkit" && gem build pdfkit.gemspec && gem install pdfkit*.gem
cd  "$USERPROFILE\github\axlsx" && gem build axlsx.gemspec && gem install axlsx*.gem
cd  "$USERPROFILE\github\axlsx_styler" && gem build axlsx_styler.gemspec && gem install axlsx_styler*.gem
cd  "$USERPROFILE\github\roo" && gem build roo.gemspec && gem install roo*.gem
cd  "$USERPROFILE\github\roo-xls" && gem build roo-xls.gemspec && gem install roo-xls*.gem
cd  "$USERPROFILE\github\sqlite3-ruby" && gem build sqlite3.gemspec && gem install sqlite3*.gem

gem install rdoc watir-extensions-element-screenshot mechanize pry watir pincers ffi  rubocop rufo 
