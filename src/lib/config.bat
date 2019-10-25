rem Config functions
@echo off

set batdir=%~dp0
set batfile=%0
set defaultConfigDir=%batdir%..\config

if "%~1" neq "" (
  2>nul >nul findstr /rc:"^ *:%~1\>" "%~f0" && (
    shift /1
    goto %1
  ) || (
    >&2 call %cliCmd% fatalError "Function %~1 not found in %batfile%"
  )
) else >&2 call %cliCmd% fatalError "No function name was given to %batfile%"
exit /b


:useConfig
    set configPath=
    setlocal EnableDelayedExpansion
    
    set "configFile=%~1"

    if [%2]==[] (
        set "configDir=%defaultConfigDir%"
        set isDefaultConfig=1
    ) else (
        set "configDir=%~2"
        set isDefaultConfig=
    )

    set "configPath=!configDir!!configFile!.config"
    if not exist !configPath! (
        set "configPath=!configDir!\!configFile!.config"
    )

    if exist !configPath! (
        if defined isDefaultConfig (
            set confirmConfig="Do you want to use the default !configFile! configuration"
        ) else (
            set confirmConfig="Do you want to use the configuration file ^!configPath^!"
        )
        
        set errorlevel=
        call %cliCmd% confirmPrompt !confirmConfig!
        if not %errorlevel% equ 0 (
            set configPath=
        )
    ) else (
        set configPath=
    )

    if not defined configPath (
        set userAnswer=
        call %cliCmd% filePrompt "Please give the !configFile! config path"
        if "%userAnswer%" == "" (
            call %cliCmd% info "No !configFile! config path given"
            endlocal
            exit /b
        )
        set "configPath=%userAnswer%"
    )
    endLocal & set configPath=%configPath%
    call %cliCmd% resolvePath configPath %configPath%
    set configPath="%configPath%"
    exit /b

:resolvePath
    set %1=%~dpfn2
    exit /b