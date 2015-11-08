#!/bin/bash -efu

progpath="$0"
prog="${prog:-${0##*/}}"
prog_version="0.0.1"

pcmd=

show_help() {
    cat <<EOF
Usage: $prog [ options ]

Options:

  -v, --verbose          print additional information while running;

  -V, --version          show version and exit;

  -q, --quiet            toggle quiet (non-interactive) mode;

  -h, --help             print this page and exit.

EOF
    exit 0
}

show_usage() {
    echo
    show_help | head -1
    echo "Use \`$prog --help\` for more information."
}

print_version()
{
    cat <<EOF
$prog version $prog_version
EOF
}

write_error() {
    printf "$@" >&2
}

info() {
    [ -z "$verbose" ] || write_error "$@"
}

fatal() {
    write_error "$@"
    exit 1
}

realpath() {
  local realpath="$1"
  if [ -z "$realpath" ]; then
    info "realpath() required <path>\n"
    return
  fi

  readlink -f "$realpath"
}

install_dotfile() {
  if [ "$#" -ne 3 ]; then
    fatal "install_dotfiles() required <dependencies> <srcpath> <dstpath>\n\
e.g. install_dotfiles \"bash xterm\" \"/etc/profile\" \"\$HOME/.bashrc\"\n"
  fi

  local apps="$1"
  local srcpath="$2"
  local dstpath="$3"

  local dst=`basename "$dstpath"`
  local src=`basename "$srcpath"`

  local ret=0

  for app in $apps; do
    type "$app" >/dev/null 2>&1 || ret=$?
    if [ $ret -ne 0 ]; then
      info '>> %s is not found on this server. Skipping %s...\n' \
                                                    "$app" "$srcpath"
      return
    fi
  done

  if [ -e "$srcpath" ]; then
    if [ -L $dstpath ]; then
      local curpath=`realpath $dstpath`
      if [ "$curpath" == "$srcpath" ]; then
        info "   %s is already installed.\n" "$src"
        return
      fi
    fi

    while true; do
      local yn=y

      if [ $quiet -eq 0 ]; then
        printf "Do you wish to install $src? [Y/n]: "

        read -n1 yn
        if [ "x$yn" == 'x' ]; then
          yn=y
        fi

        printf '\n'
      fi

      case $yn in
        [Yy]* )
           if [ -e "$dstpath" ] && [ ! -L "$dstpath" ]; then
              mv "$dstpath" "$dstpath.bak"
              info ">> %s has been backuped as %s.bak\n" "$dstpath" "$dstpath"
           fi

           mkdir -p `dirname "$dstpath"`
           ln -sf "$srcpath" "$dstpath"
           info ">> %s has been installed as link for %s\n" "$dst" "$srcpath"
           break;;
        [Nn]* )
        	return;;
        * ) echo "Please answer y or n.";;
      esac
    done

  fi
}

orig_opts="$@"
opts=`getopt -n $prog -o v,V,q,h -l verbose,version,quiet,help -- "$@"` ||
     ( ret=$?; show_usage; exit $ret ) >&2

eval set -- "$opts"

verbose=-v;
quiet=0;

while :; do
    case "$1" in
      -v|--verbose)
          #[ -z "$verbose" ] || set -x
          verbose=-v
          ;;
      -V|--version) print_version; exit 0;;
      -h|--help) show_help;;
      -q|--quiet) quiet=1;;
      --) shift; break;;
      *)
          fatal 'Unrecognized option: %s\n' "$1"
          ;;
    esac
    shift
done

scriptdir=`realpath "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"`
dotfilesdir=`realpath "$HOME/.dotfiles"`

if [ "$scriptdir" != "$dotfilesdir" ]; then
  fatal 'ERROR: install.sh must be located in %s!\n' +
        'Please move "%s" to "%s" and try again.\n'
        "$dotfilesdir" "$scriptdir" "$dotfilesdir"
fi

info "Installing dotfiles...\n"

install_dotfile "vim"                                             \
                "$dotfilesdir/vimrc"                              \
                "$HOME/.vimrc"

install_dotfile "bash"                                            \
                "$dotfilesdir/bashrc"                             \
                "$HOME/.bashrc"

install_dotfile "bash"                                            \
                "$dotfilesdir/bash_profile"                       \
                "$HOME/.bash_profile"

install_dotfile "bash"                                            \
                "$dotfilesdir/bash_env"                           \
                "$HOME/.bashrc.d/02-bash_env"

install_dotfile "bash"                                            \
                "$dotfilesdir/bash_aliases"                       \
                "$HOME/.bashrc.d/02-bash_aliases"

install_dotfile "bash"                                            \
                "/etc/bash_completion"                            \
                "$HOME/.bashrc.d/01-bash_completion"

install_dotfile "bash"                                            \
                "/etc/profile"                                    \
                "$HOME/.bashrc.d/01-profile"

install_dotfile "bash"                                            \
                "/usr/share/doc/pkgfile/command-not-found.bash"   \
                "$HOME/.bashrc.d/02-command-not-found"

install_dotfile "bash xrdb"                                       \
                "$dotfilesdir/bash_xrdb"                          \
                "$HOME/.bashrc.d/02-bash_xrdb"

install_dotfile "bash fc-cache"                                   \
                "$dotfilesdir/bash_fc"                            \
                "$HOME/.bashrc.d/02-bash_fc"

install_dotfile "bash dircolors"                                  \
                "$dotfilesdir/bash_dircolors"                     \
                "$HOME/.bashrc.d/02-bash_dircolors"

install_dotfile "bash"                                            \
                "$dotfilesdir/inputrc"                            \
                "$HOME/.inputrc"

install_dotfile "tmux"                                            \
                "$dotfilesdir/tmux.conf"                          \
                "$HOME/.tmux.conf"

install_dotfile "xrdb"                                            \
                "$dotfilesdir/Xresources"                         \
                "$HOME/.Xresources"

install_dotfile "git"                                             \
                "$dotfilesdir/gitconfig"                          \
                "$HOME/.gitconfig"

install_dotfile "fc-cache"                                        \
                "$dotfilesdir/fonts"                              \
                "$HOME/.local/share/fonts"

install_dotfile "fc-cache"                                        \
                "$dotfilesdir/fonts.conf"                         \
                "$HOME/.fonts.conf"

# Don't create "Desktop" and "Downloads" directories
install_dotfile "firefox"                                         \
                "$dotfilesdir/user-dirs.dirs"                     \
                "$HOME/.config/user-dirs.dirs"

install_dotfile "setxkbmap"                                       \
                "$dotfilesdir/xinitrc-xkbmap"                     \
                "$HOME/.xinitrc.d/00-xkbmap"

install_dotfile "xscreensaver"                                    \
                "$dotfilesdir/xinitrc-xscreensaver"               \
                "$HOME/.xinitrc.d/00-xscreensaver"

install_dotfile "i3"                                              \
                "$dotfilesdir/xinitrc-i3"                         \
                "$HOME/.xinitrc"

install_dotfile "i3"                                              \
                "$dotfilesdir/i3-config"                          \
                "$HOME/.i3/config"

info "Installing successfully done.\n"
