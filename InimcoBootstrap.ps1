#Requires -RunAsAdministrator
# PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File .\InimcoBoostrap.ps1

# --- Features --- #
Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart -Online
Enable-WindowsOptionalFeature -FeatureName VirtualMachinePlatform -All -NoRestart -Online

# --- System Tweaks --- #
New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent -Force | New-ItemProperty -Name DisableWindowsConsumerFeatures -PropertyType DWORD -Value 1 -Force
New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore -Force | New-ItemProperty -Name AutoDownload -PropertyType DWORD -Value 2 -Force
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -PropertyType DWORD -Value 0 -Force
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -PropertyType DWORD -Value 1 -Force
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState -Name FullPath -PropertyType DWORD -Value 0 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\System -Name VerboseStatus -PropertyType DWORD -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1 -Force

# --- Remove Bloatware --- #
Get-AppxPackage *3d* | Remove-AppxPackage # 3D Builder + View
Get-AppxPackage *connectivitystore* | Remove-AppxPackage # Microsoft Wi-Fi
Get-AppxPackage *feedback* | Remove-AppxPackage # Feedback Hub
Get-AppxPackage *getstarted* | Remove-AppxPackage # Get Started and Tips
Get-AppxPackage *holographic* | Remove-AppxPackage # Windows Holographic
Get-AppxPackage *skypeapp* | Remove-AppxPackage # Skype
Get-AppxPackage *officehub* | Remove-AppxPackage # Get Office
Get-AppxPackage *oneconnect* | Remove-AppxPackage # Paid Wi-Fi + Cellular
Get-AppxPackage *skypeapp* | Remove-AppxPackage # Get Skype
Get-AppxPackage *sway* | Remove-AppxPackage # Sway

# --- Install WinGet --- #
Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/download/v1.0.11692/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -OutFile $env:HomePath\winget.appxbundle
Add-AppxPackage -Path $env:HomePath\winget.appxbundle
Remove-Item $env:HomePath\winget.appxbundle

# --- WinGet Preferences --- #
Write-Output "{`n`t`"`$schema`":`"https://aka.ms/winget-settings.schema.json`",`n`t`"source`":{`n`t`t`"autoUpdateIntervalInMinutes`":60`n`t},`n`t`"installBehavior`":{`n`t`t`"preferences`":{`n`t`t`t`"scope`":`"machine`",`n`t`t`t`"locale`":[`n`t`t`t`t`"en-US`"`n`t`t`t]`n`t`t}`n`t}`n}" | Set-Content $env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json

# --- Runtime --- #
winget install Docker.DockerDesktop
winget install Git.Git
winget install Microsoft.GitCredentialManagerCore
winget install Microsoft.VC++2015-2019Redist-x64
winget install Microsoft.dotnet
winget install Microsoft.dotnet -v "3.1.410.15736"
winget install Microsoft.OpenJDK.16
winget install OpenJS.NodeJS
winget install Python.Python
winget install Yarn.Yarn

# --- Development --- #
winget install Microsoft.AzureDataStudio
winget install Microsoft.azure-iot-explorer
winget install Microsoft.Bicep
winget install Microsoft.AzureStorageExplorer
winget install Microsoft.Office
winget install Microsoft.AzureCLI
winget install Microsoft.AzureStorageEmulator
winget install Microsoft.SQLServerManagementStudio
winget install Microsoft.Teams
winget install Microsoft.VisualStudioCode
winget install Microsoft.VisualStudio.Enterprise

# --- Other --- #
winget install Adobe.AdobeAcrobatReaderDC
#winget install Google.Chrome
#winget install Microsoft.Edge
winget install Mozilla.FirefoxDeveloperEdition

# --- Optional --- #
winget install mRemoteNG.mRemoteNG
winget install RicoSuter.NSwagStudio
winget install TeamViewer.TeamViewer
winget install 7zip.7zip
winget install Microsoft.WindowsTerminal
winget install Microsoft.PowerToys
winget install Postman
winget install Debian.Debian
winget install Atlassian.Sourcetree
winget install Microsoft.PowerBI

# Configure Apps
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
code --install-extension vsciot-vscode.azure-iot-tools
code --install-extension ms-dotnettools.csharp
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-vscode-remote.remote-wsl
code --install-extension ms-vscode.vscode-node-azure-pack
code --install-extension firefox-devtools.vscode-firefox-debug
code --install-extension msjsdiag.debugger-for-edge
code --install-extension msjsdiag.debugger-for-chrome
pip install --upgrade pip
pip install --upgrade iotedgehubdev

Write-Output "Please restart your system."
PAUSE
EXIT 0