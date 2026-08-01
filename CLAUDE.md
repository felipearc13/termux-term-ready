# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## O que é este repositório

Script de setup do Termux (terminal Android) — não é uma aplicação, é um instalador shell que customiza um
ambiente Termux do zero. Repositório **público**.

## Uso

```bash
pkg update && pkg upgrade -y
curl https://raw.githubusercontent.com/felipearc13/termux-term-ready/main/install.sh && chmod +x install.sh && ./install.sh
```

## O que `install.sh` faz

Instala via `pkg`: neovim, vim, python, zsh, termux-api, termux-tools, neofetch, wget, git, expect, openssh,
termux-auth. Depois:

- Instala e configura **Oh My Zsh**, define **zsh** como shell padrão, aplica o tema **Agnoster** (com
  modificação via `sed` para remover `@%m` do prompt).
- Faz backup dos arquivos originais em `$HOME/backup` antes de sobrescrever.
- Aplica `termux.properties` (extra-keys) e configura `openssh`/`termux-api`.

## Outros arquivos

- `httpd.conf`, `lamp_wordpress.sh` — setup opcional de LAMP + WordPress dentro do Termux, separado do fluxo
  principal do `install.sh`.
- `termux.properties` — configuração de teclas extras copiada para `~/.termux/`.
- `conf.d/` — vazio no momento.
