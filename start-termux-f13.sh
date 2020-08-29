#!/bin/bash

## Instalando repositorios

pkg update && pkg upgrade -y
pkg install  root-repo unstable-repo x11-repo -y

## Modificando motd

pkg install wget git
mv /data/data/com.termux/files/usr/etc/motd  /data/data/com.termux/files/usr/etc/motd.bkp
wget https://raw.githubusercontent.com/felipearc13/termux-ini-f13/master/motd -P /data/data/com.termux/files/usr/etc/

## Instalando OpenSSH

pkg install openssh termux-auth -y
passwd termux

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

## Instalando vim

pkg insttall vim -y

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

pkg install zsh
termux-tools zsh -y
chsh -s $(which zsh)
curl -Lo install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
sh install.sh

#Acessa memoria do celular
termux-setup-storage

#Fim
echo Tarefa Completa! Reinicie o Termux...


