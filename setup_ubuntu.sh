#!/bin/bash

sudo ufw enable
sudo ufw default deny 

sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean
sudo apt clean 

sudo apt install git open-vm-tools open-vm-tools-desktop vim ufw python3-venv python3-pip -y

# vim .bashrc 
source .bashrc 

# sudo dpkg -i code_1.40.2-1574694120_amd64.deb 
# sudo dpkg -i google-chrome-stable_current_amd64.deb 

# Install git-credential
sudo apt-get install libgnome-keyring-dev -y
cd /usr/share/doc/git/contrib/credential/gnome-keyring
sudo make
git config --global credential.helper \
    /usr/share/doc/git/contrib/credential/gnome-keyring/git-credential-gnome-keyring

# Install MyBashAliases
git clone https://github.com/dongsiku/MyBashAliases.git
