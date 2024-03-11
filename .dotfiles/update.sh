#! /bin/bash

# System update script

set -e

sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y

sudo flatpak update

sudo snap refresh

exit
