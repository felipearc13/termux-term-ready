#!/data/data/com.termux/files/usr/bin/bash

set -Eeuo pipefail

# Instalar pacotes
pkg install -y php mariadb apache2 php-apache wget openssl-tool

HTTPD_CONFIG="$PREFIX/etc/apache2/httpd.conf"
PHP_CONFIG="$PREFIX/etc/php/php.ini"
DOCUMENT_ROOT="$PREFIX/share/apache2/default-site/htdocs"

# Editar o arquivo httpd.conf
sed -i \
  -e 's|^#LoadModule mpm_prefork_module|LoadModule mpm_prefork_module|' \
  -e 's|^LoadModule mpm_worker_module|#LoadModule mpm_worker_module|' \
  -e 's|DirectoryIndex index.html|DirectoryIndex index.php index.html|' \
  "$HTTPD_CONFIG"

if ! grep -q '^LoadModule php_module ' "$HTTPD_CONFIG"; then
  sed -i '/LoadModule rewrite_module/a LoadModule php_module libexec/apache2/libphp.so' "$HTTPD_CONFIG"
fi

if ! grep -q '^<FilesMatch "\\.php\$">' "$HTTPD_CONFIG"; then
  sed -i '/<IfModule mime_module>/i <FilesMatch "\\.php$">\n    SetHandler application/x-httpd-php\n</FilesMatch>\n' "$HTTPD_CONFIG"
fi

sed -i '/<Directory "\/data\/data\/com.termux\/files\/usr\/share\/apache2\/default-site\/htdocs">/,/<\/Directory>/ s/AllowOverride None/AllowOverride FileInfo/' "$HTTPD_CONFIG"

# Criar arquivo php.ini
mkdir -p "$(dirname "$PHP_CONFIG")"
printf '%s\n' \
  'upload_max_filesize = 32M' \
  'post_max_size = 32M' > "$PHP_CONFIG"

# Iniciar MariaDB e conceder privilégios
mysqld_safe &
sleep 5
WORDPRESS_DB_PASSWORD=$(openssl rand -hex 24)
mysql -u root -e "CREATE DATABASE IF NOT EXISTS wordpress; CREATE USER IF NOT EXISTS 'wordpress'@'localhost' IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'; ALTER USER 'wordpress'@'localhost' IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'; GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost'; FLUSH PRIVILEGES;"
echo "Senha do banco 'wordpress' (usuário wordpress): $WORDPRESS_DB_PASSWORD"
echo "Anote agora — vai precisar dela no wp-config.php durante a instalação do WordPress."

# Backup e instalação do WordPress
if [ -d "$DOCUMENT_ROOT" ] && [ ! -e "$HOME/wordpress-htdocs-backup" ]; then
  cp -a "$DOCUMENT_ROOT" "$HOME/wordpress-htdocs-backup"
fi
mkdir -p "$DOCUMENT_ROOT"
wget -q https://wordpress.org/latest.tar.gz -O "$PREFIX/tmp/wordpress-latest.tar.gz"
tar -xzf "$PREFIX/tmp/wordpress-latest.tar.gz" -C "$DOCUMENT_ROOT" --strip-components=1
rm -f "$PREFIX/tmp/wordpress-latest.tar.gz"

httpd -t

# Iniciar MariaDB e Apache automaticamente no boot
printf '%s\n' \
  '#!/data/data/com.termux/files/usr/bin/bash' \
  'mysqld_safe &' \
  'sleep 5' \
  'httpd' > "$PREFIX/bin/termux_boot_script"
chmod +x "$PREFIX/bin/termux_boot_script"
termux-reload-settings
