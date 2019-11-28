rem Dev action functions
@echo off

set batdir=%~dp0
set batfile=%0
set cliCmd=%batdir%../utils/cli.bat
set configCmd=%batdir%../utils/config.bat

goto execute
exit /b

:execute
  setlocal EnableDelayedExpansion
  
  rem Add npm global packages if npm is available
  set errorlevel=
  call :npmExists
  if !errorlevel! equ 0 (

      set errorlevel=
      call %cliCmd% confirmPrompt "Do you want to clean (uninstall) all existing npm global packages"
      if %errorlevel% equ 0 (
          call :uninstallGlobalNpmPackages
          refreshenv
      )

      set errorlevel=
      call %cliCmd% confirmPrompt "Do you want to install npm global packages"
      if !errorlevel! equ 0 (
          call :installGlobalNpmPackages %1
      )
  )

  rem configure VSCode if installed
  set errorlevel=
  call :vscodeExists
  if !errorlevel! equ 0 (
      set errorlevel=
      call %cliCmd% confirmPrompt "Do you want to configure vscode"
      if !errorlevel! equ 0 (
          call :configureVSCode
      )
  )

  endlocal
  exit /b

:npmExists
    setlocal EnableDelayedExpansion
    set errorlevel=
    call %cliCmd% cmdExists  "npm.cmd"
    set npmExists=!errorlevel!
    set errorlevel=

    endLocal
    exit /b %npmExists%

:uninstallGlobalNpmPackages
    setlocal EnableDelayedExpansion

    call %cliCmd% processing "Uninstalling all NPM global packages"

    call %cliCmd% execCmd "rmdir /s /q %appdata%\npm"
    call %cliCmd% safeMkdir "%appdata%\npm"

    call %cliCmd% execCmd "rmdir /s /q %appdata%\npm-cache"
    call %cliCmd% safeMkdir "%appdata%\npm-cache"

    call %cliCmd% success "Uninstalling all NPM global packages is done"

    endlocal
    exit /b

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

    endlocal
    exit /b

:vscodeExists
    setlocal EnableDelayedExpansion
    set errorlevel=
    call %cliCmd% cmdExists "code"
    set vscodeExists=!errorlevel!
    set errorlevel=
    endLocal
    exit /b %vscodeExists%

:configureVSCode
    setlocal EnableDelayedExpansion

    call %cliCmd% processing "Configure VSCode"
    call %cliCmd% execCmd "code --install-extension Shan.code-settings-sync --force" >nul
    call %cliCmd% success "Configuration of VSCode is done"

    endlocal
    exit /b
