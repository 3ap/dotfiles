#!/bin/bash

alias mc='mc -b'
alias ls='LC_COLLATE=C ls -F -h -w 80 --color --group-directories-first'

EDITOR=vim
VISUAL=vim

command -v open >/dev/null 2>&1 && alias o='open'
command -v ag >/dev/null 2>&1 && alias grep='ag'
command -v neomutt >/dev/null 2>&1 && alias mutt='neomutt'
if command -v nvim >/dev/null 2>&1; then
  alias vim='nvim'
  alias vimdiff='nvim -d'
  EDITOR=nvim
  VISUAL=nvim
fi
command -v vim >/dev/null 2>&1 && alias vi='vim'

export EDITOR
export VISUAL

cd() {
  builtin cd "$@" && ls
}
