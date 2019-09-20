#!/bin/sh

# === Initialize shell environment ===================================
set -u
export LC_ALL=C
type Command >/dev/null 2>&1 && type getconf >/dev/null 2>&1 &&
  export PATH="$(command -p getconf PATH)${PATH+:}${PATH-}"
export UNIX_STD=2003 # to make HP-UX conform to POSIX

#

print_usage_and_exit() {
  cat <<-USAGE 1>&2
	Usage: ${0##*/} [--wsl]
	       --wsl ...  install gui environment for windows subsystem for Linux.
	          
	Version : 2018-11-02 02:39:39 JST
	USAGE
  exit 1
}

error_exit() {
  ${2+:} false && echo "${0##*/}: $2" 1>&2
  exit $1
}

MY_DIR=$(pwd)

LF=$(printf '\\\n_')
LF=${LF%_}

NOTE_LINE="\033[37;44m[NOTE] \033[m"
WARNING_LINE="\033[37;43m[WARNING] \033[m"
ERROR_LINE="\033[37;41m[ERROR] \033[m"

######################################################################
# Parse Arguments
######################################################################

optwsl=0

while [ $# -gt 0 ]; do
  case $# in 0) break ;; esac

  case $1 in
    --wsl)
      optwsl=1
      shift
      continue
      ;;
    --help | --version | -h) print_usage_and_exit ;;
    *) print_usage_and_exit ;;
  esac
done

######################################################################
# Main Routine
######################################################################

echo "$NOTE_LINE MY_DIR=$MY_DIR"

if [ "$(whoami)" = "root" ]; then
  echo "$WARNING_LINE You now have root privilage."
  echo "But this setup shell is designed under user privilage."

  while true; do
    yn=''
    printf "Are you sure to continue?[y/n]"
    read yn
    case $yn in
      [Yy]) break ;;

      [Nn]) exit 1 ;;

      *) echo "please input [y/n]" ;;
    esac

  done
fi

echo $NOTE_LINE 'Start setup'
sleep 1

sudo apt update
sudo apt upgrade

echo $NOTE_LINE 'Install build-essential'
sudo apt install build-essential
sleep 1

echo $NOTE_LINE 'Install cmake'
sudo apt install cmake
sleep 1

echo $NOTE_LINE 'Install vim'
sudo apt install vim
sleep 1

echo $NOTE_LINE 'Install git'
sudo apt install git
sleep 1

echo $NOTE_LINE 'Install tree'
sudo apt install tree
sleep 1

echo $NOTE_LINE 'Install tmux'
sudo apt install tmux
if [ -f ~/.tmux.conf ]; then
  echo $WARNING_LINE ".tmux.conf is already exist!"
  echo "$WARNING_LINE tmux settings will not be written!"
else
  echo "$NOTE_LINE tmux settings will write in .tmux.conf"
  touch ~/.tmux.conf
  cat >~/.tmux.conf <<-EOF
# enable mouse operation
set-option -g mouse on

# when scroll up then enter copy mode.
bind-key -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"

# full scroll down then break copy mode
bind-key -n WheelDownPane select-pane -t= \; send-keys -M
	EOF

fi
sleep 1

echo $NOTE_LINE 'Install htop'
sudo apt install htop
sleep 1

echo $NOTE_LINE 'Install fzf'
if type "fzf" >/dev/null 2>&1; then
  echo "$NOTE_LINE fzf is already installed."
else
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install

  cat >>~/.fzf.bash <<-EOF

export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

	EOF
fi
sleep 1

echo $NOTE_LINE 'Install python-dev'
sudo apt install python3-dev
sudo apt install python-dev

sleep 1

echo "$NOTE_LINE Install pyenv"
if type "pyenv" >/dev/null 2>&1; then
  echo "$NOTE_LINE pyenv is already installed."
