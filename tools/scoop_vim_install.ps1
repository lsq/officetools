#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
iex "& {$(irm get.scoop.sh)} -RunAsAdmin"

iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni $HOME/vimfiles/autoload/plug.vim -Force
"extras games nerd-fonts nirsoft sysinternals java nonportable php versions" -split '\s+' |`
   foreach-object {
        scoop bucket add "$_"
    }
scoop install aria2 curl grep sed less touch vim-nightly ctags global
function downGit($repo, $folder){
    $json = irm https://api.github.com/repos/$repo/contents/$folder?ref=master
    $json | ForEach-Object {
        echo $_.path
        iwr -useb $_.url | ni $_.path -Force
    }
}
downGit "msys2/MSYS2-packages" "vim"
