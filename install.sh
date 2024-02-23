#!/data/data/com.termux/files/usr/bin/bash

# Parar o script se ocorrer algum erro
set -e

# Criar variáveis para os caminhos dos arquivos
export HOME_DIR="$HOME"
export BACKUP_DIR="$HOME_DIR/backup"
export TERMUX_DIR="$HOME_DIR/.termux"
export ZSH_DIR="$HOME_DIR/.oh-my-zsh"
export ZSH_THEME="$ZSH_DIR/themes/agnoster.zsh-theme"
export ZSH_CONFIG="$HOME_DIR/.zshrc"
export TERMUX_CONFIG="$TERMUX_DIR/termux.properties"
export ZSH_SYNTAX="$HOME_DIR/.zsh-syntax-highlighting"

# Função para instalar os pacotes
install_packages() {
  echo "Instalando os pacotes..."
  pkg install -y neovim vim python zsh termux-api termux-tools rxfetch wget git expect openssh termux-auth
}

# Função para definir o zsh como o shell padrão
set_zsh() {
  echo "Definindo o zsh como o shell padrão..."
  chsh -s zsh
}

# Função para instalar o Oh My Zsh
install_oh_my_zsh() {
  echo "Instalando o Oh My Zsh..."
  wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O install_oh_my_zsh.sh
  sh install_oh_my_zsh.sh < /dev/null
  rm install_oh_my_zsh.sh
}

# Função para instalar a fonte fira-code
install_fira_code() {
  echo "Instalando a fonte fira-code..."
  git clone https://github.com/notflawffles/termux-nerd-installer.git
  cd termux-nerd-installer
  make install
  termux-nerd-installer i fira-code
  termux-nerd-installer set fira-code
  cd $HOME_DIR
  rm -rf termux-nerd-installer
}

# Função para definir o tema Agnoster como padrão
set_agnoster() {
  echo "Definindo o tema Agnoster como padrão..."
  mkdir -p "$BACKUP_DIR"
  cp "$ZSH_THEME" "$BACKUP_DIR/agnoster.zsh-theme"
  sed -i 's/@%m//' "$ZSH_THEME"
  sed -i 's/ZSH_THEME=.*/ZSH_THEME="agnoster"/' "$ZSH_CONFIG"
}

# Função para modificar a mensagem de inicialização por rxfetch
set_rxfetch() {
  echo "Modificando a mensagem de inicialização por rxfetch..."
  echo -e "\nrxfetch" >> "$ZSH_CONFIG"
}

# Função para adicionar extra-keys
add_extra_keys() {
  echo "Adicionando extra-keys..."
  cp "$TERMUX_CONFIG" "$BACKUP_DIR/termux.properties"
  wget https://raw.githubusercontent.com/felipearc13/termux-ini-f13/master/termux.properties -P "$TERMUX_DIR/"
}

# Função para clonar o ZSH Syntax Highlighting
clone_zsh_syntax() {
  echo "Clonando o ZSH Syntax Highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX" --depth 1
  echo "source $ZSH_SYNTAX/zsh-syntax-highlighting.zsh" >> "$ZSH_CONFIG"
}

# Função para reiniciar o shell
restart_shell() {
  echo "Reiniciando o shell..."
  exec zsh
}

# Função para definir a senha do openssh
set_ssh_password() {
  echo "Definindo a senha do openssh..."
  passwd termux
  echo -e "\nsshd" >> "$ZSH_CONFIG"
}

# Função para acessar a memória do celular
setup_storage() {
  echo "Acessando a memória do celular..."
  termux-setup-storage
}

# Função para limpar os arquivos temporários
cleanup() {
  echo "Limpando os arquivos temporários..."
  rm -f install_oh_my_zsh.sh
}

# Função para restaurar as configurações originais
#restore() {
#  echo "Restaurando as configurações originais..."
#  cp "$BACKUP_DIR/agnoster.zsh-theme" "$ZSH_THEME"
#  cp "$BACKUP_DIR/termux.properties" "$TERMUX_CONFIG"
#}

# Definir ações que devem ser executadas quando o script terminar ou for interrompido
trap cleanup EXIT
trap restore INT

# Executar as funções em sequência
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