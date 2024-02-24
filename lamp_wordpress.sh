#!/data/data/com.termux/files/usr/bin/bash

# Instalar pacotes
pkg install -y php mariadb apache2 php-apache wget

# Editar o arquivo httpd.conf
sed -i 's/#LoadModule mpm_prefork_module libexec\/apache2\/mod_mpm_prefork.so/LoadModule mpm_worker_module libexec\/apache2\/mod_mpm_worker.so/' $PREFIX/etc/apache2/httpd.conf
sed -i '/LoadModule rewrite_module libexec\/apache2\/mod_rewrite.so/a LoadModule php_module /data/data/com.termux/files/usr/libexec/apache2/libphp.so' $PREFIX/etc/apache2/httpd.conf
sed -i 's/AllowOverride None/AllowOverride FileInfo/' $PREFIX/etc/apache2/httpd.conf
sed -i 's/<IfModule dir_module>/&\n  DirectoryIndex index.php\n/' $PREFIX/etc/apache2/httpd.conf
sed -i 's/index.html/index.php/' $PREFIX/etc/apache2/httpd.conf
sed -i '/<FilesMatch \\.php$/a SetHandler application\/x-httpd-php' $PREFIX/etc/apache2/httpd.conf

# Criar arquivo php.ini
echo "upload_max_filesize = 32M" > $PREFIX/lib/php.ini
echo "post_max_size = 32M" >> $PREFIX/lib/php.ini

# Iniciar MariaDB e conceder privilégios
mysqld_safe &
sleep 5
mysql -u root -e "CREATE DATABASE wordpress; GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY '061813'; FLUSH PRIVILEGES;"

# Backup e instalação do WordPress
mv -r $PREFIX/share $HOME/share_bkp
mkdir -p $PREFIX/share
wget https://wordpress.org/latest.tar.gz -O $PREFIX/share/latest.tar.gz
tar -xzvf $PREFIX/share/latest.tar.gz -C $PREFIX/share --strip-components=1

# Iniciar MariaDB e Apache automaticamente no boot
echo -e "#!/data/data/com.termux/files/usr/bin/bash\nmysqld_safe &\nsleep 5\nhttpd" > $PREFIX/bin/termux_boot_script
chmod +x $PREFIX/bin/termux_boot_script
termux-reload-settings
