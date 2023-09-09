module load daint-mc
module switch PrgEnv-cray PrgEnv-intel
module load PrgEnv-intel #this in case PrgEnv-cray is not currently loaded

## looking for compilers and libraries from intel.

## executable compiled: p2y, yambo, yambo_sc, ypp

### note that at the current stage, yambo_sc works only intranode
### note that hdf5 par-io support should be disable

DIRectory=/opt/intel/mkl/lib/intel64

./configure CPP=cpp CC=cc FC=ftn F77=ftn F90=ftn MPICC=cc PFC=ftn FPP="cpp -E -traditional" FCFLAGS='-O3 -g -nofor_main' --enable-time-profile --enable-open-mp --with-blas-libs="-L$DIRectory -lmkl_intel_lp64  -lmkl_sequential -lmkl_core" --with-blacs-libs="-L$DIRectory -lmkl_blacs_intelmpi_lp64" --with-scalapack-libs="-L$DIRectory -lmkl_scalapack_lp64" --with-lapack-libs="-L$DIRectory -lmkl_intel_lp64  -lmkl_sequential -lmkl_core" --disable-hdf5-par-io
