# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## O que é este repositório

Script de setup do Termux (terminal Android) — não é uma aplicação, é um instalador shell que customiza um
ambiente Termux do zero. Repositório **público**.

## Estrutura completa

```text
termux-term-ready/
├── README.md
├── CLAUDE.md
├── install.sh              140 linhas — fluxo principal (zsh/Oh My Zsh/tema/fonte/ssh)
├── lamp_wordpress.sh        32 linhas — setup opcional de LAMP + WordPress, independente do install.sh
├── httpd.conf               535 linhas — config completa do Apache do Termux, editada pelo lamp_wordpress.sh
├── termux.properties         3 linhas — extra-keys, copiado para ~/.termux/
└── conf.d/                   vazio no momento
```

## Uso

```bash
pkg update && pkg upgrade -y
curl https://raw.githubusercontent.com/felipearc13/termux-term-ready/main/install.sh && chmod +x install.sh && ./install.sh
```

## `install.sh` — passo a passo

Banner ASCII art ("TERM READY") impresso primeiro, depois `set -e` (para no primeiro erro). Exporta os
caminhos usados por todas as funções (`HOME_DIR`, `BACKUP_DIR=~/backup`, `TERMUX_DIR=~/.termux`,
`ZSH_DIR=~/.oh-my-zsh`, etc.), então roda em sequência (`&&` entre cada chamada — para tudo se uma falhar):

1. `install_packages` — `pkg install -y neovim vim python zsh termux-api termux-tools neofetch wget git expect
   openssh termux-auth`.
2. `set_zsh` — `chsh -s zsh`.
3. `install_oh_my_zsh` — baixa e roda o instalador oficial do Oh My Zsh (`ohmyzsh/ohmyzsh`), depois remove o
   instalador.
4. `install_fira_code` — clona `notflawffles/termux-nerd-installer`, `make install`, instala e ativa a fonte
   Nerd Font `fira-code`, depois apaga o clone.
5. `set_agnoster` — faz backup do tema Agnoster original em `$BACKUP_DIR`, remove `@%m` do tema (via `sed`,
   tira o hostname do prompt) e troca `ZSH_THEME` no `.zshrc` para `"agnoster"`.
6. `set_rxfetch` — apesar do nome, não mexe no neofetch: só acrescenta linhas de boas-vindas no `.zshrc`
   (mensagens fixas: "Welcome to Termux!", docs/donate/community), ativa o zsh-syntax-highlighting e desliga o
   neofetch automático (`neofetch --off` — comentário do próprio script diz que modifica a mensagem do
   neofetch, mas o efeito real é desligá-lo).
7. `add_extra_keys` — faz backup do `termux.properties` atual e baixa um novo via `wget` de
   `raw.githubusercontent.com/felipearc13/termux-ini-f13/master/termux.properties`. **Essa URL está quebrada**:
   não existe (nem existiu, pelo histórico de repositórios conhecido) um repositório `termux-ini-f13` — o mais
   próximo é o antigo `termux-f13`, que já foi apagado por ser subconjunto deste repositório. Corrigir para
   apontar para o `termux.properties` deste próprio repositório antes de confiar nesta função.
8. `clone_zsh_syntax` — clona `zsh-users/zsh-syntax-highlighting` (`--depth 1`).
9. `set_ssh_password` — roda `passwd termux` (interativo, pede senha nova na hora — não hardcoded) e adiciona
   `sshd` ao `.zshrc` (inicia o servidor SSH a cada shell novo).
10. `setup_storage` — `termux-setup-storage` (pede permissão de acesso ao armazenamento do Android).
11. `restart_shell` — `exec zsh`.

**Bug conhecido**: `trap restore INT` está registrado perto do fim do script, mas a função `restore()` está
**comentada** logo acima (bloco `#restore() { ... }` desativado). Se o script for interrompido com Ctrl+C, o
trap tenta chamar uma função inexistente — vai falhar com erro em vez de restaurar o tema/config originais do
backup. `cleanup()` (trap `EXIT`, remove o instalador temporário do Oh My Zsh) funciona normalmente.

## `lamp_wordpress.sh`

Script independente (não chamado pelo `install.sh`), roda com o shebang do bash do Termux
(`/data/data/com.termux/files/usr/bin/bash`):

1. Instala `php mariadb apache2 php-apache wget`.
2. Edita `$PREFIX/etc/apache2/httpd.conf` via `sed`: troca o MPM de `prefork` para `worker`, injeta
   `LoadModule php_module` depois do `mod_rewrite`, muda `AllowOverride None` para `FileInfo`, injeta
   `DirectoryIndex index.php` dentro de `<IfModule dir_module>`, troca `index.html` por `index.php` como
   índice padrão, injeta `SetHandler application/x-httpd-php` depois do bloco `<FilesMatch \.php$`.
3. Escreve `php.ini` com `upload_max_filesize = 32M` e `post_max_size = 32M`.
4. Sobe o MariaDB (`mysqld_safe &`, `sleep 5`) e roda `CREATE DATABASE wordpress; GRANT ALL PRIVILEGES ON
   wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY '061813'`. **Senha hardcoded em texto puro
   (`061813`) num repositório público** — é uma senha local ao MariaDB do próprio Termux (só acessível de
   dentro do dispositivo por padrão, sem exposição de rede automática), mas ainda assim é credencial hardcoded
   publicada; trocar antes de usar em qualquer instalação real.
5. Faz backup de `$PREFIX/share` para `$HOME/share_bkp`, baixa o WordPress mais recente
   (`wordpress.org/latest.tar.gz`) e extrai em `$PREFIX/share` (nota: o comando usado é `mv -r`, que **não é
   uma flag válida do `mv`** — `mv` não tem `-r`; isso provavelmente falha ou é ignorado silenciosamente
   dependendo do shell).
6. Cria `$PREFIX/bin/termux_boot_script` (sobe MariaDB + `httpd` no boot) e roda `termux-reload-settings`.

## `httpd.conf`

Cópia completa e comentada do `httpd.conf` padrão do Apache 2.4 empacotado pro Termux, com os ajustes do
`lamp_wordpress.sh` já aplicados neste arquivo versionado (ou seja, este arquivo reflete o **resultado** dos
`sed` acima, não o original intocado). Pontos-chave: `ServerRoot "/data/data/com.termux/files/usr"`,
`Listen 8080` (não a porta 80 padrão — Termux não tem permissão pra bind em portas <1024 sem root),
`DocumentRoot "/data/data/com.termux/files/usr/share/apache2/default-site/htdocs"`.

## `termux.properties`

3 linhas — configuração de extra-keys copiada para `~/.termux/termux.properties` pela função `add_extra_keys`
do `install.sh` (uma vez corrigida a URL quebrada, ver acima).

## `conf.d/`

Pasta vazia no momento — sem arquivos rastreados.
