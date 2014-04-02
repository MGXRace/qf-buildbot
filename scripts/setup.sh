#!/bin/bash

# It's important that this only be run once
# Many steps may create errors if run multiple times
# Hopefully that won't be the case in future revisions

SOURCE_DIR="${PWD}/.."
DEBOOTSTRAP_DIR="/srv/chroot/wheezy-i386"
DEBOOTSTRAP_MIR="http://mirrors.kernel.org/debian"
DEBOOTSTRAP_CMD="sudo debootstrap \
    --arch i386 \
    --include sudo \
    wheezy ${DEBOOTSTRAP_DIR} ${DEBOOTSTRAP_MIR}"
DEBOOTSTRAP_CNT=0

echo "> *********************************************************"
echo "> * Installing Dependencies"
echo "> *********************************************************"

sudo apt-get -y install \
    schroot \
    debootstrap \
    git \
    build-essential \
    mingw-w64 \
    automake \
    libtool \
    libcurl4-openssl-dev \
    libxinerama-dev \
    libxxf86vm-dev \
    libxrandr-dev \
    libsdl1.2-dev \
    libxi-dev \
    libopenal-dev \
    libpng12-dev \
    libvorbis-dev \
    libfreetype6-dev \
    libtheora-dev \

echo "> *********************************************************"
echo "> * Configuring the chroot"
echo "> *********************************************************"

sudo mkdir -p "${DEBOOTSTRAP_DIR}"
until $(${DEBOOTSTRAP_CMD} | tee /dev/tty) || [ ${DEBOOTSTRAP_CNT} -gt 2 ]; do
    DEBOOTSTRAP_CNT=$((DEBOOTSTRAP_CNT + 1))
    echo "Deboostrap failed with status $?, retrying"
done

sudo cp "/etc/sudoers.d/99_vagrant" "${DEBOOTSTRAP_DIR}/etc/sudoers.d/"
cat "${SOURCE_DIR}/inc/schroot.conf" | sudo tee -a "/etc/schroot/schroot.conf"

echo "> *********************************************************"
echo "> * Installing build dependencies to the chroot"
echo "> *********************************************************"

schroot -c wheezy-i386 "sudo apt-get -y install \
    build-essential \
    automake \
    libtool \
    libcurl4-openssl-dev \
    libxinerama-dev \
    libxxf86vm-dev \
    libxrandr-dev \
    libsdl1.2-dev \
    libxi-dev \
    libopenal-dev \
    libpng12-dev \
    libvorbis-dev \
    libfreetype6-dev \
    libtheora-dev"
