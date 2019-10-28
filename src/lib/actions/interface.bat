rem Interface action functions
@echo off

set batdir=%~dp0
set cliCmd=%batdir%../utils/cli.bat
set configCmd=%batdir%../utils/config.bat
set cleanerCmd=%batdir%cleaner.bat

goto execute
exit /b

:execute
    rem Create desktop folders
    set errorlevel=
    call %cliCmd% confirmPrompt "Do you want to create desktop folders"
    if %errorlevel% equ 0 (
        call :createDesktopDirFolders %configDir%
    )

    rem Create desktop "Maintenance" shortcut
    set errorlevel=
    call %cliCmd% confirmPrompt "Do you want to create a 'Maintenance' shortcut"
    if %errorlevel% equ 0 (
        call :createMaintenanceShortcut
    )

    endlocal
    exit /b

:createDesktopDirFolders
    setlocal EnableDelayedExpansion

    set configPath=
    call %configCmd% useConfig "desktop-folders" %1

    call %cliCmd% processing "Creating desktop folders from config file ^!configPath^!"
    set unsafeConfigPath=%configPath:"=%
    for /F "skip=1 tokens=1-2 delims=," %%a in (%unsafeConfigPath%) do (
        set name=%%a
        set icon=%%b
        call :createDesktopFolder "^!name^!",!icon!
    )
    call %cliCmd% success "Creation of desktop folders is done"

    endlocal
    exit /b

:createDesktopFolder
    setlocal EnableDelayedExpansion

    set dirName=%1
    set dirPath=%UserProfile%\Desktop\!dirName!
    set icon=%1

    if not exist !dirPath! (
        mkdir !dirPath!
    )
    
    (
        echo [.ShellClassInfo]
        echo IconResource=C:\WINDOWS\System32\SHELL32.dll,!icon!
        echo [ViewState]
        echo Mode=
        echo Vid=
        echo FolderType=Generic
    ) > !dirPath!\desktop.ini

    attrib +r !dirPath!
    attrib +s +h !dirPath!\desktop.ini

    endlocal
    exit /b

:createMaintenanceShortcut
    setlocal EnableDelayedExpansion

    call %cliCmd% processing  "Creating 'Maintenance' shortcut..."
    set "maintenanceCmd=echo [93m[ [4mExecute maintenace[0m[93m ][0m&echo.&echo.&echo =^> Upgrade Chocolatey packages&echo.&choco upgrade all --y&echo."

    set ccleanerExe=
    call %cleanerCmd% getCCleanerExe
    if defined ccleanerExe (
        set "maintenanceCmd=!maintenanceCmd!&echo.&(echo =^> Execute CCleaner)&\"!ccleanerExe!\" /AUTO&echo."
    )

    set errorlevel=
    where npm-check.cmd >nul 2>nul
    if !errorlevel! equ 0 (
        set "maintenanceCmd=!maintenanceCmd!&echo.&(echo =^> Upgade npm packages)&echo.&npm-check.cmd -u -g&echo."
    )

    set "maintenanceCmd=!maintenanceCmd!&echo.&echo.&echo    [92m=======================[0m&echo    [92m[ [4mMaintenance is done[0m[92m ][0m&echo    [92m=======================[0m&echo.&echo."

    call %cliCmd% execPowershellCmd "$ShortcutPath='%UserProfile%\Desktop\Maintenance.lnk';$s=(New-Object -COM WScript.Shell).CreateShortcut($ShortcutPath);$s.TargetPath='%SystemRoot%\System32\cmd.exe';$s.Arguments='/k ^!maintenanceCmd^!';$s.IconLocation='%SystemRoot%\System32\shell32.dll,46';$s.Save();$bytes = [System.IO.File]::ReadAllBytes($ShortcutPath);$bytes[0x15] = $bytes[0x15] -bor 0x20;[System.IO.File]::WriteAllBytes($ShortcutPath, $bytes);"
    call %cliCmd% success "Creation of desktop 'Maintenance' shortcut is done"

    endlocal
    exit /b