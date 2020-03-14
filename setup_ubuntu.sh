#!/bin/bash

SET_UBUNTU_SH_FILENAME=`readlink -f $0`
SET_UBUNTU_SH_DIRNAME=`dirname $SET_UBUNTU_SH_FILENAME`

MODE=`${$1,,}`

if [ "$MODE" != 'debian-wsl' ] && \
        [ "$MODE" != 'ubuntu-dualboot' ] && \
        [ "$MODE" != 'ubuntu-vmware' ]; then
    echo "Unexpected value: $MODE"
    exit 1
fi

# Common 1
sudo apt update
packages="git vim python3-venv python3-pip"

# Option
## Ubuntu
if [ "$MODE" == 'ubuntu-dualboot' ] || \
        [ "$MODE" == 'ubuntu-vmware' ]; then
    ### Set ufw
    packages="$packages ufw"
    sudo ufw enable
    sudo ufw default deny

    ### edit .bashrc
    cp $HOME/.bashrc $HOME/.bashrc.org
    sed -e 's/#force_color_prompt=yes/force_color_prompt=yes/g' $HOME/.bashrc.org > $HOME/.bashrc
fi

### Ubuntu-Dualboot
if [ "$MODE" == 'ubuntu-dualboot' ]; then
    sudo timedatectl set-local-rtc true 
fi

### Ubuntu-VMWare
if [ "$MODE" == 'ubuntu-vmware' ]; then
    packages="$packages open-vm-tools open-vm-tools-desktop"
fi

## WSL
if [ "$MODE" == 'debian-wsl' ] || \
    packages="$packages pdftk"
fi

# Common 2
## Upgrade and Install apt-packages
sudo apt install $packages -y
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean
sudo apt clean 

## Install third-party applications
sudo dpkg -i $SET_UBUNTU_SH_DIRNAME/*.deb # ??
sudo apt install --fix-broken -y

## Install MyBashAliases
git clone https://github.com/dongsiku/MyBashAliases.git


# Ubuntu
if [ "$MODE" == 'ubuntu-dualboot' ] || \
        [ "$MODE" == 'ubuntu-vmware' ]; then
    ## Install git-credential
    sudo apt-get install libgnome-keyring-dev -y
    cd /usr/share/doc/git/contrib/credential/gnome-keyring
    sudo make
    git config --global credential.helper \
        /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring
fi
