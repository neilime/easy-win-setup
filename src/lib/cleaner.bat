rem Cleaner action functions
@echo off

set batdir=%~dp0
set batfile=%0
set cliCmd=%batdir%cli.bat
set ccleanerExePath="%programfiles%\CCleaner\ccleaner.exe"

if "%~1" neq "" (
  2>nul >nul findstr /rc:"^ *:%~1\>" "%~f0" && (
    shift /1
    goto %1
  ) || (
    >&2 call %cliCmd% fatalError "Function %~1 not found in %batfile%"
  )
) else >&2 call %cliCmd% fatalError "No function name was given to %batfile%"
exit /b

:uninstallSoftwares
    setlocal EnableDelayedExpansion

    call %cliCmd% processing "Listing installed softwares"
    for /F "skip=2 tokens=2-3 delims=," %%a in ('wmic product get name^,version /format:csv') do (
        set name=%%a

        set errorlevel=
        call %cliCmd% confirmPrompt "Do you want to uninstall ^!name^!",n
        if !errorlevel!==0 (
            call :uninstallSoftware "^!name^!"
        )
    )

    endlocal
    exit /b

:uninstallSoftware
    setlocal EnableDelayedExpansion

    set name=%1
    call %cliCmd% processing "Uninstalling ^!name^!"
    set unquotedName=%name:"=%
    set where="Name='!unquotedName!'"
    call %cliCmd% execCmd "wmic product where ^!where^! Call Uninstall /NoInteractive" >nul
    call %cliCmd% success "^!name^! has been uninstalled"

    endlocal
    exit /b

:deleteStartupEntries
    setlocal EnableDelayedExpansion

    call %cliCmd% processing "Fetching startup entries"

    set caption=
    set command=
    set location=
    for /f "tokens=*" %%a in ('wmic startup get caption^,command^,location^ /format:list ^| findstr /r /v "^$"') do (
        set "line=%%a"

        for /f "tokens=1-2 delims==" %%b in ('echo !line!') do (
            if "%%b" == "Caption" (
                set "caption=%%c"
            ) else if "%%b" == "Command" (
                set "command=%%c"
            ) else if "%%b" == "Location" (
                set "location=%%c"
            )

            if not defined caption (
                set shouldCall=
            ) else if not defined command (
                set shouldCall=
            ) else if not defined location (
                set shouldCall=
            ) else (
                set errorlevel=
                call %cliCmd% confirmPrompt "Do you want to delete startup entry ^!caption^!",n
                if !errorlevel!==0 (
                    call :deleteStartupEntry "^!caption^!", "^!command^!", "^!location^!"
                )
                set caption=
                set command=
                set location=
            )
        )
    )

    endlocal
    exit /b

:deleteStartupEntry
    setlocal EnableDelayedExpansion

    set "caption=%1"
    set "command=%2"
    set "location=%~3"
    set "command=reg delete !location! /v !caption! /f"

    call %cliCmd% processing "Deleting ^!caption^!"
    call %cliCmd% execCmd "^!command^!" >nul
    call %cliCmd% success "^!caption^! has been deleted"

    endlocal
    exit /b

:getCCleanerExe
    rem Check if ccleaner exe exists
    for %%X in (%ccleanerExePath%) do (set ccleanerFound=%%~$PATH:X)
    if defined ccleanerFound (
        set ccleanerExe="%ccleanerFound%"
        exit /b 0
    ) else (
        exit /b 4
    )

:executeCCleaner
    set "ccleanerExe="
    call :getCCleanerExe

    if defined ccleanerExe (
        echo.
        call %cliCmd% processing "Running CCleaner auto clean"
        call %cliCmd% execCmd "^!ccleanerExe^! /AUTO"
        call %cliCmd% success "CCleaner auto clean is done"
    )
    exit /b
