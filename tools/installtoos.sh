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
		  mingw-w64-x86_64-cmake mingw-w64-x86_64-gcc mingw64/mingw-w64-x86_64-python3-pip mingw64/mingw-w64-x86_64-python2-pip \
		  --noconfirm --needed
# pacman -S git subversion mingw64/mingw-w64-x86_64-ruby --noconfirm
pacman -Sy git subversion  --noconfirm --needed
pip2 install requests
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
cd /c/Users/Administrator/
mkdir -p github
cd github
# git config --global http.proxy "http://127.0.0.1:8123"

[ ! -d robust_excel_ole ] && git clone https://github.com/Thomas008/robust_excel_ole.git
# [ ! -d prawn ] && git clone https://github.com/prawnpdf/prawn.git
[ ! -d pdfkit ] && git clone https://github.com/pdfkit/pdfkit.git

gem update --system
gem -v
# CAfile: C:/msys64/mingw64/ssl/certs/ca-bundle.crt
gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
gem sources -l
cd /c/Users/Administrator/github/robust_excel_ole && gem build robust_excel_ole.gemspec && gem install robust_excel_ole*.gem
# cd /c/Users/Administrator/github/prawn && gem build prawn.gemspec && gem install prawn*.gem
cd /c/Users/Administrator/github/pdfkit && gem build pdfkit.gemspec && gem install pdfkit*.gem
gem install mechanize pry watir pincers ffi  rubocop rufo
