#!/bin/bash

alias mc='mc -b'
alias ls='LC_COLLATE=C ls -F -h -w 80 --color --group-directories-first'
alias grep="ag"
alias search="find . -name"
alias o='open'

command -v neomutt >/dev/null 2>&1 && alias mutt='neomutt'
command -v nvim >/dev/null 2>&1 && alias vim='nvim'
command -v vim >/dev/null 2>&1 && alias vi='vim'

cd() {
  builtin cd "$@" && ls
}
