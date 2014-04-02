#!/bin/bash
if [ -z "$1" ]; then
    echo "Specify target OS"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Specify target arch"
    exit 1
fi

inArray() {
	local e
	for e in "${@:2}"; do
		[[ "$e" == "$1" ]] && echo "0" && return 0;
	done
	echo "1"
	return 1
}

OS="$1"
ARCH="$2"

set -e

. `pwd`/inc/common.inc.sh
. `pwd`/inc/target-${OS}-${ARCH}.inc.sh

TARGET_DIR="${SOURCE_DIR}source/$OS/$ARCH/$TLIB_DIR/"
if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
fi

COMMAND_PREF="PATH=\"${PATH}\" HOST=${HOST} SOURCE_DIR=\"${SOURCE_DIR}\" TARGET_DIR=\"${TARGET_DIR}\" CFLAGS=\"${CFLAGS_COMMON}\" MAKE=\"${MAKE}\""
if [ ! -z "$DATA_DIR" ]; then
    COMMAND_PREF="${COMMAND_PREF} DATA_DIR=\"${DATA_DIR}\""
fi
if [ ! -z "$MINGW_DIR" ]; then
    COMMAND_PREF="${COMMAND_PREF} LIB_DIR=\"${MINGW_DIR}/lib\" INCLUDE_DIR=\"${MINGW_DIR}include\""
fi
COMMAND_PREF="${COMMAND_PREF} ENABLE_SHARED=$ENABLE_SHARED SHARED_LIBRARY_EXT=$SHARED_LIBRARY_EXT"


# zlib
if [[ $# -lt 3 ]] || [[ $(inArray "zlib" "$@") == "0" ]]; then
	COMMAND="${COMMAND_PREF} "
	if [ ! -z "$MINGW_DIR" ]; then
	    COMMAND="${COMMAND} PATH=\"${MINGW_DIR}mingw/bin:$PATH\""
	    COMMAND="${COMMAND} CC=\"${HOST_PREF}gcc\" RC=\"${HOST_PREF}windres\" DLLWRAP=\"${HOST_PREF}dllwrap\" STRIP=\"${HOST_PREF}strip\" AR=\"${HOST_PREF}ar\" RANLIB=\"${HOST_PREF}ranlib\""
	fi
	COMMAND="${COMMAND} ./libs/zlib.sh"
	echo "$COMMAND" && eval $COMMAND
fi

# libcurl
if [[ $# -lt 3 ]] || [[ $(inArray "curl" "$@") == "0" ]]; then
	COMMAND="${COMMAND_PREF}"
	COMMAND="${COMMAND} ./libs/curl.sh"
	echo "$COMMAND" && eval $COMMAND
fi

# libjpeg
if [[ $# -lt 3 ]] || [[ $(inArray "jpeg" "$@") == "0" ]]; then
	COMMAND="${COMMAND_PREF} CFLAGS=\"${CFLAGS_COMMON}\""
	COMMAND="${COMMAND} ./libs/jpeg.sh"
	echo "$COMMAND" && eval $COMMAND
fi

# libogg
if [[ $# -lt 3 ]] || [[ $(inArray "ogg" "$@") == "0" ]]; then
	COMMAND="${COMMAND_PREF}"
	COMMAND="${COMMAND} ./libs/ogg.sh"
	echo "$COMMAND" && eval $COMMAND
fi

# libvorbis
if [[ $# -lt 3 ]] || [[ $(inArray "vorbis" "$@") == "0" ]]; then
	COMMAND="${COMMAND_PREF}"
	COMMAND="${COMMAND} ./libs/vorbis.sh"
	echo "$COMMAND" && eval $COMMAND
	fi

# libtheora
if [[ $# -lt 3 ]] || [[ $(inArray "theora" "$@") == "0" ]]; then
	COMMAND="${COMMAND_PREF}"
	COMMAND="${COMMAND} ./libs/theora.sh"
	echo "$COMMAND" && eval $COMMAND
fi

# libfreetype
if [[ $# -lt 3 ]] || [[ $(inArray "freetype" "$@") == "0" ]]; then
	COMMAND="${COMMAND_PREF}"
	COMMAND="${COMMAND} ./libs/freetype.sh"
	echo "$COMMAND" && eval $COMMAND
fi

# libpng
	if [[ $# -lt 3 ]] || [[ $(inArray "png" "$@") == "0" ]]; then
	COMMAND="${COMMAND_PREF}"
	COMMAND="${COMMAND} ./libs/png.sh"
	echo "$COMMAND" && eval $COMMAND
fi
