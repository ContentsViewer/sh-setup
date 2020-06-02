# sh-setup
Setup Shell Environment with ONE Command. (Including WSL)

## Usage
```sh
# download scripts
$ git clone https://github.com/ContentsViewer/sh-setup.git

# move to script folder
$ cd sh-setup

# change the access mode of the script
$ chmod 755 setup.sh

# Now, let's start setup!
$ ./setup.sh
```

if you are using wsl(windows subsystem for linux), 
you can setup gui environment by adding option `--wsl`

```sh
$ ./setup.sh ---wsl
```

## Update
You can re-run this script.

At 2 or more, this script updates all packages.

## Packages
This script will add these packages.

### build-essential
### vim
### git
### tree
### tmux
At same time, add the `tmux.conf` by which you can use

* mouse
* scroll

### htop
### fzf
### python-dev
### pip
### pipenv
### zsh
This script does not change current shell into zsh as default shell.

You can launch zsh with command bellow.

```sh
zsh
```

### Optional
if you flag the wsl option, this script will add these additional packages.

#### xfce4-termianl
#### xfce4
install GUI Environment. for more detail, read the bellow section "How to Setup GUI Environment on WSL".

#### font
install fonts in windows into linux 
#### fcitx

## How to Setup GUI Environment on WSL
1. First, you should install X Client on windows, such like "VcXsrv(free)" "X410".
2. And Run this script added `--wsl`
3. Finally, start gui environment `startxfce4`

## Author
IOE <Github: ContentsViewer>
