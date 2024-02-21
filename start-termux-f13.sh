#!/bin/bash

## Instalando repositorios

pkg update && pkg upgrade -y
pkg install  root-repo unstable-repo x11-repo -y

# Instalação de pacotes
apt install -y neovim neovim python zsh termux-api rxfetch

## Modificando motd

pkg install wget git
mv /data/data/com.termux/files/usr/etc/motd  /data/data/com.termux/files/usr/etc/motd.bkp
wget https://raw.githubusercontent.com/felipearc13/termux-ini-f13/master/motd -P /data/data/com.termux/files/usr/etc/

## Instalando OpenSSH

pkg install openssh termux-auth -y
passwd termux
passwd termux << EOF
061813
061813
EOF

## Instalando FTP

pkg install busybox termux-services -y 
source $PREFIX/etc/profile.d/start-services.sh
sv-enable ftpd

## Instalando tor e torsocks

pkg install tor torsocks -y
mv $PREFIX/etc/tor/torrc $PREFIX/etc/tor/torrc.bkp
wget https://raw.githubusercontent.com/felipearc13/termux-ini-f13/master/torrc -P $PREFIX/etc/tor/
mkdir -p ~/.tor/hidden_ssh
mkdir ~/doc/
wget https://raw.githubusercontent.com/felipearc13/termux-ini-f13/master/info-tor.md -P ~/doc/

## Adicionando extra-keys

mkdir ~/.termux
wget https://raw.githubusercontent.com/felipearc13/termux-ini-f13/master/termux.properties -P ~/.termux/

## Instalando proot-distro

pkg install proot proot-distro -y 

## Graphical Environment

pkg install tigervnc openbox pypanel xorg-xsetroot xfce4-terminal aterm st fltk megatools openbox obconf xterm xfce4-settings polybar libnl geany pcmanfm rofi feh neofetch curl pulseaudio elinks dosbox -y
vncserver
vncserver -kill :1
mv ~/.vnc/xstartup ~/.vnc/xstartup.bkp
wget https://raw.githubusercontent.com/felipearc13/termux-ini-f13/master/xstartup -P ~/.vnc/
chmod +x ~/.vnc/xstartup
mv $PREFIX/etc/xdg/openbox/autostart $PREFIX/etc/xdg/openbox/autostart.bkp
wget https://raw.githubusercontent.com/felipearc13/termux-ini-f13/master/autostart -P $PREFIX/etc/xdg/openbox/
chmod +x $PREFIX/etc/xdg/openbox/autostart

## Instalando zsh

pkg install zsh termux-tools git wget -y
chsh -s zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' .zshrc

# install ZSH Syntax Highlighting for Oh My Zsh

## Clone the ZSH Syntax Highlighting

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1

## Add syntax-highlighting in .zshrc Configuration

echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"

# Configuração do rxfetch na inicialização
echo "rxfetch" >> ~/.zshrc

#Acessa memoria do celular
termux-setup-storage

#Fim
echo Tarefa Completa! Reinicie o Termux...


