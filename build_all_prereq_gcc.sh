#!/bin/bash
. prereq_gcc_configure.sh
. prereq_gcc_env_setup.sh

# Build prerequisites
. jemalloc_build.sh
. openmpi_gcc_build.sh
. hdf5_gcc_build.sh
. pnetcdf_gcc_build.sh 
. netcdf_gcc_build.sh

# Generate set environment file
. prereq_gcc_setenv.sh
