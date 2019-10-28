rem Config functions
@echo off

set batdir=%~dp0
set batfile=%0
set defaultConfigDir=%batdir%..\..\config

if "%~1" neq "" (
  2>nul >nul findstr /rc:"^ *:%~1\>" "%~f0" && (
    shift /1
    goto %1
  ) || (
    >&2 call %cliCmd% fatalError "Function %~1 not found in %batfile%"
  )
) else >&2 call %cliCmd% fatalError "No function name was given to %batfile%"
exit /b

:resolveConfigFile
    set configPath=
    setlocal EnableDelayedExpansion
    set "configDir=%~1"
    set "configFile=%~2"    
    set "configPath=!configDir!!configFile!.config"
    if not exist %configPath% (
        set "configPath=!configDir!\!configFile!.config"
    )

    if exist !configPath! (
        set resolvedConfigPath=
        call %cliCmd% resolvePath configPath !configPath! 
    ) else (
        set configPath=
    )

    endLocal & set configPath=%configPath%
    exit /b

:useDefaultConfig
    set configPath=
    setlocal EnableDelayedExpansion
    set "configFile=%~1"
    set "configDir=%defaultConfigDir%"    

    call :resolveConfigFile "^!configDir^!" "^!configFile^!"

    if exist !configPath! (
        set confirmConfig="Do you want to use the default !configFile! configuration"
        
        set errorlevel=
        call %cliCmd% confirmPrompt !confirmConfig!
        if !errorlevel! equ 0 ( 
            endLocal & set configPath=%configPath%
            exit /b
        )
    )
    endLocal & set configPath=
    exit /b

:useConfig
    set configPath=
    setlocal EnableDelayedExpansion
    
    set "configFile=%~1"

    if [%2]==[] (
        call :useDefaultConfig "^!configFile^!"
    ) else (
        set "configDir=%~2"
        call :resolveConfigFile !configDir! !configFile!

        if exist !configPath! (
            set confirmConfig="Do you want to use the configuration file ^!configPath^!"
            set errorlevel=
            call %cliCmd% confirmPrompt !confirmConfig!
            if not !errorlevel! equ 0 (
                set configPath=
            )
        ) else (
            call %cliCmd% info "No configuration file exists for !configFile!"
            set configPath=
        )

        if not defined configPath (
            call :useDefaultConfig "^!configFile^!"
        )
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
        call %cliCmd% resolvePath configPath !configPath!
    )
    endLocal & set configPath="%configPath%"
    exit /b

:resolvePath
    set %1=%~dpfn2
    exit /b