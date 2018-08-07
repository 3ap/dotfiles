#!/bin/bash

alias mc='mc -b'
alias ls='LC_COLLATE=C ls -F -h -w 80 --color --group-directories-first'
alias grep="ag"
alias search="find . -name"
alias o='open'

which neomutt >/dev/null && alias mutt='neomutt'

cd() {
  builtin cd "$@" && ls
}
