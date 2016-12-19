#!/bin/bash

alias ls='ls -h -w 80 --color --group-directories-first'
alias grep="grep -n --color=auto"
alias search="find . -name"

cd() {
  builtin cd "$@" && ls
}
