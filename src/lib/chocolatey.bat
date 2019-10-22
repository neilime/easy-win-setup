rem Chocolatey action functions
@echo off

set batdir=%~dp0
set batfile=%0
set cliCmd=%batdir%cli.bat
set chocolateyInstallUrl=https://chocolatey.org/install.ps1

if "%~1" neq "" (
  2>nul >nul findstr /rc:"^ *:%~1\>" "%~f0" && (
    shift /1
    goto %1
  ) || (
    >&2 call %cliCmd% error "Function %~1 not found in %batfile%"
  )
) else >&2 call %cliCmd% error "No function name was given to %batfile%"
exit /b

:executeChocolatey
    setlocal EnableDelayedExpansion

    call %cliCmd% processing "Checking if Chocolatey is installed"
    call %cliCmd% cmdExists "choco"
    if %ERRORLEVEL% equ 0 (
        call %cliCmd% success "Chocolatey is already installed"
    ) else (
        call %cliCmd% processing "Installing Chocolatey"
        call %cliCmd% execPowershellCmd "iex ((New-Object System.Net.WebClient).DownloadString('%chocolateyInstallUrl%'))"
        SET PATH="%PATH%;%ALLUSERSPROFILE%\chocolatey\bin\"
        call %cliCmd% success "Chocolatey has been installed"
    )

    rem Install Chocolatey packages
    set userAnswer=
    call %cliCmd% prompt "If you want to install packages, please give the chocolatey config path: "
    if "%userAnswer%" == "" (
        call %cliCmd% success "No chocolatey config path given"
    ) else (
        call %cliCmd% processing "Installing Chocolatey packages from config file ^!userAnswer^!"
        if exist !userAnswer! (
            call %cliCmd% execCmd "choco install --confirm --packages ^!userAnswer^!"
            echo .
            call %cliCmd% success "Installation of Chocolatey packages is done"
        ) else (
            call %cliCmd% error "Config file ^!userAnswer^! does not exist"
        )
    )

    endlocal
    exit /b