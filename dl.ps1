# set-executionpolicy remotesigned
### Modify a system environment variable 
###[Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::Machine)

### Modify a user environment variable 
###[Environment]::SetEnvironmentVariable("INCLUDE", $env:INCLUDE, [System.EnvironmentVariableTarget]::User)

### Usage from comments - add to the system environment variable
<#
###[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";C:\bin",
    [EnvironmentVariableTarget]::Machine)
    #>
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";C:\msys64\mingw64\bin;C:\msys64\usr\bin",
    [EnvironmentVariableTarget]::Machine)
#
$currentpath = "$(pwd | Select-String \\)"
$env:Path +=  ";C:\Program Files\7-Zip;C:\msys64\mingw64\bin;C:\msys64\usr\bin;$currentpath"
$filename="$(Get-Date -Format 'yyyyMdHMs').txt"
echo $env:Path > $filename
#curl --version
$client = new-object System.Net.WebClient
$msys2='msys2-x86_64-20190524.exe'
$msbash='C:\msys64\usr\bin\bash.exe'
$pacmanset='pacmanset.sh'
$installtool='installtools.sh'
$client.DownloadFile('https://mirrors.cqu.edu.cn/CTAN/systems/texlive/tlnet/tlpkg/installer/wget/wget.exe', "$currentpath\wget.exe")
#wget -Uri 'https://mirrors.cqu.edu.cn/CTAN/systems/texlive/tlnet/tlpkg/installer/wget/wget.exe' -OutFile 'wget.exe'
#$client.DownloadFile('https://curl.haxx.se/windows/dl-7.67.0_4/curl-7.67.0_4-win64-mingw.zip', 'curl.zip')
#wget  -uri 'https://curl.haxx.se/windows/dl-7.67.0_4/curl-7.67.0_4-win64-mingw.zip' -OutFile 'curl.zip'
wget.exe -c -t 5 https://www.7-zip.org/a/7z1900-x64.exe
.\7z1900-x64.exe
.\wget.exe -c -t 5  ftp://ftp.info-zip.org/pub/infozip/win32/unz600xn.exe
.\unz600xn.exe -o
.\wget.exe -c -t 5 -d --header="User-Agent: Mozilla/5.0 (Windows NT 6.0) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.97 Safari/537.11" --header="Referer: https://curl.haxx.se/windows/dl-7.67.0_4/" https://curl.haxx.se/windows/dl-7.67.0_4/curl-7.67.0_4-win64-mingw.zip
# .\wget.exe -c -t 3 https://curl.haxx.se/windows/dl-7.67.0_4/curl-7.67.0_4-win64-mingw.zip -o curl.zip
# powershell 2.0 not support 
# Expand-Archive .\curl.zip -DestinationPath .
.\unzip.exe -o .\curl*.zip
(test-path curl) -and ( rm -Force -Recurse .\curl)
mv curl-7.* curl
$env:Path +=  ";.\curl\bin"
#$client.DownloadFile('https://mirrors.cqu.edu.cn/CTAN/systems/texlive/tlnet/tlpkg/installer/wget/wget.exe','wget.exe')
# wget -uri https://mirrors.cqu.edu.cn/CTAN/systems/texlive/tlnet/tlpkg/installer/wget/wget.exe -OutFile wget.exe
#$client.DownloadFile('http://mirrors.ustc.edu.cn/CTAN/systems/texlive/tlnet/tlpkg/installer/wget/wget.exe', 'wget.exe')
# wget.exe -c -t 5 -o $msys2 https://mirrors.tuna.tsinghua.edu.cn/msys2/distrib/x86_64/msys2-x86_64-20190524.exe
curl.exe -sSLO https://mirrors.tuna.tsinghua.edu.cn/msys2/distrib/x86_64/msys2-x86_64-20190524.exe
# wget.exe -c -t 5 -o $msys2 http://mirrors.ustc.edu.cn/msys2/distrib/x86_64/msys2-x86_64-20190524.exe
# $client.DownloadFile('http://iso.mirrors.ustc.edu.cn/msys2/distrib/x86_64/msys2-x86_64-20190524.exe', $msys2)
(Test-Path $msys2)  -and (Start-Process .\$msys2 -wait)
if(Test-Path $msbash) { echo "bash in path..." }else{ exit }
# html to sed
$sedtext = @"
 /<table.*>/,/<\/table>/{
  :de
  s/<\\(script\\|style\\).*<\/\\(script\\|style\\)>//g
  /<\\(script\\|style\\).*$/ {
    N
    b de
  }
  s/<[^><]*>//g
  /<[^>]*>/ b de
  /<[^>]*$/ {
    N
    b de
  }
  s/&nbsp;/ /g
  /^[[:space:]]*$/ d
  s/&quot;/\"/g
  #s/[[:space:]]\\+/ /g
 s/&nbsp;/ /g; s/&amp;/\&/g; s/&lt;/</g; s/&gt;/>/g; s/&quot;/\"/g; s/&#39;/\'/g; s/&ldquo;/\"/g; s/&rdquo;/\"/g
  /#!\/usr/{
   h
   s/[^ ]\+.*//
   x
   s/^ \+//
   b w
 }
  G
  x
  G
  s/\( \+\)\n\1\(.\+\)\n\1$/\2/
  T ne
  :rs
  x
  s/.*\n//
  x
  :w
  # w tt.txt
  p
  b
  :ne
  s/\( \+\)\n\(.\+\)\n\1$/\2/
  b rs
}
"@

