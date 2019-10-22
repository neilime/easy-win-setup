rem Nodejs action functions
@echo off

set batdir=%~dp0
set batfile=%0
set cliCmd=%batdir%cli.bat

if "%~1" neq "" (
  2>nul >nul findstr /rc:"^ *:%~1\>" "%~f0" && (
    shift /1
    goto %1
  ) || (
    >&2 call %cliCmd% error "Function %~1 not found in %batfile%"
  )
) else >&2 call %cliCmd% error "No function name was given to %batfile%"
exit /b

:npmExists
    call %cliCmd% cmdExists  "npm.cmd"
    exit /b %ERRORLEVEL%


:installGlobalNpmPackages
    setlocal EnableDelayedExpansion

    set userAnswer=
    call %cliCmd% prompt "If you want to install NPM global packages, please enter them: "
    if "%userAnswer%" == "" (
        call %cliCmd% success "No NPM global packages given"
    ) else (
        call %cliCmd% processing "Installing NPM global packages"
        call %cliCmd% execCmd "npm.cmd i -g !userAnswer!"
        echo .
        call %cliCmd% success "Installation of NPM global packages is done"
    )

    endlocal
    exit /b
