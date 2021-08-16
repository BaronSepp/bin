REM Initialise
@ECHO OFF
TITLE Sepp's Base0 Installer v0.4
COLOR 1F
CLS

REM Verify Administrative permissions
ECHO Administrative permissions required. Detecting permissions...
net session >nul 2>&1
IF %errorLevel% == 0 (
	REM Success
	ECHO Success: Administrative permissions confirmed.
	ECHO.
) ELSE (
	REM Failure
	ECHO Failure: Current permissions inadequate.
	PAUSE >NUL
	EXIT
)

REM Remove Windows10 Bloat
ECHO Removing Bloatware..
@ECHO ON
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *3d* | Remove-AppxPackage" & ECHO - 3D Builder + View
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *appconnector* | Remove-AppxPackage" & ECHO - App Connector
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *bing* | Remove-AppxPackage" & ECHO - Money, News, Sports and Weather
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *communicationsapps* | Remove-AppxPackage" & ECHO - Calendar and Mail
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *connectivitystore* | Remove-AppxPackage" & ECHO - Microsoft Wi-Fi
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *feedback* | Remove-AppxPackage" & ECHO - Feedback Hub
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *getstarted* | Remove-AppxPackage" & ECHO - Get Started and Tips
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *holographic* | Remove-AppxPackage" & ECHO - Windows Holographic
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *messaging* | Remove-AppxPackage" & ECHO - Messaging and Skype Video
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *mspaint* | Remove-AppxPackage" & ECHO - Paint 3D
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *officehub* | Remove-AppxPackage" & ECHO - Get Office
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *oneconnect* | Remove-AppxPackage" & ECHO - Paid Wi-Fi + Cellular
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *onenote* | Remove-AppxPackage" & ECHO - OneNote
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *Microsoft.People* | Remove-AppxPackage" & ECHO - People
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *phone* | Remove-AppxPackage" & ECHO - Phone and Phone Companion
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *solitaire* | Remove-AppxPackage" & ECHO - Microsoft Solitaire Collection
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *soundrecorder* | Remove-AppxPackage" & ECHO - Voice Recorder
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *skypeapp* | Remove-AppxPackage" & ECHO - Get Skype
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *sticky* | Remove-AppxPackage" & ECHO - Sticky Notes
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *sway* | Remove-AppxPackage" & ECHO - Sway
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *windowsstore* | Remove-AppxPackage" & ECHO - Windows Store
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Get-AppxPackage *zune* | Remove-AppxPackage" & ECHO - Movies + TV and Groove Music
@ECHO OFF
ECHO.

REM Registry Tweaks
ECHO Tweaking Registry..
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f
reg add HKLM\SOFTWARE\Policies\Microsoft\WindowsStore /v AutoDownload /t REG_DWORD /d 2 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Hidden /t REG_DWORD /d 1 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState /v FullPath /t REG_DWORD /d 0 /f
reg add HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\System /v VerboseStatus /t REG_DWORD /d 1 /f
reg add HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6} /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_ShowRecentDocs /t REG_DWORD /d 0 /f
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People /v PeopleBand /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People\ShoulderTap /v ShoulderTap /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People\ShoulderTap /v ShoulderTapAudio /t REG_DWORD /d 0 /f
ECHO.

REM Disable Unused Features
ECHO Updating Windows Features..
dism /online /disable-feature /featurename:WorkFolders-Client /norestart 
dism /online /disable-feature /featurename:TIFFIFilter /norestart
dism /online /disable-feature /featurename:Printing-XPSServices-Features /norestart
dism /online /disable-feature /featurename:WindowsMediaPlayer /norestart
dism /online /disable-feature /featurename:Internet-Explorer-Optional-amd64 /norestart
ECHO.

REM Install WinGet..
ECHO Installing WinGet..
curl -L -o %HomePath%\winget.appxbundle https://github.com/microsoft/winget-cli/releases/download/v-0.2.10191-preview/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command "Add-AppxPackage -Path %HomePath%\winget.appxbundle"
DEL  %HomePath%\winget.appxbundle
ECHO.

REM Install Software..
ECHO Installing Software..
winget install Oracle.JavaRuntimeEnvironment"
winget install Microsoft.VC++2015-2019Redist-x64"
winget install Discord.DiscordDevelopment"
winget install Mozilla.Firefox"
winget install Notepad++.Notepad++"
winget install Microsoft.PowerToys"
winget install ShareX.ShareX"
winget install WinDirStat.WinDirStat"
winget install 7zip.7zip"
winget install Plex.Plex"
winget install clsid2.mpc-hc"
winget install IrfanSkiljan.IrfanView"
winget install Spotify.Spotify"
winget install Valve.Steam"
winget install Ubisoft.Connect"
winget install ElectronicArts.Origin"
winget install Blizzard.BattleNet"
ECHO.

REM Cleanup
dism /online /Cleanup-Image /StartComponentCleanup

REM Reboot System
ECHO Windows needs to restart to finish installation.
PAUSE
shutdown /r /f /c "System reboot required to complete Base0 installation."
CLS
EXIT