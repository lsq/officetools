#!/usr/bin/env bash
function str_convert() {
	while read -r line; do
		#echo -n "$line" | iconv -f utf-8 -t gbk
		iconv -t utf-8 -f gbk <<<"$line" &>/dev/null
		if [ $? -ne 0 ]; then
			# iconv -f utf-8 -t gbk <<<"$line" | tee -a err.txt
			old_line=$(sed 's,[/\\],\\&,g' <<<"$line")
			new_line=$(echo -n "$line" | sed 's,[/\\],\\&,g' | iconv -t gbk -f utf-8)
			#
			sed -i "s^$old_line^$new_line^" $1
		fi
	done < $1
}
sed -i '/## msys2.org/a Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/i686' /etc/pacman.d/mirrorlist.mingw32
sed -i '/## msys2.org/a Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/x86_64' /etc/pacman.d/mirrorlist.mingw64
sed -i '/## msys2.org/a Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/msys/$arch' /etc/pacman.d/mirrorlist.msys
sed -i '/## msys2.org/a Server = https://mirrors.huaweicloud.com/msys2/mingw/i686' /etc/pacman.d/mirrorlist.mingw32
sed -i '/## msys2.org/a Server = https://mirrors.huaweicloud.com/msys2/mingw/x86_64' /etc/pacman.d/mirrorlist.mingw64
sed -i '/## msys2.org/a Server = https://mirrors.huaweicloud.com/msys2/msys/$arch' /etc/pacman.d/mirrorlist.msys
# echo -e 'set path_=%Path%\r\nsetx "Path" "%path_%;C:\Ruby25-x64\msys64\usr\\bin;C:\Ruby25-x64\msys64\mingw64\\bin" /m' >setpath.sh
rubydir=$(ls /c/Ruby*/ -d |awk -F'/' '{print $3}')
msysbin="${rubydir}\msys64\usr\bin"
mingw64bin="${rubydir}\msys64\mingw64\bin"
p7z="C:\Program Files\7-Zip"
#cat >setpath.bat <<EOF
# rem @echo off & setlocal enableDelayedExpansion
echo $PATH
# rem skip 璺宠繃琛屾暟
# rem for /f "tokens=1 delims=, " %%i in ('wmic ENVIRONMENT where "name='path' and username='<system>'"  get VariableValue') do (
# rem Set /a n+=1 
# rem If !n!==2 (Echo %%i
# rem set mp=%%i
# rem )
# rem )
# rem echo ----------
# rem echo %mp%
# rem set path_=%path%
# $(which gawk) '/C.*:.*\\/' envb.txt
# setx Path "$mp;C:\\${msysbin};C:\\${mingw64bin};" /M
# rem wmic ENVIRONMENT where "name='path' and username='<system>'"  set VariableValue='%path%;C:\\${msysbin};C:\\${mingw64bin}'
#EOF
#
# file setpath.bat
# sed -i 's/$/\r/g' setpath.bat
# chmod +x setpath.bat
# ./setpath.bat
# wmic ENVIRONMENT where "name='path' and username='<system>'"  get VariableValue | gawk '/.*:.*\\/'
wmic ENVIRONMENT where "name='path' and username='<system>'"  get VariableValue | gawk '/.*\\.*;.*/'
mp=$(wmic ENVIRONMENT where "name='path' and username='<system>'"  get VariableValue | gawk '/.*\\.*;.*/')
# setx "Path" "${mp};C:\\${msysbin};C:\\${mingw64bin};" /M
echo $mp---- 
# mp="e:\\f\\"
mp=$(echo -n "${p7z};${mp};C:\\${mingw64bin};C:\\${msysbin};"|sed 's#\(\\\)\{2\}#\\#g' |gawk -F';' '{for (i=1; i<=NF; i++) if (! arr[$i]++)  printf "%s;",$i }' |
sed 's#;*[ ]*;\{1,\}#;#g')
#echo ++$mp | iconv -f gb2312 -t gbk
#echo $mp > mp.txt
#
# cat >setpath.bat <<EOF
# before write to bat file , please ensure convert string to utf-8, eithor use str_convert function
# mp=$(echo -n $mp|iconv -f gbk -t utf-8)
echo $mp+++
# wmic ENVIRONMENT where "name='path' and username='<system>'"  set VariableValue='$mp\'
# EOF
#
# ./setpath.bat
# C:\Ruby26-x64\bin;C:\Program Files\Alacritty\;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;C:\MySP\绯荤粺璋冭瘯\;C:\MySP\甯哥敤杞欢\;C:\MySP\璋冭瘯宸ュ叿;C:\MySP\纭欢妫€娴媆;C:\MySP\杩滅▼宸ュ叿\
# right with no space
# wmic ENVIRONMENT where "name='lsq' and username='<system>'"  set VariableValue=\'"$mp"\'
# cmd //c wmic ENVIRONMENT where "name='lsq' and username='<system>'"  set VariableValue=\'"$mp"\'

# mp=$(echo -n ${mp}";c:\\abc\lsq"|sed 's/[ ]*;/;/g')
# cmd //c wmic ENVIRONMENT where name=\'lsq\'   set VariableValue=\'"$mp"\'
# cmd //c wmic ENVIRONMENT where "name='lsq' and username='<system>'"   set VariableValue=\'"$mp"\'
# wmic ENVIRONMENT where "name='lsq' and username='<system>'"  get # get VariableValue
# mp=$(echo -n ${mp}";\"f:\\www\ ypj\""|sed 's/[ ]*;/;/g')
# mp=$(echo -n ${mp}';\"f:\\www\" \"ypj\"'|sed 's/[ ]*;/;/g')
echo -------------$mp---------------
# cmd //c wmic ENVIRONMENT where "name='path' and username='<system>'"   "set VariableValue=""'$mp'"
#
#
cmd //c wmic ENVIRONMENT where "name='path' and username='<system>'"  get VariableValue
#
cat >setpath.bat <<EOF
@echo off & setlocal enableDelayedExpansion
:: ECHO %PATH%
:: echo $PATH
rem skip 跳过行数
rem for /f "tokens=1 delims=, " %%i in ('wmic ENVIRONMENT where "name='path' and username='<system>'"  get VariableValue') do (
rem Set /a n+=1 
rem If !n!==2 (Echo %%i
rem set mp=%%i
rem )
rem )
@echo ----mp------
@echo $mp
rem set path_=%path%
rem $(which gawk) '/C.*:.*\\/' envb.txt
:: setx Path "$mp;C:\\${msysbin};C:\\${mingw64bin};e:\f" /M
rem wmic ENVIRONMENT where "name='path' and username='<system>'"   set VariableValue="$mp"
setx Path "$mp" /M
:: echo %PATH%
rem wmic ENVIRONMENT where "name='path' and username='<system>'"  set VariableValue='%path%;C:\\${msysbin};C:\\${mingw64bin}'
wmic ENVIRONMENT where "name='path' and username='<system>'"  get
EOF
## if $mp had converted before write to bat file, comment this line
str_convert setpath.bat
sed -i 's/$/\r/g' setpath.bat
cmd //c setpath.bat
wmic ENVIRONMENT where "name='path' and username='<system>'"  get
# set pacman color
sed -i 's/^#Color/Color/' /etc/pacman.conf

