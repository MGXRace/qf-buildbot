#!/bin/bash
# Usage:
#     ./compile.sh <project> [make targets]

if [ ! -f setup.sh ]; then
	echo "Execute this from the qf-buildbot/scripts directory"
	return
fi

if [ "$0" = "-bash" ]; then
	echo "Please run this script from a bash shell (simply type ``bash``)"
	return
fi

# We assume the cwd is the scripts folder
CACHE_DIR="${HOME}/.qf-buildbot"
SCRIPT_DIR="${PWD}"
BUILD_DIR="${PWD}/../tmp"
INCLUDE_DIR="${PWD}/../inc"
RELEASE_DIR="${PWD}/../release"
RELEASE_ID="$(date +%Y%m%d)"


if [ -z "$2" ]; then
    MAKE_TARGETS="all"
else
    MAKE_TARGETS="${@:2}"
fi

MAKE_TARGETS="all"

updateGit() {
    if [ ! -d "${CACHE_DIR}/${PROJECT}" ]; then
        git clone -b "${GIT_BRANCH}" "${GIT_URL}" "${CACHE_DIR}/${PROJECT}"
    else
        cd "${CACHE_DIR}/${PROJECT}"
        git checkout "${GIT_BRANCH}"
        git pull
    fi
}

cleanDir() {
    cd "${BUILD_DIR}"
    rm -rf "libsrcs" "source"
    cp -r "${CACHE_DIR}/${PROJECT}/libsrcs" "${CACHE_DIR}/${PROJECT}/source" "./"
    cd "${BUILD_DIR}/tools/cross_compile"
}

echo "> *********************************************************"
echo "> * Downloading source"
echo "> *********************************************************"

mkdir -p "${BUILD_DIR}" && cd "$_"

if [[ "$1" == "warsow" ]]; then
    PROJECT="warsow_14"
    BASE_DIR="${RELEASE_DIR}/basewsw"
    SDK_FILE="warsow_14_sdk.tar.gz"
    SDK_URL="http://www.warsow.eu/${SDK_FILE}"

    if [ ! -e "${CACHE_DIR}/${SDK_FILE}" ]; then
        wget -O "${CACHEDIR}/${SDK_FILE}" "${SDK_URL}"
    fi
    tar -xvf "${CACHE_DIR}/${SDK_FILE}" "source"
    mv "source" "${PROJECT}"

elif [[ "$1" == "racesow" ]]; then
    PROJECT="racesow"
    BASE_DIR="${RELEASE_DIR}/racesow"
    GIT_URL="http://github.com/MGXRace/racesow"
    GIT_BRANCH="master"
    updateGit

else
    PROJECT="qfusion"
    BASE_DIR="${RELEASE_DIR}/base"
    GIT_URL="http://github.com/viciious/qfusion"
    GIT_BRANCH="master"
    updateGit
fi

echo "> *********************************************************"
echo "> * Setting up build environment"
echo "> *********************************************************"

mkdir -p "${BUILD_DIR}/tools"
mkdir -p "${RELEASE_DIR}"
cp -r "${INCLUDE_DIR}/cross_compile" "${BUILD_DIR}/tools/cross_compile"

echo "> *********************************************************"
echo "> * Building Linux x64"
echo "> *********************************************************"

cleanDir
. compile_libs.sh "lin" "x64"
. compile_source.sh "lin" "x64" "${MAKE_TARGETS}"
cp -r ${BUILD_DIR}/source/release/* "${RELEASE_DIR}/"

echo "> *********************************************************"
echo "> * Building Linux x86"
echo "> *********************************************************"

cleanDir
schroot -c wheezy-i386 compile_libs.sh "lin" "x86"
schroot -c wheezy-i386 compile_source.sh "lin" "x86" "${MAKE_TARGETS}"
cp -r ${BUILD_DIR}/source/release/* "${RELEASE_DIR}/"

echo "> *********************************************************"
echo "> * Building Win32 x86"
echo "> *********************************************************"

cleanDir
. compile_libs.sh "win32" "x64"
. compile_source.sh "win32" "x64" "${MAKE_TARGETS}"
cp -r ${BUILD_DIR}/source/release/* "${RELEASE_DIR}/"

echo "> *********************************************************"
echo "> * Building Win32 x86"
echo "> *********************************************************"

cleanDir
. compile_libs.sh "win32" "x86"
. compile_source.sh "win32" "x86" "${MAKE_TARGETS}"
cp -r ${BUILD_DIR}/source/release/* "${RELEASE_DIR}/"

echo "> *********************************************************"
echo "> * Packaging Builds"
echo "> *********************************************************"

cd ${SCRIPT_DIR}
zip -j ${BASE_DIR}/modules_${RELEASE_ID}_pure.pk3 ${BASE_DIR}/{cgame*,game*,ui*}
rm -f ${BASE_DIR}/{cgame*,game*,ui*}
tar -pczf "${PROJECT}-${RELEASE_ID}.tar.gz" ${RELEASE_DIR}/*

echo "> *********************************************************"
echo "> * Cleaning working files"
echo "> *********************************************************"

rm -rf "${BUILD_DIR}" "${RELEASE_DIR}"
