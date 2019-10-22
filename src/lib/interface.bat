rem Interface action functions
@echo off

set batdir=%~dp0
set batfile=%0
set cliCmd=%batdir%cli.bat
set cleanerCmd=%batdir%cleaner.bat

if "%~1" neq "" (
  2>nul >nul findstr /rc:"^ *:%~1\>" "%~f0" && (
    shift /1
    goto %1
  ) || (
    >&2 call %cliCmd% error "Function %~1 not found in %batfile%"
  )
) else >&2 call %cliCmd% error "No function name was given to %batfile%"
exit /b

:restartExplorer
    call %cliCmd% processing "Restarting explorer"
    call %cliCmd% execCmd "taskkill /im explorer.exe /f">nul
    timeout 2>nul
    call %cliCmd% execCmd "start explorer.exe">nul
    call %cliCmd% success "Explorer has been restarted"

:enableDarkMode
    setlocal EnableDelayedExpansion

    call %cliCmd% processing "Enable dark mode"
    call %cliCmd% execCmd "REG ADD HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 00000000 /f">nul
    call %cliCmd% success "Dark mode has been setted"

    endlocal
    exit /b

:enableDisplayFileExtensions
    setlocal EnableDelayedExpansion

    call %cliCmd% processing "Enable the display of file extensions"
    call %cliCmd% execCmd "REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /t REG_DWORD /d 0 /f">nul
    call %cliCmd% success "Display file extensions has been setted"

    endlocal
    exit /b

:createDesktopDirFolders
    setlocal EnableDelayedExpansion

    set userAnswer=
    call %cliCmd% prompt "If you want to install packages, please give the desktop folders config path: "
    if "%userAnswer%" == "" (
        call %cliCmd% success "No chocolatey config path given"
    ) else (
        call %cliCmd% processing "Creating desktop folders from config file ^!userAnswer^!"
        if exist !userAnswer! (
            for /F "skip=1 tokens=1-2 delims=," %%a in ("%1") do (
                set name=%%a
                set icon=%%b
                call :createDesktopFolder "^!name^!",!icon!
            )
            call %cliCmd% success "Creation of desktop folders is done"
        ) else (
            call %cliCmd% error "Config file ^!userAnswer^! does not exist"
        )
    )
    endlocal
    exit /b

:createDesktopFolder
    setlocal EnableDelayedExpansion

    mkdir %UserProfile%\Desktop\%1
    (
        echo [.ShellClassInfo]
        echo IconResource=C:\WINDOWS\System32\SHELL32.dll,%2
        echo [ViewState]
        echo Mode=
        echo Vid=
        echo FolderType=Generic
    ) > %UserProfile%\Desktop\%1\desktop.ini
    attrib +r %UserProfile%\Desktop\%1
    attrib +s +h %UserProfile%\Desktop\%1\desktop.ini

    endlocal
    exit /b

:createMaintenanceShortcut
    setlocal EnableDelayedExpansion

    call %cliCmd% processing  "Creating 'Maintenance' shortcut..."
    set "maintenanceCmd=echo [93m[ [4mExecute maintenace[0m[93m ][0m&&echo.&&echo.&&echo =^> Upgrade Chocolatey packages&&echo.&&choco upgrade all --y&&echo."

    set "ccleanerExe="
    call %cleanerCmd% getCCleanerExe
    if !ERRORLEVEL! equ 0 (
        set "maintenanceCmd=!maintenanceCmd!&&echo.&&(echo =^> Execute CCleaner)&&\"!ccleanerExe!\" /AUTO&&echo."
    )

    where npm-check.cmd >nul 2>nul
    if !ERRORLEVEL! equ 0 (
        set "maintenanceCmd=!maintenanceCmd!&&echo.&&(echo =^> Upgade npm packages)&&echo.&&npm-check.cmd -u -g&&echo."
    )

    set "maintenanceCmd=!maintenanceCmd!&&echo.&&echo.&&echo    [92m=======================[0m&&echo    [92m[ [4mMaintenance is done[0m[92m ][0m&&echo    [92m=======================[0m&&echo.&&echo."

    call %cliCmd% execPowershellCmd "$ShortcutPath='%UserProfile%\Desktop\Maintenance.lnk';$s=(New-Object -COM WScript.Shell).CreateShortcut($ShortcutPath);$s.TargetPath='%SystemRoot%\System32\cmd.exe';$s.Arguments='/k ^!maintenanceCmd^!';$s.IconLocation='%SystemRoot%\System32\shell32.dll,46';$s.Save();$bytes = [System.IO.File]::ReadAllBytes($ShortcutPath);$bytes[0x15] = $bytes[0x15] -bor 0x20;[System.IO.File]::WriteAllBytes($ShortcutPath, $bytes);"
    call %cliCmd% success "Creation of desktop 'Maintenance' shortcut is done"

    endlocal
    exit /b