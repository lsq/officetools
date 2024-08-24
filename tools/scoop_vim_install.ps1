#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
iex "& {$(irm get.scoop.sh)} -RunAsAdmin"

iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni $HOME/vimfiles/autoload/plug.vim -Force
"extras games nerd-fonts nirsoft sysinternals java nonportable php versions" -split '\s+' |`
    {
        scoop bucket add "$_"
    }
scoop install aria2 curl grep sed less touch vim-nightly ctags global
