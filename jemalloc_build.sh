#!/bin/bash

export build_packname=jemalloc-${JEMALLOC_VERS}
export jemalloc_packname=$build_packname

date=$(date | perl -pe 's/\s+/_/g;s/_$//;s/://g')

buildlog=buildlog.$jemalloc_packname.$USER.$(hostname -s).$(hostname -d).$date.txt

{
	set -eux
	if [ -d "$JEMALLOC_DIR" ]  && { [ -e "$JEMALLOC_DIR/lib/libjemalloc.so" ] || [ -e "$JEMALLOC_DIR/lib64/libjemalloc.so" ]; }
	then
		echo " --- JEMALLOC is here : $JEMALLOC_DIR"
	else 
		echo " --- JEMALLOC is not here : $JEMALLOC_DIR"
		echo " --- JEMALLOC build and install ... "

		jemalloc_vers=${JEMALLOC_VERS}.tar.gz
		jemalloc_archive=${jemalloc_packname}.tar.gz

		
		if [ ! -e ${SOURCES_DIR}/$jemalloc_archive ]
		then
			cd  ${SOURCES_DIR}
			echo --- $jemalloc_archive is not found in ${SOURCES_DIR}/ directory.
			wget -P ${SOURCES_DIR} https://github.com/jemalloc/jemalloc/archive/refs/tags/${jemalloc_vers}
			mv  ${jemalloc_vers} ${jemalloc_archive}
		fi 
		
		cd $BUILD_DIR
		rm -rf ${jemalloc_packname}

		tar -xf ${SOURCES_DIR}/$jemalloc_archive

		cd ${jemalloc_packname}

		./autogen.sh CC=gcc CFLAGS="-O3" CXX=g++ CXXFLAGS="-O3" --prefix=${JEMALLOC_DIR} |tee autoconf.log
		./configure  CC=gcc CFLAGS="-O3" CXX=g++ CXXFLAGS="-O3" --prefix=${JEMALLOC_DIR} |tee configure.log

		make -j 2>&1|tee make.log

		make install 2>&1|tee make_install.log
	fi

	#Checking for installtion success 
	if [ -e "$JEMALLOC_DIR/lib/libjemalloc.so" ] || [ -e "$JEMALLOC_DIR/lib64/libjemalloc.so" ];
	then
		echo "$jemalloc_packname built successfully."
	else
		echo "$jemalloc_packname failed."
		echo " --- Please check : ${BUILD_DIR}/$buildlog ---"
                cd ${WORK_DIR}
		exit 1
	fi

	export LD_LIBRARY_PATH=$JEMALLOC_DIR/lib:$JEMALLOC_DIR/li64:$LD_LIBRARY_PATH
	export C_INCLUDE_PATH=$JEMALLOC_DIR/include:$C_INCLUDE_PATH

} 2>&1 | tee $BUILD_DIR/$buildlog
