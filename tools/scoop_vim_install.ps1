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

# Customize the location you want to install to,
# preferably without spaces, as it has not been tested
$env:RBENV_ROOT = "C:\Ruby-on-Windows"
iwr -useb "https://github.com/ccmywish/rbenv-for-windows/raw/main/tools/install.ps1" | iex
"$env:RBENV_ROOT\rbenv\bin\rbenv.ps1" init
rbenv global 3
rbenv update
rbenv install 3.2.5-1
