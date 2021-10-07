command_exists() {
  cmd=$1
  command -v "${cmd}" >/dev/null 2>&1
}

command_exists mc         && alias mc='mc -b'
command_exists ls         && alias ls='LC_COLLATE=C ls -F -h -w 80 --color --group-directories-first'
command_exists ag         && alias grep=ag
command_exists neomutt    && alias mutt=neomutt
command_exists imv        && alias feh=imv
command_exists git        && alias fixup='git commit -a --fixup HEAD && GIT_SEQUENCE_EDITOR=: git rebase -i HEAD~2'
command_exists picocom    && alias minicom='picocom -q -b 115200'

if command_exists nvim; then
  alias vi=nvim
  alias vim=nvim
  alias vimdiff='nvim -d'
  EDITOR=nvim
  VISUAL=nvim
  export EDITOR
  export VISUAL
elif command_exists vim; then
  alias vi=vim
  EDITOR=vim
  VISUAL=vim
  export EDITOR
  export VISUAL
fi

cd() {
  builtin cd "$@" && ls
}
