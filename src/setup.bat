@echo off
cls

set batdir=%~dp0
set cliCmd=%batdir%lib\cli.bat
set cleanerCmd=%batdir%lib\cleaner.bat
set driverCloudCmd=%batdir%lib\driver-cloud.bat
set chocolateyCmd=%batdir%lib\chocolatey.bat
set interfaceCmd=%batdir%lib\interface.bat
set nodejsCmd=%batdir%lib\nodejs.bat
set vscodeCmd=%batdir%lib\vscode.bat

rem Print banner
call %cliCmd% banner

rem Drivers update
call %cliCmd% section "Drivers update"

rem Run Driver Cloud update
call %cliCmd% confirmPrompt "You should update your drivers, do you want to run Driver Cloud"
if !ERRORLEVEL! equ 0 (
    call %driverCloudCmd% executeDriverCloud
)

call %cliCmd% section "Cleaner"

rem Uninstall useless softwares
call %cliCmd% confirmPrompt "Do you want to uninstall softwares"
if !ERRORLEVEL! equ 0 (
    call %cleanerCmd% uninstallSoftwares
)
rem Uninstall useless startup entries
call %cliCmd% confirmPrompt "Do you want to delete startup entries"
if !ERRORLEVEL! equ 0 (
    call %cleanerCmd% deleteStartupEntries
)

rem Run Chocolatey install
call %cliCmd% section "Package manager (Chocolatey)"
call %cliCmd% confirmPrompt "Do you want to install Chocolatey packages"
if !ERRORLEVEL! equ 0 (
    call %chocolateyCmd% executeChocolatey
)

rem Customization of UI
call %cliCmd% section "Customize interface"

rem Dark mode
call %cliCmd% confirmPrompt "Do you want to enable Dark mode"
if !ERRORLEVEL! equ 0 (
    call %interfaceCmd% enableDarkMode
)

rem Display of file extensions
call %cliCmd% confirmPrompt "Do you want to enable the display of file extensions"
if !ERRORLEVEL! equ 0 (
    call %interfaceCmd% enableDisplayFileExtensions
)

rem Create desktop folders
call %cliCmd% confirmPrompt "Do you want to create desktop folders"
if !ERRORLEVEL! equ 0 (
    call %interfaceCmd% createDesktopDirFolders
)

rem Create desktop "Maintenance" shortcut
call %cliCmd% confirmPrompt "Do you want to create a 'Maintenance' shortcut"
if !ERRORLEVEL! equ 0 (
    call %interfaceCmd% createMaintenanceShortcut
)

call %cliCmd% section "Dev configuration"

rem configure VSCode
call %vscodeCmd% vscodeExists
if !ERRORLEVEL! equ 0 (
    call %cliCmd% confirmPrompt "Do you want to configure VSCode"
    if !ERRORLEVEL! equ 0 (
        call %vscodeCmd% configureVSCode
    )
)

rem Add npm global packages if npm is available
call %nodejsCmd% npmExists
if !ERRORLEVEL! equ 0 (
    call %cliCmd% confirmPrompt "Do you want to install npm global packages"
    if !ERRORLEVEL! equ 0 (
        call %nodejsCmd% installGlobalNpmPackages
    )
)

rem Run CCleaner if available
call %cleanerCmd% executeCCleaner

rem restart explorer
rem call %interfaceCmd% restartExplorer

rem End of setup
echo.
echo ==============================================================================
echo ================                 [92mSetup is done[0m                ================
echo ==============================================================================
echo.
echo.

pause
exit /b 0