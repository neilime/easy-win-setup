rem Optimizer action functions
@echo off

set batdir=%~dp0
set batfile=%0
set cliCmd=%batdir%../utils/cli.bat
set optimizerConfigPath="%batdir%\..\config\windows10.conf"
set optimizerExePath="%tmp%\Optimizer.exe"

if "%~1" neq "" (
  2>nul >nul findstr /rc:"^ *:%~1\>" "%~f0" && (
    shift /1
    goto %1
  ) || (
    >&2 call %cliCmd% fatalError "Function %~1 not found in %batfile%"
  )
) else >&2 call %cliCmd% fatalError "No function name was given to %batfile%"
exit /b

:getOptimizerExe
    rem Check if optimizer exe exists
    for %%X in (%optimizerExePath%) do (set optimizerFound=%%~$PATH:X)
    if defined optimizerFound (
        set optimizerExe="%optimizerFound%"
        exit /b 0
    ) else (
        exit /b 4
    )

:executeOptimizer
    set "optimizerExe="
    call :getOptimizerExe

    if defined optimizerExe (
        echo.
        call %cliCmd% processing "Execute Optimizer"
        call %cliCmd% execCmd "!optimizerExe! /!optimizerConfigPath!"
        call %cliCmd% success "Optimizer execution is done"
    ) else (
        call %cliCmd% fatalError "Optimizer executable not found !optimizerExe!"
        exit /b 1
    )

    exit /b
