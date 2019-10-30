rem Chocolatey action functions
@echo off

set batdir=%~dp0
set cliCmd=%batdir%../utils/cli.bat
set configCmd=%batdir%../utils/config.bat
set chocolateyInstallUrl=https://chocolatey.org/install.ps1

goto execute
exit /b

:execute
    setlocal EnableDelayedExpansion

    call %cliCmd% processing "Checking if Chocolatey is installed"
    
    set errorlevel=
    call %cliCmd% cmdExists "choco"
    if !errorlevel! equ 0 (
        call %cliCmd% success "Chocolatey is already installed"
    ) else (
       call :installChocolatey
    )

    set configPath=
    call %configCmd% useConfig "chocolatey" %1    

    rem Install Chocolatey packages
    call %cliCmd% processing "Installing Chocolatey packages from config file ^!configPath^!"
    call %cliCmd% execCmd "choco install --confirm --packages ^!configPath^!"
    refreshenv
    echo .
    call %cliCmd% success "Installation of Chocolatey packages is done"

    endlocal
    exit /b

:installChocolatey
    setlocal EnableDelayedExpansion
    call %cliCmd% processing "Installing Chocolatey"
    call %cliCmd% execPowershellCmd "iex ((New-Object System.Net.WebClient).DownloadString('%chocolateyInstallUrl%'))"
    set PATH="%PATH%;%ALLUSERSPROFILE%\chocolatey\bin\"
    call %cliCmd% success "Chocolatey has been installed"
    endlocal
    refreshenv

    call %cliCmd% cmdExists "choco"
    if not !errorlevel! equ 0 (
        call %cliCmd% success "Chocolatey is already installed"
    ) else (
       call :installChocolatey
    )
    exit /b 0