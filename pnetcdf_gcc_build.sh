#!/bin/bash

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                Building Pnetcdf                                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	
build_packname=pnetcdf-${PNETCDF_VERS}
pnc_packname=${build_packname}

echo " --- PNCPACKNAME : ${pnc_packname}"
date=$(date | perl -pe 's/\s+/_/g;s/_$//;s/://g')

buildlog=buildlog.${build_packname}.$USER.$(hostname -s).$(hostname -d).$date.txt

{
	set -eux

	export FC=$MPIF90
        export CC=$MPICC
        export CXX=$MPICXX
	
	echo "Checking for PATH of PNETCDF... "

	if [ -d "${PNETCDF_DIR}" ] && [ -e "${PNETCDF_DIR}/lib/libpnetcdf.so" ] 
	then
		echo
		echo " --- PATH for PNETCDF exists: ${PNETCDF_DIR}"
		echo
	else
		echo
		echo " --- Path for PNETCDF not found."
		pnc_archive=${pnc_packname}.tar.gz 

		if [  -f "${SOURCES_DIR}/${pnc_archive}" ]
		then
			echo "${pnc_packname} source file found in ${SOURCES_DIR}"
		else
			echo "Downloading ${pnc_packname}"
			wget -P ${SOURCES_DIR} https://parallel-netcdf.github.io/Release/$pnc_archive
		fi	

		cd ${BUILD_DIR}
		rm -rf ${pnc_packname}

		echo " Building ${pnc_packname} in $PWD "

		tar xvf ${SOURCES_DIR}/${pnc_archive}

		cd ${pnc_packname}
		#Configuring PNETCDF library
		
			./configure --disable-cxx --enable-fortran=yes --enable-shared --prefix=${PNETCDF_DIR} 2>&1 | tee  log.0

		rc=${PIPESTATUS[0]}
		[[ $rc -eq 0 ]] || exit $rc

		make -j 16 2>&1| tee log.1

		rc=${PIPESTATUS[0]}
		[[ $rc -eq 0 ]] || exit $rc

		make install -j 16 2>&1 | tee  log.2

		rc=${PIPESTATUS[0]}
		[[ $rc -eq 0 ]] || exit $rc

	fi

	if [ -d "${PNETCDF_DIR}" ] && [ -e "${PNETCDF_DIR}/lib/libpnetcdf.a" ] 
	then
		export PATH=${PNETCDF_DIR}/bin:${PATH}
		export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${PNETCDF_DIR}/lib
		export INCLUDE=${INCLUDE}:${PNETCDF_DIR}/include
	
		echo " --- ###################################### --- "
		echo " PNETCDF installation done "
		echo " --- ###################################### --- "
	else
		echo "${pnc_packname} installtion failed. Please reinstall ${pnc_packname} again".
		echo " --- Please check : ${BUILD_DIR}/$buildlog ---"
		cd ${WORK_DIR}
		exit 1 
	fi
		cd ${WORK_DIR}

} 2>&1 | tee ${BUILD_DIR}/$buildlog