$sedtext | out-file  .\htmlToascii.sed -Encoding utf8
sed -i 's/\xEF\xBB\xBF//g' .\htmlToascii.sed
function htmlToascii($url, $localfile){
curl.exe -sSL $url | sed -n -f .\htmlToascii.sed > $localfile
sed -i 's/\xEF\xBB\xBF//g' $localfile
}

## 
curl.exe -sLSO "https://download-ssl.firefox.com.cn/releases-sha2/stub/official/zh-CN/Firefox-latest.exe"
(Test-Path Firefox-latest.exe)  -and (Start-Process .\Firefox-latest.exe )
curl.exe -sLSO  "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B20C5A533-0647-7599-741A-D8AD97BBC271%7D%26lang%3Dzh-CN%26browser%3D4%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Ddefaultbrowser/update2/installers/ChromeSetup.exe"
(Test-Path ChromeSetup.exe)  -and  (Start-Process .\ChromeSetup.exe )
wget.exe -c -d https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-win64.zip
unzip.exe -o geckodriver-v0.26.0-win64.zip
cp geckodriver*.exe C:\Windows\System32
wget.exe -c  -d https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v7.8.1/npp.7.8.1.Installer.x64.exe
(Test-Path npp.7.8.1.Installer.x64.exe)  -and  (Start-Process .\npp.7.8.1.Installer.x64.exe )
wget.exe -c -d https://github.com/kkkgo/KMS_VL_ALL/releases/download/32/KMS_VL_ALL-32.zip
unzip.exe -o KMS_VL_ALL-32.zip
wget.exe -c -d https://github.com/lboulard/vim-win32-build/releases/download/v8.1.2384/gvim-8.1.2384-amd64.exe
(Test-Path gvim-8.1.2384-amd64.exe)  -and  (Start-Process .\gvim-8.1.2384-amd64.exe )
#curl.exe  -vSL "https://raw.githubusercontent.com/lsq/officetools/master/tools/pacmanset.sh" -o $pacmanset
#curl.exe -vSL "https://raw.githubusercontent.com/lsq/officetools/master/tools/installtoos.sh" -o $installtool
#(Test-Path $msys2)  -and (cmd /c $msys2)
wget.exe -c  "https://github.com/sysprogs/WinCDEmu/releases/download/v4.1/WinCDEmu-4.1.exe"
(Test-Path WinCDEmu-4.1.exe)  -and  (Start-Process .\WinCDEmu-4.1.exe )

# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/start-process?view=powershell-6
# Start-Process -FilePath "$env:comspec" -ArgumentList "/c dir `"%systemdrive%\program files`""
# Start-Process -FilePath "$env:comspec" -ArgumentList "/c", $msbash, "-c `"pacman -Syu`"" -NoNewWindow -Wait
Start-Process -FilePath "$env:comspec" -ArgumentList "/c", $msbash, "-c `"pacman -Syu`""  -Wait
Start-Process -FilePath "$env:comspec" -ArgumentList "/c", $msbash, "-c `"pacman -Syu`""  -Wait
if (! (cat $pacmanset|grep '#!' )) {htmlToascii  https://github.com/lsq/officetools/blob/master/tools/pacmanset.sh  $pacmanset}
if((Test-Path $msbash) -and (Test-Path $pacmanset) ){ cmd.exe /c $msbash -x $pacmanset  }else{ exit }
if (! (cat $installtool|grep '#!')) { htmlToascii  https://github.com/lsq/officetools/blob/master/tools/installtoos.sh  $installtool}
Start-Process -FilePath "$env:comspec" -ArgumentList "/c", $msbash, "-x $installtool"  -Wait

(Test-Path $env:USERPROFILE\vimfiles)  -and  (mv $env:USERPROFILE\vimfiles $env:USERPROFILE\vimfiles_orig)




# (Test-Path C:\msys64\usr\bin\bashs.exe) -and (echo $a)
