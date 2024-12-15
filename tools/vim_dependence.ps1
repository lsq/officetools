Import-Module $PSScriptRoot\utils.psm1

#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
#. $PSScriptRoot\install-scoop.ps1

. $PSScriptRoot\install-scoop.ps1
$env:scoop = "$env:USERPROFILE\scoop"
$racketInfo = (scoop search racket-bc)
$racketVer = $racketInfo.Version
$racketName = $racketInfo.Name
$rkBucket = $racketInfo.Source
#$racketDownUrl = ((Get-Content -Raw $env:scoop\buckets\$rkBucket\bucket\$racketName.json) | ConvertFrom-Json).architecture."64bit".url -replace '#/dl.7z'
#$racketDownUrl = "https://users.cs.utah.edu/plt/installers/$racketVer/racket-$racketVer-x86_64-win32-bc.exe"
#iwr $racketDownUrl -OutFile $env:scoop\cache\$racketName-$racketVer.exe
#if (Test-Path $(scoop prefix racket-bc)) {scoop uninstall racket-bc}
    (scoop list) | ForEach-Object { if ($_.name -match "racket-bc") {scoop uninstall racket-bc}}
    scoop install racket-bc
    cp $env:scoop\apps\$racketName\current\lib\libracket*.dll C:\Windows\System32\

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
if ($rubyhome -eq $null) {
    $rubyhome="c:\Ruby-on-Windows"
}
(iwr https://www.ruby-lang.org/en/downloads).Content -match "The current stable version is (?<version>[\d.]+)\."
$rubyversion = $Matches['version']
Write-Host $rubyversion
$rver = ($rubyversion -split "\.")[0..1] -join ''

#$rubyversion = [System.iO.Path]::GetFileName($rubyhome)
$rubyroot = [system.iO.Path]::GetDirectoryName($rubyhome)
    <#
    function Compare-Version {
        Param (
                [string]$version1,
                [string]$version2
              )

            $v1 = $version1 -split '\.'
            $v2 = $version2 -split '\.'

            for ($i = 0; $i -lt [Math]::Max($v1.Length, $v2.Length); $i++) {
                $part1 = if ($i -lt $v1.Length) { $v1[$i] } else { 0 }
                $part2 = if ($i -lt $v2.Length) { $v2[$i] } else { 0 }

                $compareResult = $part1 -as [int] -compare $part2 -as [int]

                    if ($compareResult -ne 0) {
                        return $compareResult
                    }
            }

        return 0
    }
#>
$dlOrNot = $false
if (Test-Path $rubyhome\bin\ruby.exe) {
    $(ruby -v) -match " (?<inVer>[\d.]+) "
        $inVer =  $Matches['inVer']
        Write-Host "exist ver:$inVer"

        if ([System.Version]$rubyversion -gt [System.Version]$inVer) {
            $dlOrNot = $true
        }
}
else { $dlOrNot = $true}
if ($dlOrNot -eq $true) {
    Write-Host "Now starting download $rubyversion"
#iwr https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-$rubyversion-1/rubyinstaller-$rubyversion-1-x64.7z -OutFile rubyinstaller-$rubyversion-1-x64.7z
    aria2Download "https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-$rubyversion-1/rubyinstaller-$rubyversion-1-x64.7z" "./" "rubyinstaller-$rubyversion-1-x64.7z"
        Start-Process 7z.exe -ArgumentList "x", ".\rubyinstaller-$rubyversion-1-x64.7z", "-o$rubyroot" -Wait
#7z x .\rubyinstaller-$rubyversion-x64.7z  -o$rubyroot
        if (Test-Path $rubyhome) {
            rm $rubyhome -Recurse -Force
        }
    mv $rubyroot\rubyinstaller-$rubyversion-1-x64 $rubyhome
}

pwd
if ($env:GITHUB_ACTIONS -eq $null) {
    $build_folder=$env:APPVEYOR_BUILD_FOLDER
}
else {
    $build_folder=$env:GITHUB_WORKSPACE
    Write-Host $env:GITHUB_PATH
    Write-Host $(cat $env:GITHUB_PATH)
    echo "$env:USERPROFILE\scoop\shims;" >> $env:GITHUB_PATH
    echo "$rubyhome\bin;$rubyhome\gems\bin;" >> $env:GITHUB_PATH
    Write-Host $(cat $env:GITHUB_PATH)
    echo "rubyhome=$rubyhome" >> $env:GITHUB_ENV
}
echo $build_folder
sed.exe -r -i "s/(ci.ri2::ruby).*(:.*)/\\1$rver\\2/" $build_folder\tools\vim-build.sh

#$env:USER_PATH=[Environment]::GetEnvironmentVariable("PATH", "User") 
$env:USER_PATH=[Environment]::GetEnvironmentVariable("PATH", "Machine") 
#// ↓勿直接使用$env:PATH，会触发问题2，用临时变量$env:USER_PATH来过渡一
$env:USER_PATH=$env:USER_PATH -replace "c:\\Ruby32\\bin;", "$rubyhome\bin;" 
$env:USER_PATH=$env:USER_PATH -replace "c:\\mingw64\\bin;", "c:\\ucrt64\\bin;"
#// 先在console中临时替
$env:USER_PATH="$rubyhome\bin;$rubyhome\gems\bin;" + $env:USER_PATH
echo $env:USER_PATH
#Write-Env 'PATH' "$env:USER_PATH" 
#[Environment]::SetEnvironmentVariable("PATH", $env:USER_PATH, 'Machine')  #   // 使临时替换永久生
#(删除PATH中的某一个路径替换为""即可)
$userEnvP = Get-Env 'PATH'
echo $userEnvP
$env:PATH = "$rubyhome\bin;$rubyhome\gems\bin;$env:PATH"
echo $env:PATH
Write-Env 'PATH' "$env:USER_PATH" -global
echo $env:PATH
which ruby
gem install rake
    <#
$rackethome=$(scoop prefix racket-bc)
    $mzschemeVersion = (Get-Item $rackethome\lib\librack*.dll).Name -replace "libracket" -replace ".dll"
    sed.exe -i "s/(ci.ri2::ruby).*/\\1$rver/" $env:APPVEYOR_BUILD_FOLDER\tools\vim-build.sh
#>
