@echo off

rem Path variables
set "bat2exeUrl=https://github.com/islamadel/bat2exe/releases/latest/download/bat2exe.exe"
set "bat2exeExePath=%tmp%\bat2exe.exe"
set batdir=%~dp0
set "srcDirPath=%batdir%..\src"
set "buildDirPath=%batdir%..\build"
set "generatedExePath=%buildDirPath%\setup.exe"
set "finalExeName=EasyWinSetup.exe"
set "finalExePath=%buildDirPath%\%finalExeName%"
set B2E_WS="%tmp%\BAT2EXE_WS.ini"
set B2E_TF="%tmp%\BAT2EXE_TF.ini"

goto execute
exit /b

:execute
    set "bat2exeExe="
    call :getBat2exeExe
    if not defined bat2exeExe (
        call :installBat2exe
    )
    
    if exist "%finalExePath%" del /F /Q "%finalExePath%"
    if not exist "%buildDirPath%" mkdir "%buildDirPath%"

    @echo %srcDirPath%> %B2E_WS%
    @echo %buildDirPath%> %B2E_TF%

    %bat2exeExe%

    rename "%generatedExePath%" "%finalExeName%"

    exit /b

:getbat2exeexe
    rem Check if optimizer exe exists
    for %%X in (%bat2exeExePath%) do (set bat2exeFound=%%~$PATH:X)
    if defined bat2exeFound (
        set bat2exeExe="%bat2exeFound%"
        exit /b 0
    ) else (
        exit /b 4
    )

:installBat2exe
    setlocal EnableDelayedExpansion
    call :execPowershellCmd "(New-Object System.Net.WebClient).DownloadFile('^!bat2exeUrl^!', '^!bat2exeExePath^!')"
    endlocal

    set "bat2exeExe="
    call :getBat2exeExe
    if not defined bat2exeExe (
        echo "An unexpected error occured udring installation, bat2exe executable file does exist"        
        exit /b 1
    )

    exit /b

:execPowershellCmd
    @echo off
    setlocal EnableDelayedExpansion

    set errorlevel=
    powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command %1
    if !errorlevel! neq 0 (
        endLocal
        echo Press any key to exit...
        pause >nul
        goto :halt
    )

    endLocal
    exit /b