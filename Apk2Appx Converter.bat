cls
@echo off
setlocal enabledelayedexpansion

if NOT exist "%CD%\Settings.dat" (
    echo>"%CD%\Settings.dat" [settings]
    echo>>"%CD%\Settings.dat" RunAsAdmin = 0
    echo>>"%CD%\Settings.dat" CleanTempFolder = 1
    echo>>"%CD%\Settings.dat" DebugMode = 0
)

for /f "tokens=3 delims= " %%a in ('findstr.exe /ri "RunAsAdmin" "%CD%\Settings.dat"') do if "1" NEQ "%%a" goto Setup
if "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) else (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UserAccountControl
) else (
    goto GotAdministrator
)

:UserAccountControl
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params= %*
echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

:GotAdministrator
pushd "%CD%"
CD /D "%~dp0"

:Setup
for /f "tokens=3 delims= " %%a in ('findstr.exe /ri "CleanTempFolder" "%CD%\Settings.dat"') do (
    if "0" NEQ "%%a" (
        set "Clean=1"
    ) else (
        set "Clean=0"
    )
)
for /f "tokens=3 delims= " %%a in ('findstr.exe /ri "DebugMode" "%CD%\Settings.dat"') do (
    if "1" NEQ "%%a" (
        set "Verbose=>nul 2>&1"
    )
)

title Apk2Appx Converter for ProjectA
if NOT exist "%CD%\Output" md "%CD%\Output"

