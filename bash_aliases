#!/bin/bash

alias ls='LC_COLLATE=C ls -F -h -w 80 --color --group-directories-first'
alias grep="ag"
alias search="find . -name"

cd() {
  builtin cd "$@" && ls
}
