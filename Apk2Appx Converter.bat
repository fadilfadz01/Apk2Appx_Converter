@echo off
setlocal enabledelayedexpansion
if not exist "%CD%\Settings.dat" echo>"%CD%\Settings.dat" [settings]&echo>>"%CD%\Settings.dat" RunAsAdmin = 0&echo>>"%CD%\Settings.dat" CleanTempFolder = 1&echo>>"%CD%\Settings.dat" DebugMode = 0
"%CD%\Agent\Tools\MD5Gen.exe" >nul 2>&1
for /f "tokens=3 delims= " %%a in ('findstr /ri "RunAsAdmin" "%CD%\Settings.dat"') do if not "1"=="%%a" goto Setup
if "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UserAccountControl
) else ( goto GotAdministrator )
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
for /f "tokens=3 delims= " %%a in ('findstr /ri "CleanTempFolder" "%CD%\Settings.dat"') do if not "0"=="%%a" (set "Clean=1") else (set "Clean=0")
for /f "tokens=3 delims= " %%a in ('findstr /ri "DebugMode" "%CD%\Settings.dat"') do if not "1"=="%%a" (set "Verbose=>nul 2>&1"
mode 72,19) else (mode 72,700
powershell -command "&{(get-host).ui.rawui.windowsize=@{width=72;height=19};}")
title Apk2Appx Converter for ProjectA
set "Intro=Apk2Appx Converter&echo Version 2.3.5.5 beta&echo Copyright (C) 2021 by @fadilfadz01 ^& @Empyreal96&echo."
if not exist "%CD%\Output" md "%CD%\Output"
:Start
cls
color 05
echo %Intro%
set /p "APK=Input APK file: "
set "APK=%APK:"=%"
if not "%APK%"=="%APK:~0,-4%.apk" cls&color 04&echo %Intro%&pause >nul | set /p =Please input a valid APK file...&goto Start
if not exist "%APK%" cls&color 04&echo %Intro%&pause >nul | set /p =No APK found at "%APK%"&goto Start
for %%a in ("%APK%") do set "APKLabel=%%~na"
cls
color 0a
echo %Intro%
:Reading_APK
echo Reading APK...
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt" d badging "%APK%" ^| findstr /rim "sdkVersion:'"') do set "MinAPI=%%a"&goto 1
:1
if %MinAPI% gtr 19 set "Error=1"&goto Errors
::for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt" d badging "%APK%"') do set "Package=%%a"&goto ReadingPart1
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt" d badging "%APK%" ^| findstr /rim "package: "') do set "Package=%%a"
::ReadingPart1
set PackageName=%Package:_=%
set PackageName=%PackageName:-=%
::for /f "tokens=4 delims='" %%a in ('call "%CD%\Agent\Tools\aapt" d badging "%APK%"') do set "Version=%%a"&goto ReadingPart2
for /f "tokens=4 delims='" %%a in ('call "%CD%\Agent\Tools\aapt" d badging "%APK%" ^| findstr /rim " versionCode='"') do set "Version=%%a"
::ReadingPart2
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt" d badging "%APK%" ^| findstr /rim " Label='"') do set "PackageLabel=%%a"&goto 2
:2
set "PackageLabel=%PackageLabel:&=&amp;%"
if exist "%CD%\Temp" (rd /q /s "%CD%\Temp"&md "%CD%\Temp\AppxProject\Assets") else (md "%CD%\Temp\AppxProject\Assets")
for /f "skip=1 tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt" d permissions "%APK%"') do echo %%a >>"%CD%\Temp\Permissions.txt"
::for /f "tokens=4 delims='" %%a in ('call "%CD%\Agent\Tools\aapt" d badging "%APK%" ^| findstr /rim " icon='res/"') do set "Icon=%%a"
::"%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" %Icon%
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt" d badging "%APK%" ^| findstr /rim "application-icon-120:"') do set "Icon=%%a"
if defined Icon "%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" %Icon% -y %Verbose%
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt" d badging "%APK%" ^| findstr /rim "application-icon-160:"') do set "Icon=%%a"
if defined Icon "%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" %Icon% -y %Verbose%
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt" d badging "%APK%" ^| findstr /rim "application-icon-213:"') do set "Icon=%%a"
if defined Icon "%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" %Icon% -y %Verbose%
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt" d badging "%APK%" ^| findstr /rim "application-icon-240:"') do set "Icon=%%a"
if defined Icon "%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" %Icon% -y %Verbose%
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt" d badging "%APK%" ^| findstr /rim "application-icon-320:"') do set "Icon=%%a"
if defined Icon "%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" %Icon% -y %Verbose%
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt" d badging "%APK%" ^| findstr /rim "application-icon-480:"') do set "Icon=%%a"
if defined Icon "%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" %Icon% -y %Verbose%
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt" d badging "%APK%" ^| findstr /rim "application-icon-640:"') do set "Icon=%%a"
if defined Icon "%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" %Icon% -y %Verbose%
for /f "tokens=2 delims='" %%a in ('call "%CD%\Agent\Tools\aapt" d badging "%APK%" ^| findstr /rim "application-icon-65535:"') do set "Icon=%%a"
if defined Icon "%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" %Icon% -y %Verbose%
for %%a in ("%CD%\Temp\*.png") do Set "IconLabel=%%~nxa"
if not defined IconLabel for %%a in ("%CD%\Temp\*.xml") do (set IconLabel=%%~na.png
"%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" res/mipmap-anydpi/!IconLabel! -y %Verbose%
"%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" res/mipmap-anydpi-v26/!IconLabel! -y %Verbose%
"%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" res/mipmap-hdpi/!IconLabel! -y %Verbose%
"%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" res/mipmap-hdpi-v4/!IconLabel! -y %Verbose%
"%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" res/mipmap-mdpi/!IconLabel! -y %Verbose%
"%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" res/mipmap-mdpi-v4/!IconLabel! -y %Verbose%
"%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" res/mipmap-xhdpi/!IconLabel! -y %Verbose%
"%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" res/mipmap-xhdpi-v4/!IconLabel! -y %Verbose%
"%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" res/mipmap-xxhdpi/!IconLabel! -y %Verbose%
"%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" res/mipmap-xxhdpi-v4/!IconLabel! -y %Verbose%
"%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" res/mipmap-xxxhdpi/!IconLabel! -y %Verbose%
"%CD%\Agent\Tools\7za" e "%APK%" -o"%CD%\Temp" res/mipmap-xxxhdpi-v4/!IconLabel! -y %Verbose%)
::if not exist "%CD%\Temp\%IconLabel%" set "Error=2"&goto Errors
if not exist "%CD%\Temp\%IconLabel%" copy "%CD%\Agent\Templates\Assets\Icon.png" "%CD%\Temp\%IconLabel%" %Verbose%
::if not defined IconLabel cls&color 04&echo %Intro%&pause >nul | set /p =Unsupported APK file...&goto Errors
:Generating_Assets
echo.&echo Generating Assets...
::copy "%CD%\Temp\%IconLabel%" "%CD%\Temp\AppxProject\Assets\AppLogo.scale-100.png"
::"%CD%\Agent\Tools\magick" mogrify -resize 44x44  "%CD%\Temp\AppxProject\Assets\AppLogo.scale-100.png"
"%CD%\Agent\Tools\magick" mogrify -resize 192x192  "%CD%\Temp\%IconLabel%" %Verbose%
"%CD%\Agent\Tools\magick" convert "%CD%\Temp\%IconLabel%" -resize 44x44 "%CD%\Temp\AppxProject\Assets\AppLogo.scale-100.png" %Verbose%
"%CD%\Agent\Tools\magick" convert "%CD%\Temp\%IconLabel%" -resize 62x62  "%CD%\Temp\AppxProject\Assets\AppLogo.scale-140.png" %Verbose%
"%CD%\Agent\Tools\magick" convert "%CD%\Temp\%IconLabel%" -resize 106x106  "%CD%\Temp\AppxProject\Assets\AppLogo.scale-240.png" %Verbose%
::"%CD%\Agent\Tools\magick" composite -blend 100 -gravity center -geometry +0-100 "%CD%\Temp\%IconLabel%" "%CD%\Agent\Templates\Assets\SplashScreen.scale-100.png" "%CD%\Temp\AppxProject\Assets\SplashScreen.scale-100.png"
::copy "%CD%\Temp\%IconLabel%" "%CD%\Temp\AppxProject\Assets\SplashScreen.scale-140.png"
::"%CD%\Agent\Tools\magick" mogrify -resize 672x1120  "%CD%\Temp\AppxProject\Assets\SplashScreen.scale-140.png"
::"%CD%\Agent\Tools\magick" composite -blend 100 -gravity center -geometry +0-100 "%CD%\Temp\%IconLabel%" "%CD%\Agent\Templates\Assets\SplashScreen.scale-140.png" "%CD%\Temp\AppxProject\Assets\SplashScreen.scale-140.png"
"%CD%\Agent\Tools\magick" composite -blend 100 -gravity center -geometry +0-100 "%CD%\Temp\%IconLabel%" "%CD%\Agent\Templates\Assets\SplashScreen.scale-240.png" "%CD%\Temp\AppxProject\Assets\SplashScreen.scale-240.png" %Verbose%
"%CD%\Agent\Tools\magick" convert "%CD%\Temp\AppxProject\Assets\SplashScreen.scale-240.png" -resize 480x800  "%CD%\Temp\AppxProject\Assets\SplashScreen.scale-100.png" %Verbose%
"%CD%\Agent\Tools\magick" convert "%CD%\Temp\AppxProject\Assets\SplashScreen.scale-240.png" -resize 672x1120  "%CD%\Temp\AppxProject\Assets\SplashScreen.scale-140.png" %Verbose%
"%CD%\Agent\Tools\magick" convert "%CD%\Temp\%IconLabel%" -resize 50x50  "%CD%\Temp\AppxProject\Assets\StoreLogo.scale-100.png" %Verbose%
"%CD%\Agent\Tools\magick" convert "%CD%\Temp\%IconLabel%" -resize 70x70  "%CD%\Temp\AppxProject\Assets\StoreLogo.scale-140.png" %Verbose%
"%CD%\Agent\Tools\magick" convert "%CD%\Temp\%IconLabel%" -resize 120x120  "%CD%\Temp\AppxProject\Assets\StoreLogo.scale-240.png" %Verbose%
"%CD%\Agent\Tools\magick" convert "%CD%\Temp\%IconLabel%" -resize 150x150  "%CD%\Temp\AppxProject\Assets\TileLogoMedium.scale-100.png" %Verbose%
"%CD%\Agent\Tools\magick" convert "%CD%\Temp\%IconLabel%" -resize 210x210  "%CD%\Temp\AppxProject\Assets\TileLogoMedium.scale-140.png" %Verbose%
"%CD%\Agent\Tools\magick" convert "%CD%\Temp\%IconLabel%" -resize 360x360  "%CD%\Temp\AppxProject\Assets\TileLogoMedium.scale-240.png" %Verbose%
"%CD%\Agent\Tools\magick" convert "%CD%\Temp\%IconLabel%" -resize 71x71  "%CD%\Temp\AppxProject\Assets\TileLogoSmall.scale-100.png" %Verbose%
"%CD%\Agent\Tools\magick" convert "%CD%\Temp\%IconLabel%" -resize 99x99 "%CD%\Temp\AppxProject\Assets\TileLogoSmall.scale-140.png" %Verbose%
"%CD%\Agent\Tools\magick" convert "%CD%\Temp\%IconLabel%" -resize 170x170  "%CD%\Temp\AppxProject\Assets\TileLogoSmall.scale-240.png" %Verbose%
for /f "skip=1 delims=" %%a in ('certutil -hashfile "%APK%" MD5') do set "Hash=%%a"&goto Generating_Manifest
:Generating_Manifest
echo.&echo Generating Manifest...
echo>"%CD%\Temp\ManifestGen.vbs" Set objFS = CreateObject("Scripting.FileSystemObject")
echo>>"%CD%\Temp\ManifestGen.vbs" strFile = "%CD%\Agent\Templates\AppxManifest.xml"
echo>>"%CD%\Temp\ManifestGen.vbs" Set objFile = objFS.OpenTextFile(strFile)
echo>>"%CD%\Temp\ManifestGen.vbs" Do Until objFile.AtEndOfStream
echo>>"%CD%\Temp\ManifestGen.vbs" 	strLine = objFile.ReadLine
echo>>"%CD%\Temp\ManifestGen.vbs" 	If InStr(strLine,"%%PackageName%%")^> 0 Then
echo>>"%CD%\Temp\ManifestGen.vbs" 		strLine = Replace(strLine,"%%PackageName%%","%PackageName:.=%")
echo>>"%CD%\Temp\ManifestGen.vbs" 	End If
echo>>"%CD%\Temp\ManifestGen.vbs" 	If InStr(strLine,"%%PackageLabel%%")^> 0 Then
echo>>"%CD%\Temp\ManifestGen.vbs" 		strLine = Replace(strLine,"%%PackageLabel%%","%PackageLabel:.=%")
echo>>"%CD%\Temp\ManifestGen.vbs" 	End If
echo>>"%CD%\Temp\ManifestGen.vbs" 	If InStr(strLine,"%%Version:~0,4%%")^> 0 Then
echo>>"%CD%\Temp\ManifestGen.vbs" 		strLine = Replace(strLine,"%%Version:~0,4%%","%Version:~0,4%")
echo>>"%CD%\Temp\ManifestGen.vbs" 	End If
echo>>"%CD%\Temp\ManifestGen.vbs" 	If InStr(strLine,"%%Version%%")^> 0 Then
echo>>"%CD%\Temp\ManifestGen.vbs" 		strLine = Replace(strLine,"%%Version%%","%Version%")
echo>>"%CD%\Temp\ManifestGen.vbs" 	End If
echo>>"%CD%\Temp\ManifestGen.vbs" 	If InStr(strLine,"%%Hash%%")^> 0 Then
echo>>"%CD%\Temp\ManifestGen.vbs" 		strLine = Replace(strLine,"%%Hash%%","%Hash%")
echo>>"%CD%\Temp\ManifestGen.vbs" 	End If
echo>>"%CD%\Temp\ManifestGen.vbs" 	WScript.Echo strLine
echo>>"%CD%\Temp\ManifestGen.vbs" Loop
cscript /nologo "%CD%\Temp\ManifestGen.vbs" > "%CD%\Temp\AppxProject\AppxManifest.xml"
echo>"%CD%\Temp\ConfigGen.vbs" Set objFS = CreateObject("Scripting.FileSystemObject")
echo>>"%CD%\Temp\ConfigGen.vbs" strFile = "%CD%\Agent\Templates\config.xml"
echo>>"%CD%\Temp\ConfigGen.vbs" Set objFile = objFS.OpenTextFile(strFile)
echo>>"%CD%\Temp\ConfigGen.vbs" Do Until objFile.AtEndOfStream
echo>>"%CD%\Temp\ConfigGen.vbs" 	strLine = objFile.ReadLine
echo>>"%CD%\Temp\ConfigGen.vbs" 	If InStr(strLine,"%%Package%%")^> 0 Then
echo>>"%CD%\Temp\ConfigGen.vbs" 		strLine = Replace(strLine,"%%Package%%","%Package%")
echo>>"%CD%\Temp\ConfigGen.vbs" 	End If
echo>>"%CD%\Temp\ConfigGen.vbs" 	WScript.Echo strLine
echo>>"%CD%\Temp\ConfigGen.vbs" Loop
cscript /nologo "%CD%\Temp\ConfigGen.vbs" > "%CD%\Temp\AppxProject\config.xml"
:Calling_Android_API_to_Windows_API
echo.&echo Calling Android API to Windows API...
for /f %%a in ('Findstr /ri "android.permission.INTERNET" "%CD%\Temp\Permissions.txt"') do if "android.permission.INTERNET"=="%%a" echo   ^<Capability Name="internetClient"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml" &echo   ^<Capability Name="internetClientServer"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml"&echo   ^<Capability Name="privateNetworkClientServer"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml"&goto 3
for /f %%a in ('Findstr /ri "android.permission.ACCESS_NETWORK_STATE" "%CD%\Temp\Permissions.txt"') do if "android.permission.ACCESS_NETWORK_STATE"=="%%a" echo   ^<Capability Name="internetClient"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml"&goto 3
for /f %%a in ('Findstr /ri "android.permission.CHANGE_NETWORK_STATE" "%CD%\Temp\Permissions.txt"') do if "android.permission.CHANGE_NETWORK_STATE"=="%%a" echo   ^<Capability Name="internetClient"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml"&goto 3
for /f %%a in ('Findstr /ri "android.permission.ACCESS_WIFI_STATE" "%CD%\Temp\Permissions.txt"') do if "android.permission.ACCESS_WIFI_STATE"=="%%a" echo   ^<Capability Name="internetClient"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml"&goto 3
for /f %%a in ('Findstr /ri "android.permission.CHANGE_WIFI_STATE" "%CD%\Temp\Permissions.txt"') do if "android.permission.CHANGE_WIFI_STATE"=="%%a" echo   ^<Capability Name="internetClient"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml"
:3
for /f %%a in ('Findstr /ri "android.permission.READ_EXTERNAL_STORAGE" "%CD%\Temp\Permissions.txt"') do if "android.permission.READ_EXTERNAL_STORAGE"=="%%a" (echo   ^<uap:Capability Name="removableStorage"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml") else (
for /f %%a in ('Findstr /ri "android.permission.WRITE_EXTERNAL_STORAGE" "%CD%\Temp\Permissions.txt"') do if "android.permission.WRITE_EXTERNAL_STORAGE"=="%%a" echo   ^<uap:Capability Name="removableStorage"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml")
for /f %%a in ('Findstr /ri "android.permission.READ_CONTACTS" "%CD%\Temp\Permissions.txt"') do if "android.permission.READ_CONTACTS"=="%%a" echo   ^<uap:Capability Name="contacts"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml"&goto 4
for /f %%a in ('Findstr /ri "android.permission.WRITE_CONTACTS" "%CD%\Temp\Permissions.txt"') do if "android.permission.WRITE_CONTACTS"=="%%a" echo   ^<uap:Capability Name="contacts"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml"&goto 4
for /f %%a in ('Findstr /ri "android.permission.READ_SYNC_SETTINGS" "%CD%\Temp\Permissions.txt"') do if "android.permission.READ_SYNC_SETTINGS"=="%%a" echo   ^<uap:Capability Name="contacts"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml"&goto 4
for /f %%a in ('Findstr /ri "android.permission.WRITE_SYNC_SETTINGS" "%CD%\Temp\Permissions.txt"') do if "android.permission.WRITE_SYNC_SETTINGS"=="%%a" echo   ^<uap:Capability Name="contacts"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml"
:4
for /f %%a in ('Findstr /ri "android.permission.READ_CALENDAR" "%CD%\Temp\Permissions.txt"') do if "android.permission.READ_CALENDAR"=="%%a" (echo   ^<uap:Capability Name="appointments"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml") else (
for /f %%a in ('Findstr /ri "android.permission.WRITE_CALENDAR" "%CD%\Temp\Permissions.txt"') do if "android.permission.WRITE_CALENDAR"=="%%a" echo   ^<uap:Capability Name="appointments"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml")
for /f %%a in ('Findstr /ri "android.permission.ACCESS_COARSE_LOCATION" "%CD%\Temp\Permissions.txt"') do if "android.permission.ACCESS_COARSE_LOCATION"=="%%a" (echo   ^<DeviceCapability Name="location"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml") else (
for /f %%a in ('Findstr /ri "android.permission.ACCESS_FINE_LOCATION" "%CD%\Temp\Permissions.txt"') do if "android.permission.ACCESS_FINE_LOCATION"=="%%a" echo   ^<DeviceCapability Name="location"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml")
for /f %%a in ('Findstr /ri "android.permission.RECORD_AUDIO" "%CD%\Temp\Permissions.txt"') do if "android.permission.RECORD_AUDIO"=="%%a" echo   ^<DeviceCapability Name="microphone"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml"
for /f %%a in ('Findstr /ri "android.permission.BLUETOOTH_ADMIN" "%CD%\Temp\Permissions.txt"') do if "android.permission.BLUETOOTH_ADMIN"=="%%a" echo   ^<DeviceCapability Name="radios"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml"
for /f %%a in ('Findstr /ri "android.permission.BLUETOOTH" "%CD%\Temp\Permissions.txt"') do if "android.permission.BLUETOOTH"=="%%a" echo   ^<DeviceCapability Name="bluetooth"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml"
for /f %%a in ('Findstr /ri "android.permission.CAMERA" "%CD%\Temp\Permissions.txt"') do if "android.permission.CAMERA"=="%%a"echo   ^<DeviceCapability Name="webcam"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml"
for /f %%a in ('Findstr /ri "android.permission.NFC" "%CD%\Temp\Permissions.txt"') do if "android.permission.NFC"=="%%a"echo   ^<DeviceCapability Name="proximity"/^> >>"%CD%\Temp\AppxProject\AppxManifest.xml"
echo   ^</Capabilities^> >>"%CD%\Temp\AppxProject\AppxManifest.xml"
echo ^<Extensions^>^<Extension Category="windows.activatableClass.inProcessServer"^>^<InProcessServer^>^<Path^>AoWBackgroundTask.dll^</Path^>^<ActivatableClass ActivatableClassId="BackgroundTask.MainTask" ThreadingModel="both"/^>^<ActivatableClass ActivatableClassId="BackgroundTask.OutOfProcTask" ThreadingModel="both"/^>^</InProcessServer^>^</Extension^>^</Extensions^>^</Package^> >>"%CD%\Temp\AppxProject\AppxManifest.xml"
:Preparing_Templates
echo.&echo Preparing Templates...
copy "%CD%\Agent\Templates\*.dll" "%CD%\Temp\AppxProject" %Verbose%
copy "%CD%\Agent\Templates\*.exe" "%CD%\Temp\AppxProject" %Verbose%
copy "%CD%\Agent\Templates\*.winmd" "%CD%\Temp\AppxProject" %Verbose%
copy "%APK%" "%CD%\Temp\AppxProject" %Verbose%
ren "%CD%\Temp\AppxProject\*.apk" "payload.apk"
"%CD%\Agent\Tools\MakePri" createconfig /cf "%CD%\Temp\priconfig.xml" /dq lang-en-US_scale-100 /o /v %Verbose%
"%CD%\Agent\Tools\MakePri" new /pr "%CD%\Temp\AppxProject" /cf "%CD%\Temp\priconfig.xml" /of "%CD%\Temp\AppxProject" /o /v %Verbose%
if %errorlevel% neq 0 set "Error=3"&goto Errors
:Packing_APPX
echo.&echo Packing APPX...
if exist "%CD%\Output\%APKLabel%.*" del "%CD%\Output\%APKLabel%.*"  %Verbose%
"%CD%\Agent\Tools\AppCertificationKit\makeappx.exe" pack /nv /v /h SHA256 /d "%CD%\Temp\AppxProject" /p "%CD%\Output\%APKLabel%.appx" %Verbose%
if %errorlevel% neq 0 set "Error=4"&goto Errors
"%CD%\Agent\Tools\AppCertificationKit\makecert.exe" -r -h 0 -n "CN=Microsoft" -pe -sv "%CD%\Output\%APKLabel%.pvk" "%CD%\Output\%APKLabel%.cer" %Verbose%
"%CD%\Agent\Tools\AppCertificationKit\pvk2pfx.exe" -pvk "%CD%\Output\%APKLabel%.pvk" -spc "%CD%\Output\%APKLabel%.cer" -pfx "%CD%\Output\%APKLabel%.pfx" %Verbose%
"%CD%\Agent\Tools\AppCertificationKit\signtool.exe" sign /a /v /fd SHA256 /f "%CD%\Output\%APKLabel%.pfx" "%CD%\Output\%APKLabel%.appx" %Verbose%
del "%CD%\Output\%APKLabel%.cer" %Verbose%&del "%CD%\Output\%APKLabel%.pvk" %Verbose%&del "%CD%\Output\%APKLabel%.pfx" %Verbose%
if %errorlevel% neq 0 set "Error=5"&goto Errors
if not "%Clean%"=="0" rd /q /s "%CD%\Temp" %Verbose%
setlocal disabledelayedexpansion
endlocal
set "IconLabel="
echo.&color f3&pause >nul | set /p =Done.
goto Start
exit
:Errors
if not "%Clean%"=="0" rd /q /s "%CD%\Temp" %Verbose%
echo.&color 04&echo --------------------------------------
if "%Error%"=="1" pause >nul | set /p =APK that are targeting minimum SDK Version 20 or above is unsupported...
::if "%Error%"=="2" pause >nul | set /p =Unsupported APK file...
if "%Error%"=="3" pause >nul | set /p =Preparing templates failed...
if "%Error%"=="4" pause >nul | set /p =Package creation failed...
if "%Error%"=="5" pause >nul | set /p =Package signing failed...
goto Start