else
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv

  if cat ~/.bashrc | grep '# pyenv setting. written by setup.sh'; then
    echo $WARNING_LINE 'pyenv setting is already written in .bashrc'
    echo $WARNING_LINE 'pyenv setting will not written in .bashrc'
  else
    echo '# pyenv setting. written by setup.sh' >>~/.bashrc
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >>~/.bashrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >>~/.bashrc
    echo 'if command -v pyenv 1>/dev/null 2>&1; then' >>~/.bashrc
    echo '  eval "$(pyenv init -)"' >>~/.bashrc
    echo 'fi' >>~/.bashrc
  fi
fi

sleep 1

echo $NOTE_LINE 'Install pip'
if type "pip" >/dev/null 2>&1; then
  echo "$NOTE_LINE pip is already installed."
else
  echo add ~/.local/bin to PATH
  echo '# add ~/.local/bin to PATH (written by setup.sh)' >>~/.bashrc
  echo 'export PATH=~/.local/bin:$PATH' >>~/.bashrc

  mkdir ~/.pip
  cd ~/.pip
  wget "https://bootstrap.pypa.io/get-pip.py"

  python get-pip.py --user
  python3 get-pip.py --user
fi
sleep 1

source ~/.bashrc

echo $NOTE_LINE 'Install pipenv'
pip install pipenv --user

sleep 1

echo $NOTE_LINE 'Install trash-cli'
if type "trash-list" >/dev/null 2>&1; then
  echo "$NOTE_LINE trash-cli already installed."
else
  git clone https://github.com/andreafrancia/trash-cli.git ~/.trash-cli
  cd ~/.trash-cli
  sudo python setup.py install

fi
sleep 1

case $optwsl in
  0) : ;;
  1)
    echo "$NOTE_LINE wsl option is enabled."

    echo "$NOTE_LINE Install xfce4-terminal"
    sudo apt install xfce4-terminal
    sleep 1

    echo "$NOTE_LINE Install xfce4-terminal"
    sudo apt install xfce4

    if cat ~/.bashrc | grep '# xfce4 setting. written by setup.sh'; then
      echo $WARNING_LINE 'xfce4 setting is already written in .bashrc'

    else

      cat >>~/.bashrc <<-EOF

# xfce4 setting. written by setup.sh
export DISPLAY=:0.0
export LIBGL_ALWAYS_INDIRECT=0

			EOF

    fi

    sleep 1

    echo "$NOTE_LINE Install windows font"
    sudo apt -y install fontconfig
    sudo ln -s /mnt/c/Windows/Fonts /usr/share/fonts/windows
    sudo fc-cache -fv
    sleep 1

    echo "$NOTE_LINE Install fcitx"
    sudo apt -y install fcitx-mozc dbus-x11 x11-xserver-utils

    if cat ~/.profile | grep '# fcitx setting. written by setup.sh'; then
      echo $WARNING_LINE 'fcitx setting is already written in .profile'

    else

      cat >>~/.profile <<-EOF

# fcitx setting. written by setup.sh

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
export DefaultIMModule=fcitx

			EOF

    fi

    sleep 1

    ;;

esac

echo $NOTE_LINE 'Install zsh'

if type "zsh" >/dev/null 2>&1; then
  echo "$NOTE_LINE zsh is already installed."
else
  sudo apt install zsh

  # echo "$WARNING_LINE Now we be starting zsh. zsh will open install setup screen."
  # echo "$WARNING_LINE Please select q option - nothing to do!!"

  # none=''
  # printf "Are input to continue?"
  # read  none
  $MY_DIR/setup_zsh.zsh
fi

sleep 1

# echo $NOTE_LINE 'PATH settings'

# if echo $PATH | grep -e ~/.local/bin >/dev/null 2>&1; then
#   :
# elif cat ~/.bashrc | grep '# add ~/.local/bin to PATH (written by setup.sh)' >/dev/null 2>&1; then
#   :
# else
#   echo add ~/.local/bin to PATH
#   echo '# add ~/.local/bin to PATH (written by setup.sh)' >>~/.bashrc
#   echo 'export PATH=~/.local/bin:$PATH' >>~/.bashrc
# fi

# sleep 1

echo $NOTE_LINE 'Final update...'
sudo apt update
sudo apt upgrade

echo "$NOTE_LINE All process done!"
