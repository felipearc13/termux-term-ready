#!/bin/bash

#Instalando repositorios
pkg update -y && pkg upgrade -y
pkg install  root-repo unstable-repo x11-repo -y
pkg update -y && pkg upgrade -y

#Instalando OpenSSH
pkg update -y && pkg upgrade -y
pkg install openssh termux-auth -y

#Instalando FTP
pkg update -y && pkg upgrade -y
pkg install busybox termux-services -y 
source $PREFIX/etc/profile.d/start-services.sh

#Ativando FTP
sv-enable ftpd
sv up ftpd

#Instalando tor e torsocks
pkg update -y && pkg upgrade -y
pkg install tor torsocks -y
mv $PREFIX/etc/tor/torrc $PREFIX/etc/tor/torrc.bkp
wget https://raw.githubusercontent.com/felipearc13/termux-ini-f13/master/torrc -P $PREFIX/etc/tor/
mkdir -p ~/.tor/hidden_ssh
mkdir ~/doc/
wget https://raw.githubusercontent.com/felipearc13/termux-ini-f13/master/info-tor.md -P ~/doc/

#Adicionando extra-keys
pkg update -y && pkg upgrade -y
pkg install git raw -y
mkdir ~/.termux
wget https://raw.githubusercontent.com/felipearc13/termux-ini-f13/master/termux.properties -P ~/.termux/

#Instalando vim
pkg update -y && pkg upgrade -y
pkg insttall vim -y

#Instalando Ubuntu
pkg update -y && pkg upgrade -y
pkg install proot proot-distro -y 
proot-distro install ubuntu

#Instalando zsh
pkg update -y && pkg upgrade -y
pkg install zsh -y 
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended


#Modificando motd
mv /data/data/com.termux/files/usr/etc/motd  /data/data/com.termux/files/usr/etc/motd.bkp
wget https://raw.githubusercontent.com/felipearc13/termux-ini-f13/master/motd -P /data/data/com.termux/files/usr/etc/



#Graphical Environment
pkg update -y && pkg upgrade -y
pkg install tigervnc openbox pypanel xorg-xsetroot xfce4-terminal aterm st fltk megatools openbox obconf xterm xfce4-settings polybar libnl geanypcmanfm rofi feh neofetch curl pulseaudio elinks dosbox -y
vncserver
123456
123456
-n
vncserver -kill :1
mv ~/.vnc/xstartup ~/.vnc/xstartup.bkp
wget https://raw.githubusercontent.com/felipearc13/termux-ini-f13/master/xstartup -P ~/.vnc/
chmod +x ~/.vnc/xstartup
mv $PREFIX/etc/xdg/openbox/autostart $PREFIX/etc/xdg/openbox/autostart.bkp
wget https://raw.githubusercontent.com/felipearc13/termux-ini-f13/master/autostart -P $PREFIX/etc/xdg/openbox/
chmod +x $PREFIX/etc/xdg/openbox/autostart

#Acessa memoria do celular
termux-setup-storage

#Fim
echo Tarefa Completa! Reinicie o Termux...


