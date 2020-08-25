#Inicie o tor
tor

#Enderço de acesso em 
cat ~/.tor/hidden_ssh/hostname

#Acesso no cliente 
#Instalar e ativar tor e torsocks
pkg install tor torsocks -y
mv $PREFIX/etc/tor/torrc $PREFIX/etc/tor/torrc.bkp
wget https://raw.githubusercontent.com/felipearc13/termux-ini-f13/master/torrc -P $PREFIX/etc/tor/
mkdir -p ~/.tor/hidden_ssh

torsocks ssh xxx.onion
