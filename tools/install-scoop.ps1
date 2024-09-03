iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
"main extras games nerd-fonts nirsoft sysinternals java nonportable php versions" -split '\s+' |`
   foreach-object {
        if ($_ -eq "main") { scoop bucket rm main }
        scoop bucket add "$_"
    }
scoop bucket add lsq https://github.com/lsq/scoopet
scoop update
