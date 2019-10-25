rem Chocolatey action functions
@echo off

set batdir=%~dp0
set batfile=%0
set cliCmd=%batdir%cli.bat
set configCmd=%batdir%config.bat
set chocolateyInstallUrl=https://chocolatey.org/install.ps1

if "%~1" neq "" (
  2>nul >nul findstr /rc:"^ *:%~1\>" "%~f0" && (
    shift /1
    goto %1
  ) || (
    >&2 call %cliCmd% fatalError "Function %~1 not found in %batfile%"
  )
) else >&2 call %cliCmd% fatalError "No function name was given to %batfile%"
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

    set configPath=
    call %configCmd% useConfig "chocolatey" %1    

    rem Install Chocolatey packages
    call %cliCmd% processing "Installing Chocolatey packages from config file ^!configPath^!"
    call %cliCmd% execCmd "choco install --confirm --packages ^!configPath^!"
    echo .
    call %cliCmd% success "Installation of Chocolatey packages is done"

    endlocal
    exit /b