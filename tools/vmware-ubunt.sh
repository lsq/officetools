set -e
apt update
apt upgrade -y
# need reboot
reboot

# install vm-tools
apt install open-vm-tools-desktop
# reboot
reboot
apt install -y docker.io gnupg2 curl gawk vim software-properties-common git ibus-table-wubi ibus-table ibus-pinyin ibus-rime librime-data-wubi librime-data-pinyin-simp

mkdir -p ~/.config/ibus/rime/ 
cat > ~/.config/ibus/rime/default.custom.yaml <<EOF
patch:

       schema_list:

               - schema: wubi_pinyin

               - schema: pinyin_simp

               - schema: wubi86
EOF
# 并且修改
# wubi_pinyin.schema.yaml 
# switches下的reset 值由0改为1，意思是重启后默认由中文状态改为英文状态
#
# https://www.cnblogs.com/anliven/p/6218741.html
cat > /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": [
    "https://dockerhub.azk8s.cn",
    "https://docker.mirrors.ustc.edu.cn",
    "https://registry.docker-cn.com"
  ]
}
EOF

systemctl daemon-reload
systemctl restart  docker

wget -c -t 3 https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-linux64.tar.gz &&
tar xf geckodriver-v0.26.0-linux64.tar.gz &&
cp geckodriver /usr/bin/ &
curl -sLf https://spacevim.org/install.sh | bash

gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
apt-add-repository -y ppa:rael-gc/rvm
apt-get update
apt-get install rvm
# Now, in order to always load rvm, change the Gnome Terminal to always perform a login.

# At terminal window, click Edit > Profile Preferences, click on Title and Command tab and check Run command as login shell.
# A lot of changes were made (scripts that needs to be reloaded, you're now member of rvm group) and in order to properly get all them working, you need to reboot (in most cases a logout/login is enough, but in some Ubuntu derivatives or some terminal emulators, a shell login is not performed, so we advice to reboot).
# 
reboot
rvm install ruby
gem update --system
gem -v
# CAfile: C:/msys64/mingw64/ssl/certs/ca-bundle.crt
gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
gem sources -l
gem  install rdoc mechanize pry watir pincers ffi  rubocop rufo 