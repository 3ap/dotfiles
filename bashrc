for script in ${HOME}/.bashrc.d/*; do
  if [ -r "${script}" ]; then
    . "${script}"
  fi
done
