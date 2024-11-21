Import-Module $PSScriptRoot\utils.psm1

$currentDirectory = (Get-Location).Path
Write-Host "Current directory: $currentDirectory"

downGit msys2/MSYS2-packages msys2-runtime
cd msys2-runtime

$env:CHERE_INVOKING = 'yes'  # Preserve the current working directory
$env:MSYSTEM = 'msys'  # Start a 64 bit Mingw environment
@'
basedir="$1"
cd "$basedir" || exit 1
pwd
ls
cat > patch_pkgbuild.sed <<'EOF'
3s/^$/_realname=runtime/
4s/=.*/=mingw-w64-${_realname}/
5s/=.*/=(${MINGW_PACKAGE_PREFIX}-${_realname})/
9s/x86_64.*/any')\n#mingw_arch=('mingw64' 'ucrt64' 'clang64' 'clangarm64')\nmingw_arch=('ucrt64')/
18s/'perl'/${MINGW_PACKAGE_PREFIX}-perl/
19s/'gcc'/${MINGW_PACKAGE_PREFIX}-gcc/
23s/'zlib-devel'/${MINGW_PACKAGE_PREFIX}-zlib/
24s/'gettext-devel'/${MINGW_PACKAGE_PREFIX}-gettext-runtime/
25s/.*//
28s/'docbook-xsl'/${MINGW_PACKAGE_PREFIX}-docbook-xsl/
s/${CHOST}/${MINGW_CHOST}/g
224s/\/usr/${MINGW_PREFIX}/
225s/\(.*\)/\1\n--host=${MINGW_CHOST} \\/
226s/\etc/${MINGW_PREFIX}\/etc/
231s/\etc/${MINGW_PREFIX}\/etc/
235,237s/usr\//${MINGW_PREFIX}\//g
240s/_msys2-runtime//
242,243s/'msys2-runtime-\([^']*\)'/${MINGW_PACKAGE_PREFIX}-runtime-\1/g
245,253s/\/usr/\/${MINGW_PREFIX}/g
254,262d
264,272s/\/usr/\/${MINGW_PREFIX}/g
EOF
sed -i -f patch_pkgbuild.sed PKGBUILD
#./update-patches.sh
makepkg -sfL --noconfirm --skipchecksums
#makepkg -sfL --noconfirm 
'@  | Out-File -FilePath  ci-build.sh -Encoding utf8NoBOM
$cygPath = $(cygpath -u $(pwd))
C:\msys64\usr\bin\bash -lc "./ci-build.sh $cygPath"
