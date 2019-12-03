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
$env:Path +=  ";C:\msys64\mingw64\bin;C:\msys64\usr\bin"
$filename="$(Get-Date -Format 'yyyyMdHMs').txt"
echo $env:Path > $filename
#curl --version
$client = new-object System.Net.WebClient
$msys2='msys2-x86_64-20190524.exe'
$msbash='C:\msys64\usr\bin\bash.exe'
$pacmanset='pacmanset.sh'
$installtool='installtools.sh'
wget -Uri 'https://mirrors.cqu.edu.cn/CTAN/systems/texlive/tlnet/tlpkg/installer/wget/wget.exe' -OutFile 'wget.exe'
wget  -uri 'https://curl.haxx.se/windows/dl-7.67.0_4/curl-7.67.0_4-win64-mingw.zip' -OutFile 'curl.zip'
#.\wget.exe https://curl.haxx.se/windows/dl-7.67.0_4/curl-7.67.0_4-win64-mingw.zip
Expand-Archive .\curl.zip -DestinationPath .
mv curl-7.* curl
$env:Path +=  ";.\curl\bin"
#$client.DownloadFile('https://mirrors.cqu.edu.cn/CTAN/systems/texlive/tlnet/tlpkg/installer/wget/wget.exe','wget.exe')
# wget -uri https://mirrors.cqu.edu.cn/CTAN/systems/texlive/tlnet/tlpkg/installer/wget/wget.exe -OutFile wget.exe
#$client.DownloadFile('http://mirrors.ustc.edu.cn/CTAN/systems/texlive/tlnet/tlpkg/installer/wget/wget.exe', 'wget.exe')
curl.exe -sLS -o $msys2 http://mirrors.ustc.edu.cn/msys2/distrib/x86_64/msys2-x86_64-20190524.exe
# $client.DownloadFile('http://iso.mirrors.ustc.edu.cn/msys2/distrib/x86_64/msys2-x86_64-20190524.exe', $msys2)
(Test-Path $msys2)  -and (Start-Process .\$msys2 -wait)
if(Test-Path $msbash) { echo "bash in path..." }else{ exit }
curl.exe  -s https://raw.githubusercontent.com/lsq/officetools/master/tools/pacmanset.sh -o $pacmanset
curl.exe -s https://raw.githubusercontent.com/lsq/officetools/master/tools/installtoos.sh -o $installtool
#(Test-Path $msys2)  -and (cmd /c $msys2)
if((Test-Path $msbash) -and (Test-Path $pacmanset) ){ cmd /c $msbash -x $pacmanset  }else{ exit }
cmd /c $msbash pacman -Syu


# (Test-Path C:\msys64\usr\bin\bashs.exe) -and (echo $a)
