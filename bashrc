sourcesdir="$HOME/.bashrc.d/"
if [ -d "$sourcesdir" ]; then
  sources=`/bin/ls -1 "$sourcesdir"`
  for file in $sources; do
    if [ -f "$sourcesdir/$file" ]; then
      . "$sourcesdir/$file"
    fi
  done
fi
