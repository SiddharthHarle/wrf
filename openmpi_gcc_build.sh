#!/bin/bash

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                Building openmpi                                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

build_packname=${MPI_LIBRARY}-${MPI_VERS}
mpi_packname=${build_packname}

echo " --- MPIPACKNAME : ${mpi_packname}"
date=$(date | perl -pe 's/\s+/_/g;s/_$//;s/://g')

buildlog=buildlog.${build_packname}.$USER.$(hostname -s).$(hostname -d).$date.txt

{
	set -eux

	echo "Checking for PATH of OpenMPI... "

	if [ -d "$MPI_DIR" ] && [ -e "$MPI_DIR/bin/$MPICC" ] 
	then
		echo
		echo " --- PATH for OpenMPI exists: $MPI_DIR"
		echo
	else
		echo
		echo " --- Path for OpenMPI not found."
		mpi_archive=${mpi_packname}.tar.bz2 

		if [  -f "${SOURCES_DIR}/${mpi_archive}" ]
		then
			echo "${mpi_packname} source file found in ${SOURCES_DIR}"
		else
			echo "Downloading ${mpi_packname}"
			wget -P ${SOURCES_DIR} https://download.open-mpi.org/release/open-mpi/v${MPI_VERS::-2}/${mpi_archive}
		fi	

		cd ${BUILD_DIR}
		rm -rf ${mpi_packname}

		echo " Building ${mpi_packname} in $PWD "

		tar xvf ${SOURCES_DIR}/${mpi_archive}

		cd ${mpi_packname}
		#Configuring MPI library
		./configure --prefix=${MPI_DIR} CC=${CC} CXX=${CXX} FC=${FC} \
			CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" FCFLAGS="$FCFLAGS" \
			--enable-mpi-fortran --enable-shared=yes --enable-static=yes  \
			--enable-mpi1-compatibility --disable-hwloc-pci  \
			--enable-builtin-atomics --enable-mpi-cxx   
#			--with-ucx=/home/software/ucx/1.11.0 --with-hcoll=/opt/mellanox/hcoll --with-knem=/opt/knem-1.1.4.90mlnx1 --with-xpmem=/home/software/xpmem/2.3.0 --with-hwloc=/home/software/hwloc/2.3.0 --with-pmix --with-slurm
#			--with-hcoll=/opt/mellanox/hcoll \
#			--with-knem=/opt/knem-1.1.4.90mlnx1 \
#			--with-xpmem=/home/software/xpmem/2.3.0
		#	--with-ucx=/home/software/ucx/1.11.0 \
			2>&1 | tee  log.0

		rc=${PIPESTATUS[0]}
		[[ $rc -eq 0 ]] || exit $rc

		make -j 2>&1| tee log.1

		rc=${PIPESTATUS[0]}
		[[ $rc -eq 0 ]] || exit $rc

		make install -j 2>&1 | tee  log.2

		rc=${PIPESTATUS[0]}
		[[ $rc -eq 0 ]] || exit $rc

	fi

	if [ -d "$MPI_DIR" ] && [ -e "$MPI_DIR/bin/$MPICC" ] 
	then
		export PATH=${MPI_DIR}/bin:${PATH}
		export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MPI_DIR}/lib:${MPI_DIR}/lib64
		export INCLUDE=${INCLUDE}:${MPI_DIR}/include

		echo " --- ###################################### --- "
		echo " MPI details : "
		which $MPICC
		ompi_info --version
		echo " --- ###################################### --- "
	else
		echo "${mpi_packname} installtion failed. Please reinstall ${mpi_packname} again".
		echo " --- Please check : ${BUILD_DIR}/$buildlog ---"
		cd ${WORK_DIR}
		exit 1
	fi
		cd ${WORK_DIR}

} 2>&1 | tee ${BUILD_DIR}/$buildlog
