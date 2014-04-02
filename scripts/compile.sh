#!/bin/bash
# We assume the cwd is the scripts folder
SCRIPT_DIR="${PWD}"
BUILD_DIR="${PWD}/../tmp"
INCLUDE_DIR="${PWD}/../inc"
RELEASE_DIR="${PWD}/../release"

PROJECT="qfusion"
GIT_URL="http://github.com/viciious/qfusion"
GIT_BRANCH="master"
SDK_FILE="warsow_14_sdk.tar.gz"
SDK_URL="http://www.warsow.eu/${SDK_FILE}"

cleanDir() {
    cd "${BUILD_DIR}"
    rm -rf "libsrcs" "source"
    cp -r "${PROJECT}/libsrcs" "${PROJECT}/source" "./"
    cd "${BUILD_DIR}/tools/cross_compile"
}

echo "> *********************************************************"
echo "> * Downloading source"
echo "> *********************************************************"

mkdir -p "${BUILD_DIR}" && cd "$_"

if [[ "$1" == "warsow" ]]; then
    PROJECT="warsow_14"
    wget "${SDK_URL}"
    tar -xvf "${SDK_FILE}" "source"
    mv "source" "${PROJECT}"
else
    git clone -b "${GIT_BRANCH}" "${GIT_URL}"
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
. compile_source.sh "lin" "x64"
cp -r ${BUILD_DIR}/source/release/* "${RELEASE_DIR}/"

echo "> *********************************************************"
echo "> * Building Linux x86"
echo "> *********************************************************"

cleanDir
schroot -c wheezy-i386 compile_libs.sh "lin" "x86"
schroot -c wheezy-i386 compile_source.sh "lin" "x86"
cp -r ${BUILD_DIR}/source/release/* "${RELEASE_DIR}/"

echo "> *********************************************************"
echo "> * Building Win32 x86"
echo "> *********************************************************"

cleanDir
. compile_libs.sh "win32" "x64"
. compile_source.sh "win32" "x64"
cp -r ${BUILD_DIR}/source/release/* "${RELEASE_DIR}/"

echo "> *********************************************************"
echo "> * Building Win32 x86"
echo "> *********************************************************"

cleanDir
. compile_libs.sh "win32" "x86"
. compile_source.sh "win32" "x86"
cp -r ${BUILD_DIR}/source/release/* "${RELEASE_DIR}/"

echo "> *********************************************************"
echo "> * Packaging Builds"
echo "> *********************************************************"

cd ${SCRIPT_DIR}
tar -pczf "${PROJECT}-$(date +%Y.%m.%d.%H.%M).tar.gz" "${RELEASE_DIR}/"

echo "> *********************************************************"
echo "> * Cleaning working files"
echo "> *********************************************************"

rm -rf "${BUILD_DIR}" "${RELEASE_DIR}"
