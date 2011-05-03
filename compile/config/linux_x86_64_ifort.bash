# $Id$
# Makefile definitions customized for Linux x86_64 using the Intel Fortran 
# compiler 


# Fortran 95 compiler and linker
FC=ifort
LD=ifort

# Define path to directories
dir=`pwd` # dir where this script resides
bindir="$dir/../bin"  # dir for Makefile and executable
objdir="$dir/../obj"  # dir for *.o and *.mod files
libdir="$dir/../lib"  # dir for *.a library files
srcdir="$dir/../src"  # dir where the source files reside

DEBUG="-g -traceback -check bounds -check uninit"

# == Warnings ==
WARNINGS="-warn -warn notruncated_source"

# == Machine specific options ==
ARCH="-msse2 -fp-model precise" # This should work on carson/steele (AMD Opteron)
#ARCH="-mssse3 -fp-model precise"# Core2 Duo (overlie)
# == Used to promote all real's to double precision ==
DOUBLE_PRECISION="-real-size 64"

# == Optimization ==
OPTIMIZE="-O3 -vec-report0"

# == NetCDF Location ==
NETCDF="/usr/local/netcdf-intel64"

# == LAPACK libraries ==
# Intel Math Kernel Library (v11.1)
MKLPATH="/opt/intel/Compiler/11.1/064/mkl/lib/em64t"
# Intel Math Kernel Library (v10)
#MKLPATH=/opt/intel/mkl/10.0.5.025/lib/em64t 
# Intel Math Kernel Library (v10.2)
#MKLPATH="/opt/intel/mkl/10.2.5.035/lib/em64t"
LAPACK="-L$MKLPATH -Wl,-rpath,$MKLPATH -lmkl_intel_lp64 -lmkl_sequential -lmkl_lapack -lmkl_solver_lp64 -lmkl_core -lguide -lpthread"
# (v8)
#LAPACK="-L/opt/intel/mkl/8.1/lib/64 -Wl,-rpath,/opt/intel/mkl/8.1/lib/64 -lmkl_lapack64 -lmkl_i2p -lmkl -lmkl_vml_i2p -lmkl_vml -lvml -lguide -lpthread"
# Generic library
#LAPACK="-llapack -lblas -lgfortran"
#LAPACK="-L/usr/local/lib -llapack -L/usr/local/atlas/lib -lf77blas -lcblas -latlas" # ATLAS BLAS (faster then generic library)

# == Linking Flags ==
# Use -s to strip (no debugging); 
# Use -L<library path> -l<lib> to link in an external library
LDFLAGS="-L$NETCDF/lib -lnetcdf $LAPACK"

FFLAGS="$ARCH $DEBUG"

# Preprocessing Directives:
#   -DNETCDF enables netCDF output
#   -Dradoffline and -Dnooverlap (see bugsrad documentation)
#   -DMKL enables MKL solver (PARDISO/GMRES) support
# You will need to `make clean' if you change these
# Use -I<include path> to set a module or header file directory
# Define include directories. 
# Need location of include and *.mod files for the netcdf library

CPPDEFS="-DNETCDF -Dnooverlap -Dradoffline -DMKL"
CPPFLAGS="-I$MKLPATH/../../include -I$NETCDF/include"

# == Static library processing ==
AR=ar
ARFLAGS=cru
RANLIB=ranlib

# == Shared library processing ==
SHARED=$FC
SHAREDFLAGS="-fPIC -shared"

# Location of 'mkmf' utility
mkmf=$dir/mkmf

# gmake command to use and options: '-j 2' enables parallel compilation
gmake="make"
