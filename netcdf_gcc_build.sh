#!/bin/bash

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                Building netcdf                                       #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

export build_netcdfc_packname=netcdf-c-$NETCDFC_VERS
export build_netcdff_packname=netcdf-fortran-$NETCDFF_VERS

export netcdfc_packname=$build_netcdfc_packname
export netcdff_packname=$build_netcdff_packname

date=$(date | perl -pe 's/\s+/_/g;s/_$//;s/://g')

buildlog=buildlog.$netcdfc_packname.$netcdff_packname.$USER.$(hostname -s).$(hostname -d).$date.txt
{
	set -eux

	export FC=$MPIF90
	export CC=$MPICC
	export CXX=$MPICXX

	export CFLAGS="$CFLAGS -I${MPI_DIR}/include -I${HDF5_DIR}/include -I${PNETCDF_DIR}/include -I${NETCDF_DIR}/include"
	export CPPFLAGS="$CXXFLAGS -I${MPI_DIR}/include -I${HDF5_DIR}/include -I${PNETCDF_DIR}/include -I${NETCDF_DIR}/include"
	export LDFLAGS="-L${MPI_DIR}/lib -L${MPI_DIR}/lib64 -L${HDF5_DIR}/lib -L${HDF5_DIR}/lib64 -L${PNETCDF_DIR}/lib -L${PNETCDF_DIR}/lib64 -L${NETCDF_DIR}/lib -L${NETCDF_DIR}/lib64 "

	if [ -d "${NETCDF_DIR}" ] && { [ -e "${NETCDF_DIR}/lib/libnetcdf.a" ] || [ -e "${NETCDF_DIR}/lib64/libnetcdf.a" ] || [ -e "${NETCDF_DIR}/lib64/libnetcdf.so" ]; }
	then
		echo
		echo "Netcdf Fortran $NETCDFF_VERS already installed"
	else
		netcdfc_archive=$netcdfc_packname.tar.gz

		if [  -f "${SOURCES_DIR}/$netcdfc_archive" ]
		then
			echo "$netcdfc_packname source file found in ${SOURCES_DIR}"
		else
			cd ${SOURCES_DIR}
			echo "Downloading $netcdfc_packname"
			wget https://github.com/Unidata/netcdf-c/archive/v$NETCDFC_VERS.tar.gz -O $netcdfc_archive
		fi

		cd ${BUILD_DIR}
		rm -rf $netcdfc_packname

		tar xf ${SOURCES_DIR}/$netcdfc_archive
		echo " Building $netcdfc_packname"

		cd $netcdfc_packname

		./configure --with-hdf5=${HDF5_DIR} --enable-dynamic-loading --enable-netcdf-4 --enable-shared --enable-pnetcdf --disable-dap --prefix=${NETCDF_DIR} 2>&1 | tee configure.log
		make -j 16 2>&1 | tee make.log

		make install -j 16 2>&1 | tee make-install.log

		make clean
	fi

	if  [ -f ${NETCDF_DIR}/lib/libnetcdf.a ] || [ -e "${NETCDF_DIR}/lib64/libnetcdf.a" ];
	then
		echo " Building $netcdfc_packname is SUCCESSFUL "
	else
		echo " Building $netcdfc_packname is UNSUCCESSFUL "
		echo " --- Please check : ${BUILD_DIR}/$buildlog ---"
		cd ${WORK_DIR}
		exit 1
	fi


	if [ -d "${NETCDF_DIR}" ] && { [ -e "${NETCDF_DIR}/lib/libnetcdff.so" ] || [ -e "${NETCDF_DIR}/lib64/libnetcdff.so" ] || [ -e "${NETCDF_DIR}/lib64/libnetcdff.so" ]; }
	then
		echo
		echo "Netcdf Fortran $NETCDFF_VERS already installed"

		export PATH=${NETCDF_DIR}/bin:${PATH}
		export LD_LIBRARY_PATH=${NETCDF_DIR}/lib:${NETCDF_DIR}/lib64:${LD_LIBRARY_PATH}
		export INCLUDE=${NETCDF_DIR}/include:${INCLUDE}
	else
		netcdff_archive=$netcdff_packname.tar.gz

		if [  -f "${SOURCES_DIR}/$netcdff_archive" ]
		then
			echo "$netcdff_packname source file found in ${SOURCES_DIR}"
		else
			cd ${SOURCES_DIR}
			echo "Downloading netcdff_packname"
			wget https://github.com/Unidata/netcdf-fortran/archive/v$NETCDFF_VERS.tar.gz -O $netcdff_archive
		fi

		cd ${BUILD_DIR}
		rm -rf $netcdff_packname

		tar xf ${SOURCES_DIR}/$netcdff_archive
		echo " Building $netcdff_packname"

		cd $netcdff_packname

		./configure --prefix=${NETCDF_DIR} --enable-shared 2>&1 | tee configure.log
		sed -i -e 's#wl=""#wl="-Wl,"#g' libtool
		sed -i -e 's#pic_flag=""#pic_flag=" -fPIC -DPIC"#g' libtool

		make 2>&1 | tee make.log

		make install 2>&1 | tee make-install.log

		make clean
	fi

	if  [ -f ${NETCDF_DIR}/lib/libnetcdff.a ] || [ -e "${NETCDF_DIR}/lib64/libnetcdff.so" ];
	then
		echo " Building $netcdff_packname is SUCCESSFUL "
	else
		echo " Building $netcdff_packname is UNSUCCESSFUL "
		echo " --- Please check : ${BUILD_DIR}/$buildlog ---"
		cd ${WORK_DIR}
		exit 1
	fi

	export PATH=${NETCDF_DIR}/bin:${PATH}
	export LD_LIBRARY_PATH=${NETCDF_DIR}/lib:${NETCDF_DIR}/lib64:${LD_LIBRARY_PATH}
	export INCLUDE=${NETCDF_DIR}/include:${INCLUDE}

} 2>&1 | tee $BUILD_DIR/$buildlog

