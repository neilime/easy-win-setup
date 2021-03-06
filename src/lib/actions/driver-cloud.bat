rem Driver cloud action functions
@echo off

set batdir=%~dp0
set cliCmd=%batdir%../utils/cli.bat

set driverCloudUrl=https://www.driverscloud.com/plugins/DriversCloud_Win.exe
set driverCloudExe="%programfiles%\DriversCloud.com\DriversCloud.exe"
set driverCloudUninstall="%AllUsersProfile%\Microsoft\Windows\Start Menu\Programs\DriversCloud.com\Desinstaller.lnk"
set tmpDrivercloud="%Tmp%\DriversCloud_Win.exe"

goto execute
exit /b

:execute
    setlocal EnableDelayedExpansion

    for %%X in (%driverCloudExe%) do (set driverCloudFound=%%~$PATH:X)

    if not defined driverCloudFound (
        call %cliCmd% processing "Downloading Driver Cloud"
        call %cliCmd% execPowershellCmd "(New-Object System.Net.WebClient).DownloadFile('%driverCloudUrl%', '^!tmpDrivercloud^!')"
        call %cliCmd% success "Download of Driver Cloud is done"
        call %cliCmd% processing "Installing Driver Cloud"
        call %cliCmd% execCmd "^!tmpDrivercloud^! /S /qn"
        call %cliCmd% success "Installation of Driver Cloud is done"
    ) else (
        call %cliCmd% processing "Executing Driver cloud"
        call %cliCmd% execCmd "^!driverCloudExe^! /DETECT"
        call %cliCmd% success "Execution of Driver Cloud is done"
    )

    call %cliCmd% waiting "When you are done with updating your drivers, press any key to continue"

    echo.
    call %cliCmd% processing "Uninstalling Driver Cloud"
    rem Delete tmp file
    if exist "%tmpDrivercloud%" (
        call %cliCmd% execCmd "del /F /Q %tmpDrivercloud%"
    )

    rem uninstall driver cloud
    call %cliCmd% execCmd "^!driverCloudUninstall^! /quiet"
    call %cliCmd% success "Uninstallation of Driver Cloud is done"

    endlocal
    exit /b