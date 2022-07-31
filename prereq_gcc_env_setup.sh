#!/bin/bash

set -exu

mkdir -p ${INSTALL_DIR} ${SOURCES_DIR} ${BUILD_DIR}

#Compiler
 export PATH=${COMPILERHOME}/bin:${PATH}
 export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+}:${COMPILERHOME}/lib:${COMPILERHOME}/lib32
 export INCLUDE=${INCLUDE:+}:${COMPILERHOME}/include

#$COMPILERBIN/${CC} -v

if [[ $? -ne 0 ]];
then
        echo "Error: '$COMPILERHOME/bin/$CC} -v' returns non-zero. Set the Path of GCC path"
        return
        exit 1
fi

#OpenMPI 
 export PATH=${MPI_DIR}/bin:${PATH}
 export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MPI_DIR}/lib:${MPI_DIR}/lib64
 export INCLUDE=${INCLUDE}:${MPI_DIR}/include

#PNETCDF
 export PATH=${PNETCDF_DIR}/bin:${PATH}
 export LD_LIBRARY_PATH=${PNETCDF_DIR}/lib/:${LD_LIBRARY_PATH}
 export INCLUDE=${PNETCDF_DIR}/include:${INCLUDE}

 export PnetCDF_Fortran_LIBRARY=${PNETCDF_DIR}/lib
 export PnetCDF_Fortran_INCLUDE_DIR=${PNETCDF_DIR}/include

#HDF5
 export PATH=${HDF5_DIR}/bin:${PATH}
 export LD_LIBRARY_PATH=${HDF5_DIR}/lib:${HDF5_DIR}/lib64:${LD_LIBRARY_PATH}
 export INCLUDE=${HDF5_DIR}/include:${INCLUDE}

#NetCDF-C and NetCDF Fortran
 export PATH=${NETCDF_DIR}/bin:${PATH}
 export LD_LIBRARY_PATH=${NETCDF_DIR}/lib:${NETCDF_DIR}/lib64:${LD_LIBRARY_PATH}
 export INCLUDE=${NETCDF_DIR}/include:${INCLUDE}
