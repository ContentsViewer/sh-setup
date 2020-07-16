#!/bin/sh

# === Initialize shell environment ===================================
set -u
export LC_ALL=C
type Command >/dev/null 2>&1 && type getconf >/dev/null 2>&1 &&
  export PATH="$(command -p getconf PATH)${PATH+:}${PATH-}"
export UNIX_STD=2003 # to make HP-UX conform to POSIX

VERSION='2020.06.10'

usage="
Usage: ${0##*/} [options]

Options:
 --wsl          install gui environment for windows subsystem for Linux.

 -h, --help     display this help and exit
 -V, --version  output version infromation and exit

Version:
 $VERSION
"

MY_DIR=$(
  cd $(dirname $0)
  pwd
)
SRC_DIR='src'

NOTE="\033[34m[NOTE]\033[m   "
WARNING="\033[33m[WARNING]\033[m"
ERROR="\033[31m[ERROR]\033[m  "

print_note() {
  printf "$NOTE"
  echo " $1"
}

print_warning() {
  printf "$WARNING"
  echo " $1"
}

print_error() {
  printf "$ERROR"
  echo " $1"
}

######################################################################
# Parse Arguments
######################################################################
optwsl=0
while [ $# -gt 0 ]; do
  case $1 in
    --wsl)
      optwsl=1
      shift; continue
      ;;
    -h | --help)
      echo "$usage"
      exit
      ;;
    -V | --version)
      echo "$VERSION"
      exit
      ;;
    *)
      echo "$usage" 1>&2
      exit 1
      ;;
  esac
done

######################################################################
# Main Routine
######################################################################
print_note "MY_DIR=$MY_DIR"

if [ "$(whoami)" = "root" ]; then
  print_warning "You now have root privilage."
  echo "But this script is designed under user privilage."

  while true; do
    yn=''
    printf "Are you sure to continue?[y/n]"
    read yn
    case $yn in
      [Yy]) break                        ;;
      [Nn]) print_error 'Abort.'; exit 1 ;;
      *) echo "please input [y/n]"       ;;
    esac
  done
fi

print_note 'Start Setup'
sleep 1

sudo apt update
sudo apt upgrade

# === Install Standard Apt ===========================================
print_note 'Install build-essential'
sudo apt install build-essential
sleep 1

print_note 'Install cmake'
sudo apt install cmake
sleep 1

print_note 'Install vim'
sudo apt install vim
sleep 1

print_note 'Install git'
sudo apt install git
sleep 1

print_note 'Install tree'
sudo apt install tree
sleep 1

print_note 'Install htop'
sudo apt install htop
sleep 1

# === Install zsh ====================================================
print_note 'Install zsh'

if type "zsh" >/dev/null 2>&1; then
  print_note 'zsh is already installed.'
else
  sudo apt install zsh

  chmod 755 ${MY_DIR}/${SRC_DIR}/setup.zsh
  ${MY_DIR}/${SRC_DIR}/setup.zsh

  \cp -f ${MY_DIR}/${SRC_DIR}/.zshrc ${HOME}/.zshrc
  \cp -f ${MY_DIR}/${SRC_DIR}/.zpreztorc ${HOME}/.zpreztorc
fi
sleep 1

# === Install tmux ===================================================
print_note 'Install tmux'
sudo apt install tmux
\cp -n ${MY_DIR}/${SRC_DIR}/.tmux.conf ${HOME}/.tmux.conf
sleep 1

# === Install fzf ====================================================
print_note 'Install fzf'
if type "fzf" >/dev/null 2>&1; then
  print_warning 'fzf is already installed.'
else
  git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf
  ${HOME}/.fzf/install
  
  fzf_conf=$(cat <<EOS

export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

EOS
  )

  echo "$fzf_conf" >>${HOME}/.fzf.bash
  echo "$fzf_conf" >>${HOME}/.fzf.zsh
fi
sleep 1

# === Install python environment =====================================
print_note 'Install python-dev'
sudo apt install python3-dev
sudo apt install python-dev
sleep 1

print_note 'Install pip'
if type "pip" >/dev/null 2>&1; then
  print_warning 'pip is already installed.'
else
  echo "add path'${HOME}/.local/bin' to PATH"
  echo 'export PATH=${HOME}/.local/bin:$PATH' >>${HOME}/.bashrc
  PATH=${HOME}/.local/bin:${PATH}

  mkdir ${HOME}/.pip
  cd ${HOME}/.pip
  wget "https://bootstrap.pypa.io/get-pip.py"

  python get-pip.py --user
  python3 get-pip.py --user
fi
sleep 1

print_note 'Install pipenv'
pip install pipenv --user
sleep 1

# === WSL Option =====================================================
[ $optwsl -eq 1 ] && {
  print_note 'WSL option is enabled.'

  print_note 'Install xfce4-terminal'
  sudo apt install xfce4-terminal
  sleep 1

  print_note 'Install xfce4'
  sudo apt install xfce4

  if cat ${HOME}/.bashrc | grep '# xfce4 setting. written by setup.sh'; then
    print_warning 'xfce4 setting is already written in .bashrc'
  else
    cat >>${HOME}/.bashrc <<EOS

# xfce4 setting. written by setup.sh
export DISPLAY=:0.0
export LIBGL_ALWAYS_INDIRECT=0

EOS
  fi
  sleep 1

  print_note 'Install windows font'
  sudo apt -y install fontconfig
  sudo ln -s /mnt/c/Windows/Fonts /usr/share/fonts/windows
  sudo fc-cache -fv
  sleep 1

  print_note 'Install fcitx'
  sudo apt -y install fcitx-mozc dbus-x11 x11-xserver-utils
  if cat ${HOME}/.profile | grep '# fcitx setting. written by setup.sh'; then
    print_warning 'fcitx setting is already written in .profile'
  else
    cat >>~/.profile <<EOS

# fcitx setting. written by setup.sh

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
export DefaultIMModule=fcitx

EOS
  fi
  sleep 1
}

# === Final stage ====================================================
print_note 'Final update...'
sudo apt update
sudo apt upgrade

print_note 'All process done!'
print_note 'Please restart shell environment.'
