module switch PrgEnv-cray PrgEnv-intel
module load cray-netcdf

## looking for compilers and libraries from intel.
#/opt/intel/compilers_and_libraries/linux/mkl/lib/intel64/ #

## executable compiled: p2y, yambo, yambo_sc, ypp

./configure \
CPP=cpp \
CC=cc \
FC=ftn \
F77=ftn \
F90=ftn \
MPICC=cc \
PFC=ftn \
FPP="cpp -E -traditional" \
FCFLAGS='-O3 -g -nofor_main' \
--enable-time-profile \
--enable-open-mp \
--with-blas-libs="-L/opt/intel/compilers_and_libraries/lin/14.0.1.106/mkl/lib/intel6ux/mkl/lib/intel64/ -lmkl_intel_lp64  -lmkl_sequential -lmkl_core" \
--with-blacs-libs="-L/opt/intel/compilers_and_libraries/lin/14.0.1.106/mkl/lib/intel6ux/mkl/lib/intel64/-lmkl_blacs_intelmpi_lp64" \
--with-scalapack-libs="-L/opt/intel/compilers_and_libraries/lin/14.0.1.106/mkl/lib/intel6ux/mkl/lib/intel64/ -lmkl_scalapack_lp64" \
--with-lapack-libs="-L/opt/intel/compilers_and_libraries/lin/14.0.1.106/mkl/lib/intel6ux/mkl/lib/intel64/ -lmkl_intel_lp64  -lmkl_sequential -lmkl_core" \
--with-netcdf-path=$NETCDF_DIR \
--with-hdf5-path="/opt/cray/pe/hdf5/default/INTEL/19.1" \
--with-fft-libs="-mkl"
