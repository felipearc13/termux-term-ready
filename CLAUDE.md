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

Banner ASCII art ("TERM READY") impresso primeiro, depois `set -Eeuo pipefail` (para em erro, variável não
definida ou falha dentro de pipeline). Exporta os
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
   (mensagens fixas: "Welcome to Termux!", documentação e doação oficiais do Termux e comunidade no GitHub),
   ativa o zsh-syntax-highlighting e desliga o
   neofetch automático (`neofetch --off` — comentário do próprio script diz que modifica a mensagem do
   neofetch, mas o efeito real é desligá-lo).
7. `add_extra_keys` — cria `~/.termux` quando necessário, preserva o `termux.properties` existente como
   `termux.properties.bak` e baixa a versão deste próprio repositório para o caminho final. Uma instalação
   limpa, ainda sem arquivo anterior, segue normalmente.
8. `clone_zsh_syntax` — clona `zsh-users/zsh-syntax-highlighting` (`--depth 1`).
9. `set_ssh_password` — roda `passwd` para o usuário atual do Termux (interativo, pede senha nova na hora) e adiciona
   `sshd` ao `.zshrc` (inicia o servidor SSH a cada shell novo).
10. `setup_storage` — `termux-setup-storage` (pede permissão de acesso ao armazenamento do Android).
11. `restart_shell` — `exec zsh`.

Ao receber `Ctrl+C`, `restore()` restaura somente os backups que já existem (tema Agnoster e
`termux.properties`) e encerra com status `130`; uma interrupção antes da criação de algum backup não gera um
segundo erro. `cleanup()` roda no `EXIT` e remove o instalador temporário do Oh My Zsh.

## `lamp_wordpress.sh`

Script independente (não chamado pelo `install.sh`), roda com o shebang do bash do Termux
(`/data/data/com.termux/files/usr/bin/bash`):

1. Instala `php mariadb apache2 php-apache wget openssl-tool`.
2. Edita `$PREFIX/etc/apache2/httpd.conf` de forma idempotente: habilita `mpm_prefork` e desabilita
   `mpm_worker` para uso do `mod_php`, carrega `php_module`, define o handler de `.php`, mantém
   `index.php index.html` como índices e muda `AllowOverride` somente no `DocumentRoot`.
3. Escreve `$PREFIX/etc/php/php.ini`, caminho de configuração do pacote atual, com
   `upload_max_filesize = 32M` e `post_max_size = 32M`.
4. Sobe o MariaDB (`mysqld_safe &`, `sleep 5`), gera uma senha aleatória hexadecimal de 48 caracteres com
   `openssl`, cria/atualiza o usuário local `wordpress` e imprime a senha uma única vez para uso no
   `wp-config.php`. Nenhuma senha fica versionada.
5. Preserva o `DocumentRoot` atual em `~/wordpress-htdocs-backup` (somente se o backup ainda não existe), baixa
   o WordPress mais recente e o extrai diretamente em
   `$PREFIX/share/apache2/default-site/htdocs`. A árvore inteira `$PREFIX/share`, compartilhada por outros
   pacotes, não é movida. Ao final, roda `httpd -t` para validar a configuração.
6. Cria `$PREFIX/bin/termux_boot_script` (sobe MariaDB + `httpd` no boot) e roda `termux-reload-settings`.

## `httpd.conf`

Cópia de referência do `httpd.conf` do Apache 2.4 empacotado para Termux. O `lamp_wordpress.sh` altera a cópia
instalada em `$PREFIX/etc/apache2/httpd.conf`; ele não edita automaticamente este arquivo versionado. Pontos-chave
desta referência: `ServerRoot "/data/data/com.termux/files/usr"`,
`Listen 8080` (não a porta 80 padrão — Termux não tem permissão pra bind em portas <1024 sem root),
`DocumentRoot "/data/data/com.termux/files/usr/share/apache2/default-site/htdocs"`.

## `termux.properties`

3 linhas — configuração de extra-keys copiada para `~/.termux/termux.properties` pela função `add_extra_keys`
do `install.sh`.

## `conf.d/`

Pasta vazia no momento — sem arquivos rastreados.
