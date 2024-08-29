#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
iex "& {$(irm get.scoop.sh)} -RunAsAdmin"

iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni $HOME/vimfiles/autoload/plug.vim -Force
"extras games nerd-fonts nirsoft sysinternals java nonportable php versions" -split '\s+' |`
   foreach-object {
        scoop bucket add "$_"
    }
scoop install aria2 curl grep sed less touch  ctags global #vim-nightly
function downGit($repo, $folder){
    $json = irm https://api.github.com/repos/$repo/contents/$($folder)?ref=master
    $json | ForEach-Object {
        echo $_.path
        iwr -useb $($_).download_url | ni $_.path -Force
    }
}
downGit "msys2/MSYS2-packages" "vim"
#downGit "lsq/officetools" "tools/vim"

<#
# Customize the location you want to install to,
# preferably without spaces, as it has not been tested
$env:RBENV_ROOT = "C:\Ruby-on-Windows"

# iwr -useb "https://github.com/ccmywish/rbenv-for-windows/raw/main/tools/install.ps1" | iex
iex "& {$(irm 'https://github.com/ccmywish/rbenv-for-windows/raw/main/tools/install.ps1')} -RunAsAdmin"
#new-Item -ItemType junction -Path  $env:RBENV_ROOT\msys64 -Target c:\msys64
do {
    sleep -seconds 2.0
} until (Test-Path $env:RBENV_ROOT\rbenv\bin\rbenv.ps1)
sed.exe -i 's|\((Test-Path \"\$env:RBENV_ROOT\\\msys64\")\)|(\1 -or (Test-Path \"c:\\\msys64\" ))|' $env:RBENV_ROOT\rbenv\bin\rbenv.ps1
& "$env:RBENV_ROOT\rbenv\bin\rbenv.ps1" init
rbenv global 3
rbenv update
rbenv install 3.2.5-1
#>
echo $rubyhome --- $env:rubyhome
$rubyhome = $env:rubyhome
$rubyversion = [System.iO.Path]::GetFileName($rubyhome)
$rubyroot = [system.iO.Path]::GetDirectoryName($rubyhome)
iwr https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-$rubyversion/rubyinstaller-$rubyversion-x64.7z -OutFile rubyinstaller-$rubyversion-x64.7z
Start-Process 7z.exe -ArgumentList "x", ".\rubyinstaller-$rubyversion-x64.7z", "-o$rubyroot" -Wait
#7z x .\rubyinstaller-$rubyversion-x64.7z  -o$rubyroot
mv $rubyroot\rubyinstaller-$rubyversion-x64 $rubyhome

#$env:USER_PATH=[Environment]::GetEnvironmentVariable("PATH", "User") 
$env:USER_PATH=[Environment]::GetEnvironmentVariable("PATH", "Machine") 
#// ↓勿直接使用$env:PATH，会触发问题2，用临时变量$env:USER_PATH来过渡一下
$env:USER_PATH=$env:USER_PATH -replace "c:\\Ruby32\\bin;", "$rubyhome\bin;" #// 先在console中临时替换
$env:USER_PATH="$rubyhome\bin;$rubyhome\gems\bin;" + $env:USER_PATH
[Environment]::SetEnvironmentVariable("PATH", $env:USER_PATH, 'Machine')  #   // 使临时替换永久生效
#(删除PATH中的某一个路径替换为""即可)
echo $env:PATH
which ruby
gem install rake

