#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
autoload -Uz promptinit
promptinit
prompt damoekri

#autoload -Uz vcs_info
#precmd_vcs_info() { vcs_info }
#precmd_functions+=( precmd_vcs_info )
#setopt prompt_subst
#RPROMPT=\$vcs_info_msg_0_
# PROMPT=\$vcs_info_msg_0_'%# '
#zstyle ':vcs_info:git:*' formats '%b'

#export PATH=~/.local/bin/:$PATH

#powerline-daemon -q
#. ~/.local/lib/python3.5/site-packages/powerline/bindings/zsh/powerline.zsh

#export TERM="xterm-256color"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
