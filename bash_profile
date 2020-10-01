for script in ${HOME}/.bash_profile.d/*; do
  if [ -r "${script}" ]; then
    . "${script}"
  fi
done

[ -f "${HOME}/.bashrc" ] && . "${HOME}/.bashrc"
