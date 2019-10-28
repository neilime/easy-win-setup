@echo off
cls

set batdir=%~dp0
set cliCmd=%batdir%lib\utils\cli.bat
set initialSetup=%batdir%lib\actions\initial-setup.bat
set optimizerCmd=%batdir%lib\actions\optimizer.bat
set cleanerCmd=%batdir%lib\actions\cleaner.bat
set driverCloudCmd=%batdir%lib\actions\driver-cloud.bat
set chocolateyCmd=%batdir%lib\actions\chocolatey.bat
set interfaceCmd=%batdir%lib\actions\interface.bat
set devCmd=%batdir%lib\actions\dev.bat

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
    call %driverCloudCmd%
)

rem Execute initial setup
set errorlevel=
call %cliCmd% confirmPrompt "Do you want to execute initial setup"
if %errorlevel% equ 0 (
    call %initialSetup% %configDir%
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
    call %chocolateyCmd% %configDir%
)

rem Customization of UI
call %cliCmd% section "Customize interface"
call %interfaceCmd%

rem Dev configuration
call %cliCmd% section "Dev configuration"
call %devCmd%

rem Run CCleaner if available
call %cleanerCmd% executeCCleaner

rem restart explorer
call %cliCmd% restartExplorer

rem End of setup
echo.
echo ==============================================================================
echo ================                 [92mSetup is done[0m                ================
echo ==============================================================================
echo.
echo.

pause
exit /b 0