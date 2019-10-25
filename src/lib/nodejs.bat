rem Nodejs action functions
@echo off

set batdir=%~dp0
set batfile=%0
set cliCmd=%batdir%cli.bat
set configCmd=%batdir%config.bat

if "%~1" neq "" (
  2>nul >nul findstr /rc:"^ *:%~1\>" "%~f0" && (
    shift /1
    goto %1
  ) || (
    >&2 call %cliCmd% fatalError "Function %~1 not found in %batfile%"
  )
) else >&2 call %cliCmd% fatalError "No function name was given to %batfile%"
exit /b

:npmExists
    set errorlevel=
    call %cliCmd% cmdExists  "npm.cmd"
    exit /b %errorlevel%


:installGlobalNpmPackages
    setlocal EnableDelayedExpansion

    
    set configPath=
    call %configCmd% useConfig "npm" %1
    

    call %cliCmd% processing "Installing NPM global packages from config file ^!configPath^!"
    set unsafeConfigPath=%configPath:"=%
    for /F "delims=" %%i in (%unsafeConfigPath%) do set packages=!packages! %%i
    call %cliCmd% execCmd "npm.cmd i -g %packages%"
    echo .
    call %cliCmd% success "Installation of NPM global packages is done"


    set userAnswer=
    call %cliCmd% prompt "If you want to install NPM global packages, please enter them: "
    if "%userAnswer%" == "" (
        call %cliCmd% success "No NPM global packages given"
    ) else (
       
    )

    endlocal
    exit /b