:Start
cls
chcp 65001 >nul
echo        [92m█████[0m╗ [92m██████[0m╗ [92m██[0m╗  [92m██[0m╗[31m██████[0m╗  [94m█████[0m╗ [94m██████[0m╗ [94m██████[0m╗ [94m██[0m╗  [94m██[0m╗
echo       [92m██[0m╔══[92m██[0m╗[92m██[0m╔══[92m██[0m╗[92m██[0m║ [92m██[0m╔╝╚════[31m██[0m╗[94m██[0m╔══[94m██[0m╗[94m██[0m╔══[94m██[0m╗[94m██[0m╔══[94m██[0m╗╚[94m██[0m╗[94m██[0m╔╝
echo       [92m███████[0m║[92m██████[0m╔╝[92m█████[0m╔╝  [31m█████[0m╔╝[94m███████[0m║[94m██████[0m╔╝[94m██████[0m╔╝ ╚[94m███[0m╔╝ 
echo       [92m██╔══██[0m║[92m██[0m╔═══╝ [92m██[0m╔═[92m██[0m╗ [31m██[0m╔═══╝ [94m██[0m╔══[94m██[0m║[94m██[0m╔═══╝ [94m██[0m╔═══╝  [94m██[0m╔[94m██[0m╗ 
echo       [92m██[0m║  [92m██[0m║[92m██[0m║     [92m██[0m║  [92m██[0m╗[31m███████[0m╗[94m██[0m║  [94m██[0m║[94m██[0m║     [94m██[0m║     [94m██[0m╔╝ [94m██[0m╗
echo       ╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝     ╚═╝  ╚═╝
echo  [35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m╗ [35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m╗ [35m█[0m[35m█[0m[35m█[0m╗   [35m█[0m[35m█[0m╗[35m█[0m[35m█[0m╗   [35m█[0m[35m█[0m╗[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m╗[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m╗ [35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m╗[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m╗[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m╗ 
echo [35m█[0m[35m█[0m╔════╝[35m█[0m[35m█[0m╔═══[35m█[0m[35m█[0m╗[35m█[0m[35m█[0m[35m█[0m[35m█[0m╗  [35m█[0m[35m█[0m║[35m█[0m[35m█[0m║   [35m█[0m[35m█[0m║[35m█[0m[35m█[0m╔════╝[35m█[0m[35m█[0m╔══[35m█[0m[35m█[0m╗╚══[35m█[0m[35m█[0m╔══╝[35m█[0m[35m█[0m╔════╝[35m█[0m[35m█[0m╔══[35m█[0m[35m█[0m╗
echo [35m█[0m[35m█[0m║     [35m█[0m[35m█[0m║   [35m█[0m[35m█[0m║[35m█[0m[35m█[0m╔[35m█[0m[35m█[0m╗ [35m█[0m[35m█[0m║[35m█[0m[35m█[0m║   [35m█[0m[35m█[0m║[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m╗  [35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m╔╝   [35m█[0m[35m█[0m║   [35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m╗  [35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m╔╝
echo [35m█[0m[35m█[0m║     [35m█[0m[35m█[0m║   [35m█[0m[35m█[0m║[35m█[0m[35m█[0m║╚[35m█[0m[35m█[0m╗[35m█[0m[35m█[0m║╚[35m█[0m[35m█[0m╗ [35m█[0m[35m█[0m╔╝[35m█[0m[35m█[0m╔══╝  [35m█[0m[35m█[0m╔══[35m█[0m[35m█[0m╗   [35m█[0m[35m█[0m║   [35m█[0m[35m█[0m╔══╝  [35m█[0m[35m█[0m╔══[35m█[0m[35m█[0m╗
echo ╚[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m╗╚[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m╔╝[35m█[0m[35m█[0m║ ╚[35m█[0m[35m█[0m[35m█[0m[35m█[0m║ ╚[35m█[0m[35m█[0m[35m█[0m[35m█[0m╔╝ [35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m╗[35m█[0m[35m█[0m║  [35m█[0m[35m█[0m║   [35m█[0m[35m█[0m║   [35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m[35m█[0m╗[35m█[0m[35m█[0m║  [35m█[0m[35m█[0m║
echo  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
echo [33mVersion 2.4.3.0
echo Copyright (c) 2024 by @fadilfadz01 ^& @Empyreal96
echo https://github.com/fadilfadz01/Apk2Appx_Converter
echo.[0m
set /p "APK=[96mInput APK file:[0m "
if NOT defined APK (
    set "Error=1"
    goto Errors
)
set "APK=%APK:"=%"
if "%APK%" NEQ "%APK:~0,-4%.apk" if "%APK%" NEQ "%APK:~0,-4%.APK" if "%APK%" NEQ "%APK:~0,-4%.Apk" (
    set "Error=1"
    goto Errors
)
if NOT exist "%APK%" (
    set "Error=2"
    goto Errors
)
for %%a in ("%APK%") do set "APKLabel=%%~na"

:Reading_APK
echo.
echo [32mReading APK...[0m
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt.exe" d badging "%APK%" ^| findstr.exe /rim "sdkVersion:'"') do (
    set "MinAPI=%%a"
    goto 1
)

:1
if %MinAPI% gtr 19 (
    set "Error=3"
    goto Errors
)
::for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt.exe" d badging "%APK%"') do set "Package=%%a"&goto ReadingPart1
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt.exe" d badging "%APK%" ^| findstr.exe /rim "package: "') do set "Package=%%a"
::ReadingPart1
set PackageName=%Package:_=%
set PackageName=%PackageName:-=%
::for /f "tokens=4 delims='" %%a in ('call "%CD%\Agent\Tools\aapt.exe" d badging "%APK%"') do set "Version=%%a"&goto ReadingPart2
for /f "tokens=4 delims='" %%a in ('call "%CD%\Agent\Tools\aapt.exe" d badging "%APK%" ^| findstr.exe /rim " versionCode='"') do set "Version=%%a"
::ReadingPart2
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt.exe" d badging "%APK%" ^| findstr.exe /rim " Label='"') do (
    set "PackageLabel=%%a"
    goto 2
)

:2
set "PackageLabel=%PackageLabel:&=&amp;%"
if exist "%CD%\Temp" (
    rd /q /s "%CD%\Temp"
    md "%CD%\Temp\AppxProject\Assets"
) else (
    md "%CD%\Temp\AppxProject\Assets"
)

for /f "skip=1 tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt.exe" d permissions "%APK%"') do echo %%a>>"%CD%\Temp\Permissions.txt"

::for /f "tokens=4 delims='" %%a in ('call "%CD%\Agent\Tools\aapt.exe" d badging "%APK%" ^| findstr.exe /rim " icon='res/"') do set "Icon=%%a"
::"%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" %Icon%

for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt.exe" d badging "%APK%" ^| findstr.exe /rim "application-icon-120:"') do set "Icon=%%a"
if defined Icon "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" %Icon% -y %Verbose%
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt.exe" d badging "%APK%" ^| findstr.exe /rim "application-icon-160:"') do set "Icon=%%a"
if defined Icon "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" %Icon% -y %Verbose%
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt.exe" d badging "%APK%" ^| findstr.exe /rim "application-icon-213:"') do set "Icon=%%a"
if defined Icon "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" %Icon% -y %Verbose%
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt.exe" d badging "%APK%" ^| findstr.exe /rim "application-icon-240:"') do set "Icon=%%a"
if defined Icon "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" %Icon% -y %Verbose%
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt.exe" d badging "%APK%" ^| findstr.exe /rim "application-icon-320:"') do set "Icon=%%a"
if defined Icon "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" %Icon% -y %Verbose%
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt.exe" d badging "%APK%" ^| findstr.exe /rim "application-icon-480:"') do set "Icon=%%a"
if defined Icon "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" %Icon% -y %Verbose%
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt.exe" d badging "%APK%" ^| findstr.exe /rim "application-icon-640:"') do set "Icon=%%a"
if defined Icon "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" %Icon% -y %Verbose%
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt.exe" d badging "%APK%" ^| findstr.exe /rim "application-icon-65535:"') do set "Icon=%%a"
if defined Icon "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" %Icon% -y %Verbose%

for %%a in ("%CD%\Temp\*.png") do Set "IconLabel=%%~nxa"
if NOT defined IconLabel for %%a in ("%CD%\Temp\*.xml") do (
    set IconLabel=%%~na.png
    "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" res/mipmap-anydpi/!IconLabel! -y %Verbose%
    "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" res/mipmap-anydpi-v26/!IconLabel! -y %Verbose%
    "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" res/mipmap-hdpi/!IconLabel! -y %Verbose%
    "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" res/mipmap-hdpi-v4/!IconLabel! -y %Verbose%
    "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" res/mipmap-mdpi/!IconLabel! -y %Verbose%
    "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" res/mipmap-mdpi-v4/!IconLabel! -y %Verbose%
    "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" res/mipmap-xhdpi/!IconLabel! -y %Verbose%
    "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" res/mipmap-xhdpi-v4/!IconLabel! -y %Verbose%
    "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" res/mipmap-xxhdpi/!IconLabel! -y %Verbose%
    "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" res/mipmap-xxhdpi-v4/!IconLabel! -y %Verbose%
    "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" res/mipmap-xxxhdpi/!IconLabel! -y %Verbose%
    "%CD%\Agent\Tools\7za.exe" e "%APK%" -o"%CD%\Temp" res/mipmap-xxxhdpi-v4/!IconLabel! -y %Verbose%
)

::if NOT exist "%CD%\Temp\%IconLabel%" set "Error=4"&goto Errors
if NOT exist "%CD%\Temp\%IconLabel%" copy "%CD%\Agent\Templates\Assets\Icon.png" "%CD%\Temp\%IconLabel%" %Verbose%
::if NOT defined IconLabel cls&echo %Intro%&pause >nul | set /p =[31mUnsupported APK file...[0m&goto Errors

:Generating_Assets
echo.
echo [32mGenerating assets...[0m
::copy "%CD%\Temp\%IconLabel%" "%CD%\Temp\AppxProject\Assets\AppLogo.scale-100.png"
::"%CD%\Agent\Tools\magick.exe" mogrify -resize 44x44  "%CD%\Temp\AppxProject\Assets\AppLogo.scale-100.png"
"%CD%\Agent\Tools\magick.exe" mogrify -resize 192x192  "%CD%\Temp\%IconLabel%" %Verbose%
"%CD%\Agent\Tools\magick.exe" convert "%CD%\Temp\%IconLabel%" -resize 44x44 "%CD%\Temp\AppxProject\Assets\AppLogo.scale-100.png" %Verbose%
"%CD%\Agent\Tools\magick.exe" convert "%CD%\Temp\%IconLabel%" -resize 62x62  "%CD%\Temp\AppxProject\Assets\AppLogo.scale-140.png" %Verbose%
"%CD%\Agent\Tools\magick.exe" convert "%CD%\Temp\%IconLabel%" -resize 106x106  "%CD%\Temp\AppxProject\Assets\AppLogo.scale-240.png" %Verbose%
::"%CD%\Agent\Tools\magick.exe" composite -blend 100 -gravity center -geometry +0-100 "%CD%\Temp\%IconLabel%" "%CD%\Agent\Templates\Assets\SplashScreen.scale-100.png" "%CD%\Temp\AppxProject\Assets\SplashScreen.scale-100.png"
::copy "%CD%\Temp\%IconLabel%" "%CD%\Temp\AppxProject\Assets\SplashScreen.scale-140.png"
::"%CD%\Agent\Tools\magick.exe" mogrify -resize 672x1120  "%CD%\Temp\AppxProject\Assets\SplashScreen.scale-140.png"
::"%CD%\Agent\Tools\magick.exe" composite -blend 100 -gravity center -geometry +0-100 "%CD%\Temp\%IconLabel%" "%CD%\Agent\Templates\Assets\SplashScreen.scale-140.png" "%CD%\Temp\AppxProject\Assets\SplashScreen.scale-140.png"
::"%CD%\Agent\Tools\magick.exe" convert "%CD%\Temp\%IconLabel%" -resize 40%% -background transparent -gravity center -geometry +0-100 -extent 480x800 "%CD%\Temp\AppxProject\Assets\SplashScreen.scale-100.png"
"%CD%\Agent\Tools\magick.exe" composite -blend 100 -gravity center -geometry +0-100 "%CD%\Temp\%IconLabel%" "%CD%\Agent\Templates\Assets\SplashScreen.scale-240.png" "%CD%\Temp\AppxProject\Assets\SplashScreen.scale-240.png" %Verbose%
"%CD%\Agent\Tools\magick.exe" convert "%CD%\Temp\AppxProject\Assets\SplashScreen.scale-240.png" -resize 480x800  "%CD%\Temp\AppxProject\Assets\SplashScreen.scale-100.png" %Verbose%
"%CD%\Agent\Tools\magick.exe" convert "%CD%\Temp\AppxProject\Assets\SplashScreen.scale-240.png" -resize 672x1120  "%CD%\Temp\AppxProject\Assets\SplashScreen.scale-140.png" %Verbose%
"%CD%\Agent\Tools\magick.exe" convert "%CD%\Temp\%IconLabel%" -resize 50x50  "%CD%\Temp\AppxProject\Assets\StoreLogo.scale-100.png" %Verbose%
"%CD%\Agent\Tools\magick.exe" convert "%CD%\Temp\%IconLabel%" -resize 70x70  "%CD%\Temp\AppxProject\Assets\StoreLogo.scale-140.png" %Verbose%
"%CD%\Agent\Tools\magick.exe" convert "%CD%\Temp\%IconLabel%" -resize 120x120  "%CD%\Temp\AppxProject\Assets\StoreLogo.scale-240.png" %Verbose%
"%CD%\Agent\Tools\magick.exe" convert "%CD%\Temp\%IconLabel%" -resize 150x150  "%CD%\Temp\AppxProject\Assets\TileLogoMedium.scale-100.png" %Verbose%
"%CD%\Agent\Tools\magick.exe" convert "%CD%\Temp\%IconLabel%" -resize 210x210  "%CD%\Temp\AppxProject\Assets\TileLogoMedium.scale-140.png" %Verbose%
"%CD%\Agent\Tools\magick.exe" convert "%CD%\Temp\%IconLabel%" -resize 360x360  "%CD%\Temp\AppxProject\Assets\TileLogoMedium.scale-240.png" %Verbose%
"%CD%\Agent\Tools\magick.exe" convert "%CD%\Temp\%IconLabel%" -resize 71x71  "%CD%\Temp\AppxProject\Assets\TileLogoSmall.scale-100.png" %Verbose%
"%CD%\Agent\Tools\magick.exe" convert "%CD%\Temp\%IconLabel%" -resize 99x99 "%CD%\Temp\AppxProject\Assets\TileLogoSmall.scale-140.png" %Verbose%
"%CD%\Agent\Tools\magick.exe" convert "%CD%\Temp\%IconLabel%" -resize 170x170  "%CD%\Temp\AppxProject\Assets\TileLogoSmall.scale-240.png" %Verbose%
"%CD%\Agent\Tools\magick.exe" convert "%CD%\Temp\%IconLabel%" -resize 70%% -background transparent -gravity center -extent 310x150 "%CD%\Temp\AppxProject\Assets\TileLogoWide.scale-100.png" %Verbose%
"%CD%\Agent\Tools\magick.exe" convert "%CD%\Temp\%IconLabel%" -resize 95%% -background transparent -gravity center -extent 434x210 "%CD%\Temp\AppxProject\Assets\TileLogoWide.scale-140.png" %Verbose%
"%CD%\Agent\Tools\magick.exe" convert "%CD%\Temp\%IconLabel%" -resize 165%% -background transparent -gravity center -extent 744x360 "%CD%\Temp\AppxProject\Assets\TileLogoWide.scale-240.png" %Verbose%

:Converting_Android_permissions_to_Windows_capabilities
echo. %Verbose%
echo [32mConverting Android permissions to Windows capabilities...[0m %Verbose%
findstr.exe /rix "android.permission.INTERNET" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 (
    set "Capabilities=%Capabilities%^<Capability Name=^"^"internetClient^"^"/^>^<Capability Name=^"^"internetClientServer^"^"/^>^<Capability Name=^"^"privateNetworkClientServer^"^"/^>"
    goto 3
)
findstr.exe /rix "android.permission.ACCESS_NETWORK_STATE" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 (
    set "Capabilities=%Capabilities%^<Capability Name=^"^"internetClient^"^"/^>"
    goto 3
)
findstr.exe /rix "android.permission.CHANGE_NETWORK_STATE" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 (
    set "Capabilities=%Capabilities%^<Capability Name=^"^"internetClient^"^"/^>"
    goto 3
)
findstr.exe /rix "android.permission.ACCESS_WIFI_STATE" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 (
    set "Capabilities=%Capabilities%^<Capability Name=^"^"internetClient^"^"/^>"
    goto 3
)
findstr.exe /rix "android.permission.CHANGE_WIFI_STATE" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 set "Capabilities=%Capabilities%^<Capability Name=^"^"internetClient^"^"/^>"

:3
findstr.exe /rix "android.permission.READ_EXTERNAL_STORAGE" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 (
    set "Capabilities=%Capabilities%^<uap:Capability Name=^"^"removableStorage^"^"/^>"
    goto 4
)
findstr.exe /rix "android.permission.WRITE_EXTERNAL_STORAGE" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 set "Capabilities=%Capabilities%^<uap:Capability Name=^"^"removableStorage^"^"/^>"

:4
findstr.exe /rix "android.permission.READ_CONTACTS" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 (
    set "Capabilities=%Capabilities%^<uap:Capability Name=^"^"contacts^"^"/^>"
    goto 5
)
findstr.exe /rix "android.permission.WRITE_CONTACTS" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 (
    set "Capabilities=%Capabilities%^<uap:Capability Name=^"^"contacts^"^"/^>"
    goto 5
)
findstr.exe /rix "android.permission.READ_SYNC_SETTINGS" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 (
    set "Capabilities=%Capabilities%^<uap:Capability Name=^"^"contacts^"^"/^>"
    goto 5
)
findstr.exe /rix "android.permission.WRITE_SYNC_SETTINGS" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 set "Capabilities=%Capabilities% ^<uap:Capability Name=^"^"contacts^"^"/^>"

:5
findstr.exe /rix "android.permission.READ_CALENDAR" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 (
    set "Capabilities=%Capabilities%^<uap:Capability Name=^"^"appointments^"^"/^>"
    goto 6
)
findstr.exe /rix "android.permission.WRITE_CALENDAR" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 set "Capabilities=%Capabilities%^<uap:Capability Name=^"^"appointments^"^"/^>"

:6
findstr.exe /rix "android.permission.ACCESS_COARSE_LOCATION" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 (
    set "Capabilities=%Capabilities%^<DeviceCapability Name=^"^"location^"^"/^>"
    goto 7
)
findstr.exe /rix "android.permission.ACCESS_FINE_LOCATION" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 set "Capabilities=%Capabilities%^<DeviceCapability Name=^"^"location^"^"/^>"

:7
findstr.exe /rix "android.permission.RECORD_AUDIO" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 set "Capabilities=%Capabilities%^<DeviceCapability Name=^"^"microphone^"^"/^>"
findstr.exe /rix "android.permission.BLUETOOTH_ADMIN" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 set "Capabilities=%Capabilities%^<DeviceCapability Name=^"^"radios^"^"/^>"
findstr.exe /rix "android.permission.BLUETOOTH" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 set "Capabilities=%Capabilities%^<DeviceCapability Name=^"^"bluetooth^"^"/^>"
findstr.exe /rix "android.permission.CAMERA" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 set "Capabilities=%Capabilities%^<DeviceCapability Name=^"^"webcam^"^"/^>"
findstr.exe /rix "android.permission.NFC" "%CD%\Temp\Permissions.txt" %Verbose%
if %errorlevel% EQU 0 set "Capabilities=%Capabilities%^<DeviceCapability Name=^"^"proximity^"^"/^>"

for /f "skip=1 delims=" %%a in ('certutil.exe -hashfile "%APK%" MD5') do (
    set "Hash=%%a"
    goto Generating_Manifest
)

:Generating_Manifest
echo.
echo [32mWriting manifest...[0m
set "Hash=%Hash: =%"
echo>"%CD%\Temp\ManifestGen.vbs" Set objFS = CreateObject("Scripting.FileSystemObject")
echo>>"%CD%\Temp\ManifestGen.vbs" strFile = "%CD%\Agent\Templates\AppxManifest.xml"
echo>>"%CD%\Temp\ManifestGen.vbs" Set objFile = objFS.OpenTextFile(strFile)
echo>>"%CD%\Temp\ManifestGen.vbs" Do Until objFile.AtEndOfStream
echo>>"%CD%\Temp\ManifestGen.vbs"   strLine = objFile.ReadLine
echo>>"%CD%\Temp\ManifestGen.vbs"   If InStr(strLine, "%%PackageName%%") ^> 0 Then
echo>>"%CD%\Temp\ManifestGen.vbs"       strLine = Replace(strLine, "%%PackageName%%", "%PackageName:.=%")
echo>>"%CD%\Temp\ManifestGen.vbs"   End If
echo>>"%CD%\Temp\ManifestGen.vbs"   If InStr(strLine, "%%PackageLabel%%") ^> 0 Then
echo>>"%CD%\Temp\ManifestGen.vbs"       strLine = Replace(strLine, "%%PackageLabel%%", "%PackageLabel:.=%")
echo>>"%CD%\Temp\ManifestGen.vbs"   End If
echo>>"%CD%\Temp\ManifestGen.vbs"   If InStr(strLine, "%%Version:~0,4%%") ^> 0 Then
echo>>"%CD%\Temp\ManifestGen.vbs"       strLine = Replace(strLine, "%%Version:~0,4%%", "%Version:~0,4%")
echo>>"%CD%\Temp\ManifestGen.vbs"   End If
echo>>"%CD%\Temp\ManifestGen.vbs"   If InStr(strLine, "%%Version%%") ^> 0 Then
echo>>"%CD%\Temp\ManifestGen.vbs"       strLine = Replace(strLine, "%%Version%%", "%Version%")
echo>>"%CD%\Temp\ManifestGen.vbs"   End If
echo>>"%CD%\Temp\ManifestGen.vbs"   If InStr(strLine, "%%Hash%%") ^> 0 Then
echo>>"%CD%\Temp\ManifestGen.vbs"       strLine = Replace(strLine, "%%Hash%%", "%Hash%")
echo>>"%CD%\Temp\ManifestGen.vbs"   End If
echo>>"%CD%\Temp\ManifestGen.vbs"   If InStr(strLine, "%%Capabilities%%") ^> 0 Then
if defined Capabilities (
    echo>>"%CD%\Temp\ManifestGen.vbs"       strLine = Replace(strLine, "%%Capabilities%%", "%Capabilities:^=%"^)
) else (
    echo>>"%CD%\Temp\ManifestGen.vbs"       strLine = Replace(strLine, "%%Capabilities%%", ""^)
)
echo>>"%CD%\Temp\ManifestGen.vbs"   End If
echo>>"%CD%\Temp\ManifestGen.vbs"   WScript.Echo strLine
echo>>"%CD%\Temp\ManifestGen.vbs" Loop
type "%CD%\Temp\ManifestGen.vbs" %Verbose%
cscript /nologo "%CD%\Temp\ManifestGen.vbs" > "%CD%\Temp\AppxProject\AppxManifest.xml"
echo>"%CD%\Temp\ConfigGen.vbs" Set objFS = CreateObject("Scripting.FileSystemObject")
echo>>"%CD%\Temp\ConfigGen.vbs" strFile = "%CD%\Agent\Templates\config.xml"
echo>>"%CD%\Temp\ConfigGen.vbs" Set objFile = objFS.OpenTextFile(strFile)
echo>>"%CD%\Temp\ConfigGen.vbs" Do Until objFile.AtEndOfStream
echo>>"%CD%\Temp\ConfigGen.vbs"     strLine = objFile.ReadLine
echo>>"%CD%\Temp\ConfigGen.vbs"     If InStr(strLine, "%%Package%%")^> 0 Then
echo>>"%CD%\Temp\ConfigGen.vbs"         strLine = Replace(strLine, "%%Package%%", "%Package%")
echo>>"%CD%\Temp\ConfigGen.vbs"     End If
echo>>"%CD%\Temp\ConfigGen.vbs"     WScript.Echo strLine
echo>>"%CD%\Temp\ConfigGen.vbs" Loop
type "%CD%\Temp\ConfigGen.vbs" %Verbose%
cscript /nologo "%CD%\Temp\ConfigGen.vbs" > "%CD%\Temp\AppxProject\config.xml"

:Preparing_Templates
echo.
echo [32mPreparing templates...[0m
copy "%CD%\Agent\Templates\*.dll" "%CD%\Temp\AppxProject" %Verbose%
copy "%CD%\Agent\Templates\*.exe" "%CD%\Temp\AppxProject" %Verbose%
copy "%CD%\Agent\Templates\*.winmd" "%CD%\Temp\AppxProject" %Verbose%
copy "%APK%" "%CD%\Temp\AppxProject" %Verbose%
ren "%CD%\Temp\AppxProject\*.apk" "payload.apk"
"%CD%\Agent\Tools\MakePri.exe" createconfig /cf "%CD%\Temp\priconfig.xml" /dq lang-en-US_scale-100 /o /v %Verbose%
"%CD%\Agent\Tools\MakePri.exe" new /pr "%CD%\Temp\AppxProject" /cf "%CD%\Temp\priconfig.xml" /of "%CD%\Temp\AppxProject" /o /v %Verbose%
if %errorlevel% NEQ 0 (
    set "Error=5"
    goto Errors
)

:Packing_APPX
echo.
echo [32mPacking APPX...[0m
if exist "%CD%\Output\%APKLabel%.*" del "%CD%\Output\%APKLabel%.*"  %Verbose%
"%CD%\Agent\Tools\makeappx.exe" pack /nv /v /h SHA256 /d "%CD%\Temp\AppxProject" /p "%CD%\Output\%APKLabel%.appx" %Verbose%
if %errorlevel% NEQ 0 (
    set "Error=6"
    goto Errors
)
"%CD%\Agent\Tools\makecert.exe" -r -h 0 -n "CN=Microsoft" -pe -sv "%CD%\Output\%APKLabel%.pvk" "%CD%\Output\%APKLabel%.cer" %Verbose%
"%CD%\Agent\Tools\pvk2pfx.exe" -pvk "%CD%\Output\%APKLabel%.pvk" -spc "%CD%\Output\%APKLabel%.cer" -pfx "%CD%\Output\%APKLabel%.pfx" %Verbose%
"%CD%\Agent\Tools\signtool.exe" sign /a /v /fd SHA256 /f "%CD%\Output\%APKLabel%.pfx" "%CD%\Output\%APKLabel%.appx" %Verbose%
del "%CD%\Output\%APKLabel%.cer" %Verbose%
del "%CD%\Output\%APKLabel%.pvk" %Verbose%
del "%CD%\Output\%APKLabel%.pfx" %Verbose%
if %errorlevel% NEQ 0 (
    set "Error=7"
    goto Errors
)
if "%Clean%" NEQ "0" rd /q /s "%CD%\Temp" %Verbose%

setlocal disabledelayedexpansion
endlocal
set "APK="
set "IconLabel="
set "Capabilities="
echo.
pause >nul | set /p =[36mDone.[0m
goto Start

:Errors
if "%Clean%" NEQ "0" rd /q /s "%CD%\Temp" %Verbose%
echo.
echo [31m--------------------------------------[0m
if "%Error%" EQU "1" pause >nul | set /p =[31mPlease input a valid APK file...[0m
if "%Error%" EQU "2" pause >nul | set /p =[31mNo APK file found at "%APK%"[0m
if "%Error%" EQU "3" pause >nul | set /p =[31mAPK that are targeting minimum SDK Version 20 or higher is unsupported...[0m
::if "%Error%" EQU "4" pause >nul | set /p =[31mUnsupported APK file...[0m
if "%Error%" EQU "5" pause >nul | set /p =[31mPreparing templates failed...[0m
if "%Error%" EQU "6" pause >nul | set /p =[31mPackage creation failed...[0m
if "%Error%" EQU "7" pause >nul | set /p =[31mPackage signing failed...[0m
set "APK="
goto Start
