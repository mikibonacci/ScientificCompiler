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

If you have problems with blacs, just deactivate scalapack support (as done below for kcp).

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

# How to compile `kcp.x`

Download the [last version](https://github.com/epfl-theos/koopmans-kcp.git) of the code. 
I suppose you are compiling the code in the same conda environment described above. 

```bash
git clone https://github.com/epfl-theos/koopmans-kcp.git
cd koopmans-kcp
export LD_LIBRARY_PATH=/home/jovyan/.conda/envs/codes/lib # this is fundamental
./configure --with-scalapack=no MPIF90=mpif90
```

Before, I was launching `./configure BLAS_LIBS="-L/home/jovyan/.conda/envs/codes/lib -lopenblas" LAPACK_LIBS="-L/home/jovyan/.conda/envs/codes/lib -llapack" FFT_LIBS="-L/home/jovyan/.conda/envs/codes/lib -lfftw3" --with-scalapack=no MPIF90=mpif90`, but in this way it does not put 

```bash
DFLAGS         =  -D__GFORTRAN -D__FFTW3 -D__MPI -D__PARA
```

in the make.sys... is like it is not putting the flags because you don't allow a checking, you provide explicitely the path.

Then modify the newly generated `make.sys` file:

```bash
IFLAGS         = -I/home/jovyan/codes/koopmans-kcp/include -I/home/jovyan/codes/koopmans-kcp/iotk/include
MODFLAGS       = -I./  -I/home/jovyan/codes/koopmans-kcp/Modules  -I/home/jovyan/codes/koopmans-kcp/iotk/src
```

Otherwise it will not find the modules and iotk library.
Then:

```bash
make kcp # not in parallel.
```

# How to solve the *There are not enough slots available in the system...*

This happens when we run *mpirun* asking for more processes than the available slots. 
Just look for the `/home/jovyan/.conda/envs/codes/etc/openmpi-default-hostfile`:

```bash
find /home/jovyan/.conda/envs/codes/* -name *hostfile
```

and add this line:

```bash
localhost slots=24
```

# If not enough memory... vader something

rm /dev/shm/vader*