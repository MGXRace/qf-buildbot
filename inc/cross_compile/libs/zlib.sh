#!/bin/sh

MORE_OPTS=""
[ "$ENABLE_SHARED" != "YES" ] && MORE_OPTS="${MORE_OPTS} --static"

cd ${SOURCE_DIR}libsrcs/zlib && \
./configure --libdir={$LIB_DIR} --includedir=${INCLUDE_DIR} \
$MORE_OPTS && \
${MAKE} clean && \
${MAKE}

cp libz.a "${TARGET_DIR}libzstat.a"
if [ "$ENABLE_SHARED" = "YES" ]; then
	cp libz.$SHARED_LIBRARY_EXT "${TARGET_DIR}"
fi

mkdir -p include ; rm include/* ; cp -f *.h include/
mkdir -p lib ; rm lib/* ; cp -f libz.${SHARED_LIBRARY_EXT}* lib ; cp -f libz.a lib
