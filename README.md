<p align="center">
  <a href="https://github.com/neilime/easy-win-setup" target="_blank"><img src="resources/banner.jpg" width="600"></a>
  <br/><br/>
</p>

# Summary

📢 Portable utility to setup and configure Windows

# Contributing

👍 If you wish to contribute to this project, don't hesitate, I'll review any PR.

# Get started

1. Run the following command in a `cmd` shell:

```cmd
powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://github.com/neilime/easy-win-setup/releases/latest/download/install.ps1'))"
```
2. A few seconds later, EasyWinSetup should be running. All you have to do is follow its questions

# Download

📥 https://github.com/neilime/easy-win-setup/releases

# Features

## Configuration

By default these [configuration files](src/config) are used

You can provide configuration directory to you your custom configuration files.
To be used, these files must have the same name & format as default configuration files 

For each features requiring a configuration file, you can choose which file you want to use.

## Drivers update

Helping to updtate drivers through [Driver cloud](https://www.driverscloud.com/)

## Win10-Initial-Setup-Script 

Executes [Win10-Initial-Setup-Script](https://github.com/Disassembler0/Win10-Initial-Setup-Script/) with given [config](src/config/initial-setup.config)

## Uninstall useless softwares

Helping to uninstall useless softwares

## Delete useless startup entries

Helping to delete useless startup entries

## Chocolatey installation

* Installs [Chocolatey](https://chocolatey.org/).
* Installs Chocolatey packages from given [package config](src/config/chocolatey.config). \
Docs for packages config format: https://chocolatey.org/docs/commandsinstall#packagesconfig.

## Customization of UI

### Create desktop folders

Creates some desktop folders (for tidying up) from given [config](src/config/desktop-folders.config)

### Creates desktop "Maintenance" shortcut

Creates a shortcup that execute:
- [Chocolatey upgrade](https://chocolatey.org/docs/commands-upgrade)
- [CCleaner](https://www.ccleaner.com) auto clean, if installed
- [npm-check](https://www.npmjs.com/package/npm-check) interactive update, if installed

## Dev configuration

### Configure VSCode if installed

- Install extension [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync)

### Install npm global packages

If npm is available, global npm packages are installed from given [config](src/config/npm.config) 

## Run CCleaner if available

## Restart explorer
