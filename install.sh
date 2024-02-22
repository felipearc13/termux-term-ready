#!/data/data/com.termux/files/usr/bin/bash

# Instalar pacotes sem interação
pkg install -y neovim vim python zsh termux-api termux-tools rxfetch wget git expect openssh termux-auth

# Definir Zsh como o shell padrão
chsh -s zsh

# Excluir a pasta ~/.oh-my-zsh se existir
if [ -d "$HOME/.oh-my-zsh" ]; then
    rm -rf "$HOME/.oh-my-zsh"
fi

# Baixar o script de instalação do Oh My Zsh
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O install_oh_my_zsh.sh

# Executar o script de instalação do Oh My Zsh com redirecionamento de entrada
sh install_oh_my_zsh.sh < /dev/null

# Excluir o script de instalação do Oh My Zsh
rm install_oh_my_zsh.sh

# Voltar para o diretório inicial
cd $HOME

# Instalar fonte meslo
git clone https://github.com/notflawffles/termux-nerd-installer.git
cd termux-nerd-installer
make install
termux-nerd-installer i meslo
termux-nerd-installer set meslo

# Instalar o tema Powerlevel10k sem interação
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
wget https://raw.githubusercontent.com/felipearc13/termux-ini-f13/master/.p10k.zsh -P $HOME/ 

# Configurar o tema Powerlevel10k como tema padrão
sed -i 's/ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' $HOME/.zshrc
 

# Adicionando extra-keys
mkdir ~/.termux
wget https://raw.githubusercontent.com/felipearc13/termux-ini-f13/master/termux.properties -P ~/.termux/

## Clone the ZSH Syntax Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1
echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"



# Reiniciar o shell para aplicar as alterações
exec zsh

# Definir a senha do openssh
passwd termux
sshd

#Acessa memoria do celular
termux-setup-storage