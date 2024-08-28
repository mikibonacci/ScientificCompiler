# How to compile Quantum ESPRESSO and Yambo in a conda environment

The following are instructions on how to prepare a conda env (python virtual environment) to then compile Quantum ESPRESSO and Yambo, 
and run parallel calculations.

```shell
conda create -n codes python=3.11
conda activate codes
```

Once activated the environment, you can proceed with the following sections. 
Each time you run a calculation, you need the environment to be activated, to have the correct modules...


## Prepare a working openmpi env:

```shell
conda install openmpi hdf5=*=*openmpi*  fftw=*=*openmpi* libxc=*=*cpu* libnetcdf=*=*openmpi* netcdf-fortran=*=*openmpi* libblas lapack scalapack gfortran

conda install -c conda-forge ucx # to have correct MPI communication setup and run in parallel.
```

OR conda install yambo, to directly download the executables from the conda-forge... but I prefer to compile it by hands (see below sections).

## How to install Quantum ESPRESSO

Download the Quantum ESPRESSO source from gitlab

```shell
./install/configure --with-hdf5 --enable-openmp 
```

## How to install Yambo 

A comment on the configure: conda install the dynamic netcdf lib (you know it noticing that in the lib, it is *.so and not *.a, the latter being the static version. Yambo by default does not find the dynamical one, you have to explicitely tell him. like in the line below.)

```shell
export PATH_YAMBO_LIB="/home/jovyan/.conda/envs/codes/" # the path to your venv: check it via "conda env list"

./configure --enable-mpi --enable-open-mp --with-fft-path=$PATH_YAMBO_LIB --with-hdf5-path=$PATH_YAMBO_LIB --with-netcdf-libs=$PATH_YAMBO_LIB/lib/libnetcdf.so --with-netcdff-libs=$PATH_YAMBO_LIB/lib/libnetcdff.so --disable-hdf5-par-io --with-libxc-path=$PATH_YAMBO_LIB --with-scalapack-libs=$PATH_YAMBO_LIB/lib/libscalapack.so --with-blacs-libs=$PATH_YAMBO_LIB/lib/libscalapack.so --enable-par-linalg
```

### Special instructions on how to run:

Follow this, if you have trouble in running in parallel:

```shell
mpirun --mca btl_vader_single_copy_mechanism none  -np 2 /home/jovyan/codes/q-e-kcw/bin/pw.x < Si.scf.in > prova.out
```

## because:

```shell
^C^C(codes) jovyan@6f222c4867e7:~/work/koopmans_calcs/interface_yambo/trial_Si/BANDS/KI_uniq$ mpirun --mca btl_vader_single_copy_mechanism 0 -np 2 /home/jovyan/codes/q-e-kcw/bin/pw.x < Si.scf.in > prova.out
--------------------------------------------------------------------------
An invalid value was supplied for an enum variable.

  Variable     : btl_vader_single_copy_mechanism
  Value        : 0
  Valid values : 1:"cma", 4:"emulated", 3:"none"
--------------------------------------------------------------------------
--------------------------------------------------------------------------
WARNING: Linux kernel CMA support was requested via the
btl_vader_single_copy_mechanism MCA variable, but CMA support is
not available due to restrictive ptrace settings.

The vader shared memory BTL will fall back on another single-copy
mechanism if one is available. This may result in lower performance.

  Local host: 6f222c4867e7
```
