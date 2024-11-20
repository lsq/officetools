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
makepkg -sfL
'@  | Out-File -FilePath  ci-build.sh -Encoding utf8NoBOM
$cygPath = $(cygpath -u $PSScriptRoot)
C:\msys64\usr\bin\bash -lc "./ci-build.sh $cygPath"
