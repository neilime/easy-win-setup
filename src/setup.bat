@echo off
cls

set batdir=%~dp0
set cliCmd=%batdir%lib\cli.bat
set initialSetup=%batdir%lib\initial-setup.bat
set optimizerCmd=%batdir%lib\optimizer.bat
set cleanerCmd=%batdir%lib\cleaner.bat
set driverCloudCmd=%batdir%lib\driver-cloud.bat
set chocolateyCmd=%batdir%lib\chocolatey.bat
set interfaceCmd=%batdir%lib\interface.bat
set nodejsCmd=%batdir%lib\nodejs.bat
set vscodeCmd=%batdir%lib\vscode.bat

rem Print banner
call %cliCmd% banner

set userAnswer=
call %cliCmd% dirPrompt "If you want to use a custom configuration, please give the configuration directory path"
if "%userAnswer%" == "" (
    call %cliCmd% info "No custom configuration path given, default configuration will be used"
    set configDir=
) else (
    set configDir=%userAnswer%
    call %cliCmd% info "Custom configuration '%userAnswer%' will be used"
)

rem Drivers update
call %cliCmd% section "Drivers update"

rem Run Driver Cloud update
set errorlevel=
call %cliCmd% confirmPrompt "You should update your drivers, do you want to run Driver Cloud"
if %errorlevel% equ 0 (
    call %driverCloudCmd% executeDriverCloud
)

rem Execute initial setup
set errorlevel=
call %cliCmd% confirmPrompt "Do you want to execute initial setup"
if %errorlevel% equ 0 (
    call %initialSetup% executeInitialSetup %configDir%
)

rem Execute optimizer
rem call %cliCmd% section "Optimizer"
rem set errorlevel=
rem call %cliCmd% confirmPrompt "Do you want to execute Optimizer"
rem if %errorlevel% equ 0 (
rem     call %optimizerCmd% executeOptimizer
rem )

call %cliCmd% section "Cleaner"

rem Uninstall useless softwares
set errorlevel=
call %cliCmd% confirmPrompt "Do you want to uninstall softwares"
if %errorlevel% equ 0 (
    call %cleanerCmd% uninstallSoftwares
)
rem Uninstall useless startup entries
set errorlevel=
call %cliCmd% confirmPrompt "Do you want to delete startup entries"
if %errorlevel% equ 0 (
    call %cleanerCmd% deleteStartupEntries
)

rem Run Chocolatey install
call %cliCmd% section "Package manager (Chocolatey)"
set errorlevel=
call %cliCmd% confirmPrompt "Do you want to install Chocolatey packages"
if %errorlevel% equ 0 (
    call %chocolateyCmd% executeChocolatey %configDir%
)

rem Customization of UI
call %cliCmd% section "Customize interface"

rem Create desktop folders
set errorlevel=
call %cliCmd% confirmPrompt "Do you want to create desktop folders"
if %errorlevel% equ 0 (
    call %interfaceCmd% createDesktopDirFolders %configDir%
)

rem Create desktop "Maintenance" shortcut
set errorlevel=
call %cliCmd% confirmPrompt "Do you want to create a 'Maintenance' shortcut"
if %errorlevel% equ 0 (
    call %interfaceCmd% createMaintenanceShortcut
)

call %cliCmd% section "Dev configuration"

rem configure VSCode
set errorlevel=
call %vscodeCmd% vscodeExists
if %errorlevel% equ 0 (

    set errorlevel=
    call %cliCmd% confirmPrompt "Do you want to configure VSCode"
    if %errorlevel% equ 0 (
        call %vscodeCmd% configureVSCode
    )
)

rem Add npm global packages if npm is available
set errorlevel=
call %nodejsCmd% npmExists
if %errorlevel% equ 0 (

    set errorlevel=
    call %cliCmd% confirmPrompt "Do you want to install npm global packages"
    if %errorlevel% equ 0 (
        call %nodejsCmd% installGlobalNpmPackages %configDir%
    )
)

rem Run CCleaner if available
call %cleanerCmd% executeCCleaner

rem restart explorer
call %interfaceCmd% restartExplorer

rem End of setup
echo.
echo ==============================================================================
echo ================                 [92mSetup is done[0m                ================
echo ==============================================================================
echo.
echo.

pause
exit /b 0