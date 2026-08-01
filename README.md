# Termux Ready

Termux Ready is a script that makes it easy to set up Termux. It installs and customizes zsh, Oh My Zsh, fira-code font, Agnoster theme, rxfetch, extra-keys, ZSH Syntax Highlighting, openssh and termux-api.

## Prerequisites

To use this script, you need to have Termux installed on your Android device. 

You can find information about Termux [here](https://termux.dev/en/).

## Installation

To install Termux Ready, follow these steps:

- Open Termux and update the packages with the commands:

```bash
pkg update
pkg upgrade -y
```
- Download the script from GitHub with the command:

```bash
curl https://raw.githubusercontent.com/felipearc13/termux-term-ready/main/install.sh && chmod +x install.sh && ./install.sh
```

- Follow the instructions on the screen and enter the password you want to use for openssh.
- Wait for the script to finish and restart Termux.
- Done, you installed Termux Ready and can enjoy your customized terminal.

## Optional: LAMP + WordPress

`lamp_wordpress.sh` is a separate, optional script (not called by `install.sh`) that sets up
PHP, MariaDB, Apache and a fresh WordPress install inside Termux:

```bash
curl https://raw.githubusercontent.com/felipearc13/termux-term-ready/main/lamp_wordpress.sh && chmod +x lamp_wordpress.sh && ./lamp_wordpress.sh
```

It generates a random database password on each run and prints it once at the end — copy it
right away, it's needed for `wp-config.php` during the WordPress setup.
