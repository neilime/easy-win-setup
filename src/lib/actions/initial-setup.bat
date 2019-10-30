rem Win10-Initial-Setup-Script action functions
@echo off

rem Win10-Initial-Setup-Script version (https://github.com/Disassembler0/Win10-Initial-Setup-Script/releases)
set initialSetupVersion=3.8

rem Path variables
set "initialSetupUrl=https://github.com/Disassembler0/Win10-Initial-Setup-Script/archive/%initialSetupVersion%.zip"
set "initialSetupPath=%tmp%\initialSetup\"
set "initialSetupDownloadPath=%initialSetupPath%%initialSetupVersion%.zip"
set "initialSetupSourcePath=%initialSetupPath%Win10-Initial-Setup-Script-%initialSetupVersion%\"
set "initialSetupExePath=%initialSetupSourcePath%Win10.ps1"

set batdir=%~dp0
set cliCmd=%batdir%../utils/cli.bat
set configCmd=%batdir%../utils/config.bat

goto execute
exit /b

:execute
    set "initialSetupExe="
    call :getInitialSetupExe

    if not defined initialSetupExe (
        call :installInitialSetup
    )

    set configPath=
    call %configCmd% useConfig "initial-setup" %1

    call %cliCmd% processing "Execute Initial setup"
    powershell -NoProfile -ExecutionPolicy Bypass -File %initialSetupExe% -include %initialSetupSourcePath%Win10.psm1 -preset %configPath%
    call %cliCmd% success "Initial setup execution is done"

    exit /b

:getInitialSetupExe
    rem Check if optimizer exe exists
    for %%X in (%initialSetupExePath%) do (set initialSetupFound=%%~$PATH:X)
    if defined initialSetupFound (
        set initialSetupExe="%initialSetupFound%"
        exit /b 0
    ) else (
        exit /b 4
    )

:installInitialSetup
    setlocal EnableDelayedExpansion
    call %cliCmd% processing "Downloading Win10-Initial-Setup-Script version %initialSetupVersion%"
    call %cliCmd% safeMkdir "^!initialSetupPath^!"

    call %cliCmd% execPowershellCmd "(New-Object System.Net.WebClient).DownloadFile('^!initialSetupUrl^!', '^!initialSetupDownloadPath^!')"
    call %cliCmd% success "Download of Win10-Initial-Setup-Script is done"

    call %cliCmd% processing "Unziping Win10-Initial-Setup-Script"
    call %cliCmd% execPowershellCmd "Expand-Archive -Path '^!initialSetupDownloadPath^!' -DestinationPath '^!initialSetupPath^!'" >nul
    call %cliCmd% success "Unziping Win10-Initial-Setup-Script is done"
    endlocal

    set "initialSetupExe="
    call :getInitialSetupExe
    if not defined initialSetupExe (
        call %cliCmd% fatalError "An unexpected error occured udring installation, initial setup executable file does exist"
    )

    exit /b 0
