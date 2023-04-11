#Requires -RunAsAdministrator
#PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File .\InimcoBootstrap.ps1


# --- Functions --- #
function Set-Registry {

    PARAM (
        [string]$Path,
        [string]$Name,
        $Value
    )

    IF(!(Test-Path $Path)) 
    {
        New-Item -Path $Path -Force | New-ItemProperty -Name $Name -Value $Value -Force
    }
    ELSE 
    {
        New-ItemProperty -Path $Path -Name $Name -Value $Value -Force
    }
}

# --- Prep --- #
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# --- Features --- #
[array]$WhitelistFeatures = @("Microsoft-Windows-Subsystem-Linux", "VirtualMachinePlatform")
$WhitelistFeatures | Foreach-Object { Enable-WindowsOptionalFeature -FeatureName $_ -NoRestart -Online}

# --- System Tweaks --- #
Set-Registry -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent -Force | New-ItemProperty -Name DisableWindowsConsumerFeatures -PropertyType DWORD -Value 1
Set-Registry -Path HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore -Force | New-ItemProperty -Name AutoDownload -PropertyType DWORD -Value 2
Set-Registry -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -PropertyType DWORD -Value 0
Set-Registry -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -PropertyType DWORD -Value 1
Set-Registry -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState -Name FullPath -PropertyType DWORD -Value 0
Set-Registry -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\System -Name VerboseStatus -PropertyType DWORD -Value 1
Set-Registry -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1

# --- Install WinGet --- #
Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-cli/releases/latest" | Select-Object -ExpandProperty assets | Where-Object { $_.browser_download_url -Match ".msixbundle"} | Select-Object -ExpandProperty browser_download_url -First 1 -PipelineVariable $_ | Foreach {Add-AppxPackage -Path $_}
Write-Output "{`n`t`"`$schema`":`"https://aka.ms/winget-settings.schema.json`",`n`t`"source`":{`n`t`t`"autoUpdateIntervalInMinutes`":60`n`t},`n`t`"installBehavior`":{`n`t`t`"preferences`":{`n`t`t`t`"scope`":`"machine`",`n`t`t`t`"locale`":[`n`t`t`t`t`"en-US`"`n`t`t`t]`n`t`t}`n`t}`n}" | Set-Content $env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json

# --- WinGet Preferences --- #
WinGet Source Remove msstore
WinGet Source Update

[array]$Programs = @(
    # --- Runtime -- #
    "Microsoft.DotNet.SDK.7",
    "Microsoft.DotNet.SDK.3_1",   
    "Microsoft.Git",
    "Microsoft.OpenJDK.17",
    "Microsoft.VCRedist.2015+.x64",
    "Python.Python.3.11",

    # --- General --- #
    "Adobe.Acrobat.Reader.64-bit",
    "Microsoft.Office",
    "Microsoft.Teams",
    "Mozilla.Firefox.DeveloperEdition",
    "Mozilla.Firefox",

    # --- Development --- #
    "Docker.DockerDesktop",
    "Microsoft.AzureCLI",
    "Microsoft.AzureDataStudio",
    "Microsoft.Azure.IoTExplorer",
    "Microsoft.Azure.StorageEmulator"
    "Microsoft.Azure.StorageExplorer",
    "Microsoft.Bicep",
    "Microsoft.SQLServerManagementStudio",
    "Microsoft.VisualStudioCode",
    "Microsoft.VisualStudio.2022.Enterprise",
    "OpenJS.NodeJS",
    "Yarn.Yarn",

    # --- Tools --- #
    "7zip.7zip",
    "Fork.Fork",
    "Microsoft.PowerBI",
    "Microsoft.PowerToys",
    "mRemoteNG.mRemoteNG",
    "Notepad++.Notepad++",
    "Postman.Postman"
)
$Programs | Foreach-Object { WinGet Install $_ --Force}

# --- Misc --- #
Write-Output "[wsl2]`nmemory=4GB" | Set-Content $env:USERPROFILE\.wslconfig

# --- Cleanup --- #
DISM /Online /Cleanup-Image /StartComponentCleanup

Write-Output "Please restart your system."
PAUSE
EXIT 0
