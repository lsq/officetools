function aria2Download {
    param(
            [String] $url,
            [String] $dir,
            [String] $out
         )

        aria2c -d $dir -o $out "--user-agent=Scoop/1.0 (+http://scoop.sh/) PowerShell/7.5 (Windows NT 10.0; Win64; x64; Core)" --allow-overwrite=true --auto-file-renaming=false --retry-wait=4 --split=16 --max-connection-per-server=16 --min-split-size=4M --console-log-level=warn --enable-color=false --no-conf=true --follow-metalink=true --metalink-preferred-protocol=https  --continue --summary-interval=0 --auto-save-interval=1 --min-tls-version=TLSv1.2 $url
}

function Get-Env {
    param(
            [String] $name,
            [Switch] $global
         )

        $RegisterKey = if ($global) {
            Get-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager'
        } else {
            Get-Item -Path 'HKCU:'
        }

    $EnvRegisterKey = $RegisterKey.OpenSubKey('Environment')
        $RegistryValueOption = [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames
        $EnvRegisterKey.GetValue($name, $null, $RegistryValueOption)
}

function Publish-Env {
    if (-not ('Win32.NativeMethods' -as [Type])) {
        Add-Type -Namespace Win32 -Name NativeMethods -MemberDefinition @'
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
public static extern IntPtr SendMessageTimeout(
    IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam,
    uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
'@
    }

    $HWND_BROADCAST = [IntPtr] 0xffff
    $WM_SETTINGCHANGE = 0x1a
    $result = [UIntPtr]::Zero

    [Win32.Nativemethods]::SendMessageTimeout($HWND_BROADCAST,
            $WM_SETTINGCHANGE,
            [UIntPtr]::Zero,
            'Environment',
            2,
            5000,
            [ref] $result
            ) | Out-Null
}

function Write-Env {
    param(
            [String] $name,
            [String] $val,
            [Switch] $global
         )

        $RegisterKey = if ($global) {
            Get-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager'
        } else {
            Get-Item -Path 'HKCU:'
        }

    $EnvRegisterKey = $RegisterKey.OpenSubKey('Environment', $true)
        if ($val -eq $null) {
            $EnvRegisterKey.DeleteValue($name)
        } else {
            $RegistryValueKind = if ($val.Contains('%')) {
                [Microsoft.Win32.RegistryValueKind]::ExpandString
            } elseif ($EnvRegisterKey.GetValue($name)) {
                $EnvRegisterKey.GetValueKind($name)
            } else {
                [Microsoft.Win32.RegistryValueKind]::String
            }
            $EnvRegisterKey.SetValue($name, $val, $RegistryValueKind)
        }
    Publish-Env
}
function downGit($repo, $folder){
	$json = irm https://api.github.com/repos/$repo/contents/$($folder)?ref=master
		$json | ForEach-Object {
			echo $_.path
			iwr -useb $($_).download_url | ni $_.path -Force
		}
}