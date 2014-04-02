#!/bin/bash
# Install build dependencies for qfusion
# If an additional argument is passed it will install tools 
# for configuring the chroots

joinArray() {
    local IFS="$1"
    shift
    echo "$*"
}

DEPENDENCIES=(
    build-essential
    automake
    libtool
    libcurl4-openssl-dev
    libxinerama-dev
    libxxf86vm-dev
    libxrandr-dev
    libsdl1.2-dev
    libxi-dev
    libopenal-dev
    libpng12-dev
    libvorbis-dev
    libfreetype6-dev
    libtheora-dev
)

if [ $# -gt 0 ]; then
    DEPENDENCIES+=(git schroot debootstrap mingw-w64)
fi

sudo apt-get -y install $(joinArray " " "${DEPENDENCIES[@]}")
