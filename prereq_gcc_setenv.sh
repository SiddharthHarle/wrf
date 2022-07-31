export ENV_FILE=${WORK_DIR}/setEnv_prereq_${MPI_NAME}_${COMPILERNAME}.sh

#export PATH=${NETCDF}/bin:${PNETCDF}/bin:${HDF5}/bin:${PATH}
#export LD_LIBRARY_PATH=${NETCDF}/lib:${PNETCDF}/lib:${HDF5}/lib:${JEMALLOC}/lib:${LD_LIBRARY_PATH}
#export INCLUDE=${NETCDF}/include:${PNETCDF}/include:${HDF5}/include:${JEMALLOC}/include:${INCLUDE}
echo " --- ENVIRONMENT VARIABLE FILE : $ENV_FILE----------"
echo -e "#This file can be used to set up the environment required for application execution \n

export COMPILER=${COMPILERNAME}
export MPI=${MPI_NAME}

export HDF5=${HDF5_DIR}
export PNETCDF=${PNETCDF_DIR}
export NETCDF=${NETCDF_DIR}
export JEMALLOC=${JEMALLOC_DIR}


export PATH=${PATH}:\${PATH}
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:\${LD_LIBRARY_PATH}
export INCLUDE=${INCLUDE}:\${INCLUDE}
" >$ENV_FILE

chmod a+x ${ENV_FILE}
