#!/bin/bash

SOURCE_DIR="${PWD}/.."
DEBOOTSTRAP_DIR="/srv/chroot/wheezy-i386"
DEBOOTSTRAP_MIR="http://mirrors.kernel.org/debian"

echo "> *********************************************************"
echo "> * Installing Dependencies"
echo "> *********************************************************"

. dependencies.sh 1

echo "> *********************************************************"
echo "> * Configuring the chroot"
echo "> *********************************************************"

sudo mkdir -p "${DEBOOTSTRAP_DIR}"
sudo debootstrap \
    --arch i386 \
    --include sudo \
    wheezy ${DEBOOTSTRAP_DIR} ${DEBOOTSTRAP_MIR}

sudo cp "/etc/sudoers.d/99_vagrant" "${DEBOOTSTRAP_DIR}/etc/sudoers.d/"
if $(grep -Fq "wheezy-i386" /etc/schroot/schroot.conf); then
    echo "Schroot already configured"
else
    echo "Configuring schroot"
    cat "${SOURCE_DIR}/inc/schroot.conf" | sudo tee -a "/etc/schroot/schroot.conf"
fi

echo "> *********************************************************"
echo "> * Installing build dependencies to the chroot"
echo "> *********************************************************"
 
schroot -c wheezy-i386 dependencies.sh
