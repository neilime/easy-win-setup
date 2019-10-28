rem Driver cloud action functions
@echo off

set batdir=%~dp0
set batfile=%0
set cliCmd=%batdir%../utils/cli.bat
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

:vscodeExists
    set errorlevel=
    call %cliCmd% cmdExists  "code"
    exit /b %errorlevel%

:configureVSCode
    setlocal EnableDelayedExpansion

    call %cliCmd% processing "Configure VSCode"
    call %cliCmd% execCmd "code --install-extension Shan.code-settings-sync --force" >nul
    call %cliCmd% success "Configuration of VSCode is done"

    endlocal
    exit /b