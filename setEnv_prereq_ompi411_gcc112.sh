#This file can be used to set up the environment required for application execution 


export COMPILER=gcc112
export MPI=ompi411

export HDF5=/home/hpc/apps/hdf5/ompi411/gcc112/1.10.8
export PNETCDF=/home/hpc/apps/pnetcdf/ompi411/gcc112/1.11.2
export NETCDF=/home/hpc/apps/netcdf/ompi411/gcc112/4.7.4
export JEMALLOC=/home/hpc/apps/jemalloc/5.2.1


export PATH=/home/hpc/apps/netcdf/ompi411/gcc112/4.7.4/bin:/home/hpc/apps/hdf5/ompi411/gcc112/1.10.8/bin:/home/hpc/apps/pnetcdf/ompi411/gcc112/1.11.2/bin:/home/hpc/apps/openmpi/gcc112/4.1.1/bin:/home/hpc/apps/gcc/11.2/bin:/opt/intel/oneapi/vtune/2022.3.0/bin64:/opt/intel/oneapi/vtune/2022.3.0/bin64:/opt/libs/mkmod-2.2/mkmod/bin:/opt/libs/modules-5.1.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap/bin:${PATH}
export LD_LIBRARY_PATH=/home/hpc/apps/netcdf/ompi411/gcc112/4.7.4/lib:/home/hpc/apps/netcdf/ompi411/gcc112/4.7.4/lib64:/home/hpc/apps/hdf5/ompi411/gcc112/1.10.8/lib:/home/hpc/apps/hdf5/ompi411/gcc112/1.10.8/lib64:/home/hpc/apps/pnetcdf/ompi411/gcc112/1.11.2/lib/::/home/hpc/apps/gcc/11.2/lib:/home/hpc/apps/gcc/11.2/lib32:/home/hpc/apps/openmpi/gcc112/4.1.1/lib:/home/hpc/apps/openmpi/gcc112/4.1.1/lib64:${LD_LIBRARY_PATH}
export INCLUDE=/home/hpc/apps/netcdf/ompi411/gcc112/4.7.4/include:/home/hpc/apps/hdf5/ompi411/gcc112/1.10.8/include:/home/hpc/apps/pnetcdf/ompi411/gcc112/1.11.2/include::/home/hpc/apps/gcc/11.2/include:/home/hpc/apps/openmpi/gcc112/4.1.1/include:${INCLUDE}

