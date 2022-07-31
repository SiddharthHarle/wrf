#!/bin/bash

#---------------------------------------------------------------------------------------#
# Users are requested to provide compilation related details.                           #
# Syntax to Run the script:                                                             #
#                                                                                       #
#       $ bash build_all_prereq_gcc.sh                                                  #
#                                                                                       #
#       Supported Compiler : GCC                                                        #
#       Supported Parallelism : MPI                                                     #
#---------------------------------------------------------------------------------------#

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                COMPILER SETTINGS                                     #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

# Set compiler path and name
export COMPILER_NAME=gcc
export COMPILER_VERS=11.2

export HOME=/home/hpc
export COMPILERHOME=${HOME}/apps/${COMPILER_NAME}/${COMPILER_VERS}
export COMPILERBIN=${COMPILERHOME}/bin
export COMPILERNAME=${COMPILER_NAME}`echo ${COMPILER_VERS} | tr -dc "[:digit:]"`


#Setting up the compiler
export CC=gcc
export CXX=g++
export F90=gfortran
export F77=gfortran
export FC=gfortran

ARCH="-march=znver3"
OMP=" " #"-fopenmp"


#Setting up the compiler flags
export CFLAGS="-O3 ${ARCH} ${OMP} -fPIC"
export CXXFLAGS="-O3 ${ARCH} ${OMP} -fPIC"
export FCFLAGS="-O3 ${ARCH} ${OMP} -fPIC -std=legacy"
export FFLAGS="-O3 ${ARCH} ${OMP} -fPIC -std=legacy"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                MPI Settings                                          #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

#Set MPI libray and version
export MPI_LIBRARY=openmpi
export MPI_VERS=4.1.1
export MPI_NAME=ompi`echo ${MPI_VERS} | tr -dc "[:digit:]"`

#MPI compiler setting
export MPICC=mpicc      #MPICC:     MPI C compiler command
export MPICXX=mpiCC     #MPICXX:    MPI C++ compiler command
export MPIFC=mpifort    #MPIFC:     MPI Fortran compiler command
export MPIF90=mpif90    #MPIF90:    MPI Fortran-90(F90) compiler command
export MPIF77=mpif77    #MPIF77:    MPI Fortran-77(F77) compiler command

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                                Prerequiste Settings                                  #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

export WORK_DIR=${PWD}

# Application specific builds, sources  and prerequisites installation paths etc
export PREFIX_PATH=${HOME}/apps

# Path for source directory where all archives are kept or will be downloaded
export SOURCES_DIR=${PREFIX_PATH}/sources

# Path for build directory where all compiler specific builds and logs are kept
export BUILD_DIR=${PREFIX_PATH}/build/${MPI_NAME}/${COMPILERNAME}

# Path for all prerequisites installations
export INSTALL_DIR=${PREFIX_PATH}

# Please provide MPI Library install directory, if installed already
export MPI_DIR=${INSTALL_DIR}/${MPI_LIBRARY}/${COMPILERNAME}/${MPI_VERS}

# JEMALLOC Setting
export JEMALLOC_VERS=5.2.1
export JEMALLOC_DIR=${INSTALL_DIR}/jemalloc/${JEMALLOC_VERS}

# HDF5 Settings
export HDF5_VERS=1.10.8
export HDF5_DIR=${INSTALL_DIR}/hdf5/${MPI_NAME}/${COMPILERNAME}/${HDF5_VERS}

# PNETCDF Settings
export PNETCDF_VERS=1.11.2
export PNETCDF_DIR=${INSTALL_DIR}/pnetcdf/${MPI_NAME}/${COMPILERNAME}/${PNETCDF_VERS}

# NETCDF-C and NETCDF-FORTRAN Settings 
# NETCDF-C Version
export NETCDFC_VERS=4.7.4

# NETCDF-FORTRAN Version
export NETCDFF_VERS=4.5.3

export NETCDF_DIR=${INSTALL_DIR}/netcdf/${MPI_NAME}/${COMPILERNAME}/${NETCDFC_VERS}
