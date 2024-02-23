#!/data/data/com.termux/files/usr/bin/bash

# Stop the script if any error occurs
set -e

# Create variables for the file paths
export HOME_DIR="$HOME"
export BACKUP_DIR="$HOME_DIR/backup"
export TERMUX_DIR="$HOME_DIR/.termux"
export ZSH_DIR="$HOME_DIR/.oh-my-zsh"
export ZSH_THEME="$ZSH_DIR/themes/agnoster.zsh-theme"
export ZSH_CONFIG="$HOME_DIR/.zshrc"
export TERMUX_CONFIG="$TERMUX_DIR/termux.properties"
export ZSH_SYNTAX="$HOME_DIR/.zsh-syntax-highlighting"

# Function to install the packages
install_packages() {
  echo "Installing the packages..."
  pkg install -y neovim vim python zsh termux-api termux-tools rxfetch wget git expect openssh termux-auth
}

# Function to set zsh as the default shell
set_zsh() {
  echo "Setting zsh as the default shell..."
  chsh -s zsh
}

# Function to install Oh My Zsh
install_oh_my_zsh() {
  echo "Installing Oh My Zsh..."
  wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O install_oh_my_zsh.sh
  sh install_oh_my_zsh.sh < /dev/null
  rm install_oh_my_zsh.sh
}

# Function to install the fira-code font
install_fira_code() {
  echo "Installing the fira-code font..."
  git clone https://github.com/notflawffles/termux-nerd-installer.git
  cd termux-nerd-installer
  make install
  termux-nerd-installer i fira-code
  termux-nerd-installer set fira-code
  cd $HOME_DIR
  rm -rf termux-nerd-installer
}

# Function to set Agnoster as the default theme
set_agnoster() {
  echo "Setting Agnoster as the default theme..."
  mkdir -p "$BACKUP_DIR"
  cp "$ZSH_THEME" "$BACKUP_DIR/agnoster.zsh-theme"
  sed -i 's/@%m//' "$ZSH_THEME"
  sed -i 's/ZSH_THEME=.*/ZSH_THEME="agnoster"/' "$ZSH_CONFIG"
}

# Function to modify the startup message by rxfetch
set_rxfetch() {
  echo "Modifying the startup message by rxfetch..."
  echo -e "\nrxfetch" >> "$ZSH_CONFIG"
}

# Function to add extra-keys
add_extra_keys() {
  echo "Adding extra-keys..."
  mv "$TERMUX_CONFIG" "$BACKUP_DIR/termux.properties"
  wget https://raw.githubusercontent.com/felipearc13/termux-ready/master/termux.properties -P "$TERMUX_DIR/"
}

# Function to clone the ZSH Syntax Highlighting
clone_zsh_syntax() {
  echo "Cloning the ZSH Syntax Highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX" --depth 1
  echo "source $ZSH_SYNTAX/zsh-syntax-highlighting.zsh" >> "$ZSH_CONFIG"
}

# Function to restart the shell
restart_shell() {
  echo "Restarting the shell..."
  exec zsh
}

# Function to set the openssh password
set_ssh_password() {
  echo "Setting the openssh password..."
  passwd termux
  echo -e "\nsshd" >> "$ZSH_CONFIG"
}

# Function to access the cell phone memory
setup_storage() {
  echo "Accessing the cell phone memory..."
  termux-setup-storage
}

# Function to clean up the temporary files
cleanup() {
  echo "Cleaning up the temporary files..."
  rm -f install_oh_my_zsh.sh
}

# Function to restore the original settings
#restore() {
#  echo "Restoring the original settings..."
#  cp "$BACKUP_DIR/agnoster.zsh-theme" "$ZSH_THEME"
#  cp "$BACKUP_DIR/termux.properties" "$TERMUX_CONFIG"
#}

# Define actions that should be executed when the script ends or is interrupted
trap cleanup EXIT
trap restore INT

# Execute the functions in sequence
install_packages &&
set_zsh &&
install_oh_my_zsh &&
install_fira_code &&
set_agnoster &&
set_rxfetch &&
add_extra_keys &&
clone_zsh_syntax &&
set_ssh_password &&
setup_storage &&
restart_shell
