#!/bin/bash

SET_UBUNTU_SH_FILENAME=`readlink -f $0`
SET_UBUNTU_SH_DIRNAME=`dirname $SET_UBUNTU_SH_FILENAME`

MODE_DEBIAN_WSL='debian-wsl'
MODE_UBUNTU_DUALBOOT='ubuntu-dualboot'
MODE_UBUNTU_VMWARE='ubuntu-vmware'

if [ -z "$1" ]; then  # is ""
    echo "No value"
    echo "$MODE_DEBIAN_WSL or $MODE_UBUNTU_DUALBOOT or $MODE_UBUNTU_VMWARE"
    exit 1
else
    MODE="$1"
fi

if [ "$MODE" != "$MODE_DEBIAN_WSL" ] && \
        [ "$MODE" != "$MODE_UBUNTU_DUALBOOT" ] && \
        [ "$MODE" != "$MODE_UBUNTU_VMWARE" ]; then
    echo "Unexpected value: $MODE"
    echo "$MODE_DEBIAN_WSL or $MODE_UBUNTU_DUALBOOT or $MODE_UBUNTU_VMWARE"
    exit 1
fi

# Common 1
sudo apt update
packages="git vim python3-venv python3-pip bash-completion"

# Option
## Ubuntu
if [ "$MODE" == "$MODE_UBUNTU_DUALBOOT" ] || \
        [ "$MODE" == "$MODE_UBUNTU_VMWARE" ]; then
    ### Set ufw
    packages="$packages ufw"
    sudo ufw enable
    sudo ufw default deny

    ### edit .bashrc
    cp $HOME/.bashrc $HOME/.bashrc.org
    sed -e 's/#force_color_prompt=yes/force_color_prompt=yes/g' $HOME/.bashrc.org > $HOME/.bashrc
fi

### Ubuntu-Dualboot
if [ "$MODE" == "$MODE_UBUNTU_DUALBOOT" ]; then
    sudo timedatectl set-local-rtc true 
fi

### Ubuntu-VMWare
if [ "$MODE" == "$MODE_UBUNTU_VMWARE" ]; then
    packages="$packages open-vm-tools open-vm-tools-desktop"
fi

## WSL
if [ "$MODE" == "$MODE_DEBIAN_WSL" ]; then
    packages="$packages pdftk bash-completion"
fi

# Common 2
## Upgrade and Install apt-packages
sudo apt install $packages -y
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean
sudo apt clean 

## Install third-party applications
sudo apt $SET_UBUNTU_SH_DIRNAME/*.deb # ??
sudo apt install --fix-broken -y

## Install MyBashAliases
git clone https://github.com/dongsiku/MyBashAliases.git


# Ubuntu
if [ "$MODE" == "$MODE_UBUNTU_DUALBOOT" ] || \
        [ "$MODE" == "$MODE_UBUNTU_VMWARE" ]; then
    ## Install git-credential
    sudo apt-get install libgnome-keyring-dev -y
    cd /usr/share/doc/git/contrib/credential/gnome-keyring
    sudo make
    git config --global credential.helper \
        /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring
fi
