rem CLI functions

@echo off

set batdir=%~dp0
set batfile=%0

if "%~1" neq "" (
  2>nul >nul findstr /rc:"^ *:%~1\>" "%~f0" && (
    shift /1
    goto %1
  ) || (
    >&2 call %cliCmd% error "Function %~1 not found in %batfile%"
  )
) else >&2 call %cliCmd% error "No function name was given to %batfile%"
exit /b

:banner
    echo.
    echo                  __________  __  _______  __  __________________     _____ ______________  ______
    echo                 / ____/ __ \/  ^|/  / __ \/ / / /_  __/ ____/ __ \   / ___// ____/_  __/ / / / __ \
    echo                / /   / / / / /^|_/ / /_/ / / / / / / / __/ / /_/ /   \__ \/ __/   / / / / / / /_/ /
    echo               / /___/ /_/ / /  / / ____/ /_/ / / / / /___/ _, _/   ___/ / /___  / / / /_/ / ____/
    echo               \____/\____/_/  /_/_/    \____/ /_/ /_____/_/ ^|_^|   /____/_____/ /_/  \____/_/
    echo                                                                                                 [92mBy ESCEMI[0m
    echo               ====================================================================================
    echo.
    echo.
    exit /b

:section
    echo.
    echo.
    echo  [93m[ [4m%~1[0m[93m ][0m
    echo.
    exit /b

:waiting
    echo.
    call :processing %1
    pause >nul
    exit /b


:processing
    set "message=%~1"
    set "message=[94m^>^>^>[0m %message%..."
    echo %message%&exit /b

:success
    set "message=%~1"
    set "message=[92m[x][0m %message%!"
    echo %message%&exit /b

:error
    set "message=%~1"
    set "message=[91m/^^!^\ %message% [0m"
    echo.&echo %message%&echo.
    echo Press any key to exit...
    pause >nul
    goto :halt

:prompt
    echo.
    set "question=[94m?>[0m %~1"
    set /P userAnswer=^!question^!
    exit /b 0

:confirmPrompt
    setlocal EnableDelayedExpansion

    set "default="
    if "%2"=="" (
        set default="y"
    ) else if "%2"=="y" (
        set default="y"
    ) else if "%2"=="Y" (
        set default="y"
    ) else (
        set default="n"
    )

    if !default!=="y" (
        set "question=%~1 ([97m[Y][0m/n)? "
    ) else (
        set "question=%~1 ([y/[97m[N][0m)? "
    )

    set userAnswer=
    call :prompt "^!question^!"

    set "answer="
    if "!userAnswer!"=="" (
        set answer=!default!
    ) else if "!userAnswer!"=="y" (
        set answer="y"
    ) else if "!userAnswer!"=="Y" (
        set answer="y"
    ) else if "!userAnswer!"=="n" (
        set answer="n"
    ) else if "!userAnswer!"=="N" (
        set answer="n"
    )

    if !answer!=="y" (
        set "response=-> Yes"
        echo !response!
        echo.
        endLocal
        exit /b 0
    ) else if !answer!=="n" (
        set "response=-> No"
        echo !response!
        echo.
        endLocal
        exit /b 4
    )
    endLocal
    call :confirmPrompt %1 %2
    exit /b %ERRORLEVEL%

:cmdExists
    setlocal EnableDelayedExpansion

    set command=%~1

    where ^!command^! >nul 2>nul

    endLocal
    exit /b %ERRORLEVEL%

:execCmd
    @echo off
    setlocal EnableDelayedExpansion

    set "command=%~1"

    !command!
    if !ERRORLEVEL! neq 0 (
        endLocal
        echo Press any key to exit...
        pause >nul
        goto :halt
    )
    endLocal
    exit /b

:execPowershellCmd
    @echo off
    setlocal EnableDelayedExpansion

    powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command %1
    if !ERRORLEVEL! neq 0 (
        endLocal
        echo Press any key to exit...
        pause >nul
        goto :halt
    )

    endLocal
    exit /b

:halt
call :haltHelper 2> nul

:haltHelper
()
exit /b