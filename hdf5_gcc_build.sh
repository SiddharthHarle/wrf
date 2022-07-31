#!/bin/bash

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                Building HDF5                                         #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

export build_packname=hdf5-${HDF5_VERS}
export hdf5_packname=${build_packname}

date=$(date | perl -pe 's/\s+/_/g;s/_$//;s/://g')

buildlog=buildlog.${hdf5_packname}.$USER.$(hostname -s).$(hostname -d).$date.txt

{
	set -eux
	if [ -d "${HDF5_DIR}" ] && { [ -e "${HDF5_DIR}/lib/libhdf5.a" ] || [ -e "${HDF5_DIR}/lib64/libhdf5.a" ]; }
	then
		echo
		echo "Path for HDF5 exist"
	else

		export CXXFLAGS=-I${MPI_DIR}/include
		export LDFLAGS="-L${MPI_DIR}/lib -L${MPI_DIR}/lib64 "

		echo
		echo "Path for HDF5 not found"

		hdf5_archive=${hdf5_packname}.tar.gz

		if [  -f "${SOURCES_DIR}/$hdf5_archive" ]
		then
			echo "${hdf5_packname} source file found in ${SOURCES_DIR}"
		else
			cd ${SOURCES_DIR}
			echo "Downloading ${hdf5_packname}"
			wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDF5_VERS::-2}/${hdf5_packname}/src/$hdf5_archive
		fi

		cd ${BUILD_DIR}
		rm -rf ${hdf5_packname}

		echo " Building ${hdf5_packname}"

		tar xf ${SOURCES_DIR}/$hdf5_archive
		cd ${hdf5_packname}

		export FC=$MPIF90
		export CC=$MPICC
		export CXX=$MPICXX
		#export FCFLAGS="-mllvm --max-speculation-depth=0 -Mextend -ffree-form $FCFLAGS"

		./configure  --prefix=${HDF5_DIR} CFLAGS="$CFLAGS" FCFLAGS="$FCFLAGS" --enable-fortran --enable-parallel --enable-hl --enable-shared 2>&1 | tee configure.log

		#sed -i -e 's#wl=""#wl="-Wl,"#g' libtool
		#sed -i -e 's#pic_flag=""#pic_flag=" -fPIC -DPIC"#g' libtool


		rc=${PIPESTATUS[0]}
		[[ $rc -eq 0 ]] || exit $rc

		make -j  2>&1 | tee make.log

		rc=${PIPESTATUS[0]}
		[[ $rc -eq 0 ]] || exit $rc

		make install 2>&1 | tee make-install.log

		rc=${PIPESTATUS[0]}
		[[ $rc -eq 0 ]] || exit $rc

		make clean
	fi

	if  [ -f ${HDF5_DIR}/lib/libhdf5.a ] || [ -e "${HDF5_DIR}/lib64/libhdf5.a" ] ;
	then
		echo " Building ${hdf5_packname} is SUCCESSFUL"
		export PATH=${HDF5_DIR}/bin:${PATH}
		export LD_LIBRARY_PATH=${HDF5_DIR}/lib:${HDF5_DIR}/lib64:${LD_LIBRARY_PATH}
		export INCLUDE=${HDF5_DIR}/include:${INCLUDE}

		export LDFLAGS+="-L${HDF5_DIR}/lib -L${HDF5_DIR}/lib64"
		export CFLAGS+="-I${HDF5_DIR}/include"
	else
		echo " Building ${hdf5_packname} is UNSUCCESSFUL "
		echo " --- Please check : ${BUILD_DIR}/$buildlog ---"
		cd ${WORK_DIR}
		exit 1
	fi

	cd $WORK_DIR

} 2>&1 | tee $BUILD_DIR/$buildlog
