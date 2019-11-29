#!/bin/sh

# === Initialize shell environment ===================================
set -u
export LC_ALL=C
type Command >/dev/null 2>&1 && type getconf >/dev/null 2>&1 &&
  export PATH="$(command -p getconf PATH)${PATH+:}${PATH-}"
export UNIX_STD=2003 # to make HP-UX conform to POSIX

mkdir -p $HOME/.dotfiles

DOT_FILES='.zshrc .zpreztorc'
echo $DOT_FILES |
  awk '{
  for (i=1;i<=NF;i++) print $i;
}' |
  while read file; do
    cp $file $HOME/.dotfiles
    unlink $HOME/$file
    ln -s $HOME/.dotfiles/$file $HOME/$file
  done
