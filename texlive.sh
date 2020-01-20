#!/usr/bin/env bash -e

basename() {
    # Usage: basename "path" ["suffix"]
    local tmp

    #echo "${1##*[!/]}"
    tmp=${1%"${1##*[!/]}"}
    tmp=${tmp##*/}
    tmp=${tmp%"${2/"$tmp"}"}

    printf '%s\n' "${tmp:-/}"
}

### only for iso file on unix
#mount -t iso9660 -o ro,loop,noauto /your/texlive.iso /mnt


### for network install
creat_profile(){
  cat > install_texlive.profile <<-EOF
  # texlive.profile written on Thu Jan  2 06:12:48 2020 UTC
# It will NOT be updated and reflects only the
# installation profile at installation time.
selected_scheme scheme-full
TEXDIR C:/texlive/2019
TEXMFCONFIG ~/.texlive2019/texmf-config
TEXMFHOME ~/texmf
TEXMFLOCAL C:/texlive/texmf-local
TEXMFSYSCONFIG C:/texlive/2019/texmf-config
TEXMFSYSVAR C:/texlive/2019/texmf-var
TEXMFVAR ~/.texlive2019/texmf-var
binary_win32 1
collection-basic 1
collection-bibtexextra 1
collection-binextra 1
collection-context 1
collection-fontsextra 1
collection-fontsrecommended 1
collection-fontutils 1
collection-formatsextra 1
collection-games 1
collection-humanities 1
collection-langarabic 1
collection-langchinese 1
collection-langcjk 1
collection-langcyrillic 1
collection-langczechslovak 1
collection-langenglish 1
collection-langeuropean 1
collection-langfrench 1
collection-langgerman 1
collection-langgreek 1
collection-langitalian 1
collection-langjapanese 1
collection-langkorean 1
collection-langother 1
collection-langpolish 1
collection-langportuguese 1
collection-langspanish 1
collection-latex 1
collection-latexextra 1
collection-latexrecommended 1
collection-luatex 1
collection-mathscience 1
collection-metapost 1
collection-music 1
collection-pictures 1
collection-plaingeneric 1
collection-pstricks 1
collection-publishers 1
collection-texworks 1
collection-wintools 1
collection-xetex 1
instopt_adjustpath 1
instopt_adjustrepo 1
#instopt_desktop_integration 1
#instopt_file_assocs 1
instopt_letter 0
instopt_portable 0
#instopt_w32_multi_user 1
instopt_write18_restricted 1
tlpdbopt_autobackup 1
tlpdbopt_backupdir tlpkg/backups
tlpdbopt_create_formats 1
tlpdbopt_desktop_integration 1
tlpdbopt_file_assocs 1
tlpdbopt_generate_updmap 0
tlpdbopt_install_docfiles 1
tlpdbopt_install_srcfiles 1
tlpdbopt_post_code 1
tlpdbopt_sys_bin /usr/local/bin
tlpdbopt_sys_info /usr/local/share/info
tlpdbopt_sys_man /usr/local/share/man
tlpdbopt_w32_multi_user 1

EOF
}
download_source(){
  wget -c "$1"
}
install_texlive(){
  local sr_url="$1"
  local tar_file="${sr_url##*/}"
  creat_profile
  [ -n "$tar_file" ] && download_source $sr_url
  #local sr_dir=$(basename "$tar_file" .tar.gz)
  [ -f "$tar_file" ] && local sr_dir=$(tar tf "$tar_file" | head -1)
  [ $? -ne 0 -o -z "$sr_dir" ] && exit 1
  tar xf "$tar_file" && cd "$sr_dir"
  sudo ./install-tl -q -profile install_texlive.profile
}

decrypt()
{
  echo "Decrypting $1..."
  openssl enc -aes-256-cbc -d -a -k $TEX_KEY -in $1 -out $2 || { echo "File not found"; return 1; }
  echo "Successfully decrypted"
}

iso_install(){
  creat_profile
  aria2c -c -s 20 -o texlive.iso $1
  [ ! -f texlive.iso ] && exit 1
  file texlive.iso
  #sudo mount -t iso9660 -o ro,loop,noauto ./texlive.iso /mnt
  #sudo mount texlive.iso /mnt
  #cd /mnt
  ls -al
  #sudo ./install-tl -q -profile $APPVEYOR_BUILD_FOLDER/install_texlive.profile
  # Mount-DiskImage -ImagePath
  # Dismount-DiskImage -ImagePath "texlive.iso"
  cat > mount-texliveiso.ps1 <<'EOF'
    # wmic LogicalDisk get FreeSpace,Size /value
    $currentdir = "$PWD"
    $texliveiso = "$currentdir\texlive.iso"
    echo $texliveiso

    wmic LogicalDisk list
   # 获取逻辑磁盘盘符

    wmic logicaldisk where drivetype=3 get deviceid

    # 获取移动磁盘盘符

    # wmic locgicaldisk where drivetype=2 get deviceid
    # 获取光盘盘符
    Mount-DiskImage -ImagePath $texliveiso
    wmic logicaldisk where drivetype=5 get deviceid
    # Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DriveType -ne 5} |    Sort-Object -Property Name | Select-Object Name, VolumeName
    # Get-WmiObject -Class Win32_logicaldisk -Filter "DriveType = \'3\'"
    $isod = $(wmic logicaldisk where drivetype=5 get deviceid | grep ":" |head -1).trim()
    cd $isod
    ls 
     .\install-tl-advanced.bat -no-gui -q -profile $currentdir\install_texlive.profile
    Dismount-DiskImage -ImagePath $texliveiso
EOF
  powershell -ExecutionPolicy Unrestricted  -File mount-texliveiso.ps1
  # cmd //c start texlive.iso
  # cmd //c  install-tl-windows.bat -q -profile $APPVEYOR_BUILD_FOLDER/install_texlive.profile
}

# https://mirror.bjtu.edu.cn/ctan/systems/texlive/tlnet/tlpkg/
echo "====================="
echo "begin install........"
#net_install http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
start_time=$(date +%s)
iso_install http://mirror.ctan.org/systems/texlive/Images/texlive.iso
echo "====================="
end_time=$(date +%s)
cost_time=$((end_time-start_time))
echo "installed use $((cost_time/60))min $((cost_time%60))s"

# Add /usr/local/texlive/2019/texmf-dist/doc/man to MANPATH.
# Add /usr/local/texlive/2019/texmf-dist/doc/info to INFOPATH.
# Most importantly, add /usr/local/texlive/2019/bin/x86_64-linux
# to your PATH for current and future sessions.
# Logfile: /usr/local/texlive/2019/install-tl.log

export PATH=$(grep TEXDIR install_texlive.profile|gawk '{printf $2}'|cygpath.exe -u -f -)/bin/win32/:$PATH
cd $APPVEYOR_BUILD_FOLDER/tex/
cp *.ttf $WINDIR/Fonts/
cp *.ttf "$(grep TEXDIR $APPVEYOR_BUILD_FOLDER/install_texlive.profile|gawk '{printf $2}')\texmf-dist\fonts\truetype\public\unfonts-extra"

# mkfontscale
# mkfontdir
fc-cache -fv
fc-list :lang=zh-cn 

xelatex fy.tex
cp fy.pdf $APPVEYOR_BUILD_FOLDER/$APPVEYOR_JOB_ID/

#cat cv-zh.tex
#cd $APPVEYOR_BUILD_FOLDER/cv
#xelatex cv-zh.tex


#cp cv-zh.pdf $APPVEYOR_BUILD_FOLDER/$APPVEYOR_JOB_ID/
#sleep 1

#sudo mock -r xxxx-v5.05-x86_64 --rebuild kernel-3.10.0-957.1.3.el7.xxxx.gd2389d1.src.rpm --no-clean --no-cleanup-after

