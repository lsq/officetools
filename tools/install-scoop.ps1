iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
Write-host "$env:path"
$env:path="$env:USERPROFILE\scoop\shims;$env:path"
@'
start "$env:USERPROFILE\scoop\apps"
'@ > open_scoop_dir.ps1
Write-host "$env:path"
which scoop
"main extras games nerd-fonts nirsoft sysinternals java nonportable php versions" -split '\s+' |`
   foreach-object {
        if ($_ -eq "main") { scoop bucket rm main }
        scoop bucket add "$_"
    }
scoop bucket rm lsq
scoop bucket add lsq https://github.com/lsq/scoopet
scoop update
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
ni $HOME/vimfiles/autoload/plug.vim -Force
#scoop install lsq/aria2
scoop install aria2
which aria2c
scoop config aria2-retry-wait 4
scoop config aria2-split 16
scoop config aria2-max-connection-per-server 16
scoop config aria2-min-split-size 4M 
scoop config aria2-options @("-m 5")
scoop config aria2-enabled true
scoop install curl ctags global jq notepad3 #vim-nightly

#Get-ChildItem Env:
C:\msys64\usr\bin\bash.exe -lc "pacman --noconfirm -Syuu"
C:\msys64\usr\bin\bash.exe -lc "pacman --noconfirm -Syuu"
C:\msys64\usr\bin\bash.exe -lc "pacman --noconfirm -Sy mingw-w64-ucrt-x86_64-aria2"
