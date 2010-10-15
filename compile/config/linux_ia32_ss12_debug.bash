# $Id$
# Makefile definitions for Sun Studio's Fortran compiler on GNU/Linux

# Fortran 95 compiler and linker
FC=sunf95
LD=sunf95

# Define path to directories
dir=`pwd` # dir where this script resides
bindir="$dir/../bin"  # dir for Makefile and executable
objdir="$dir/../obj"  # dir for *.o and *.mod files
libdir="$dir/../lib"  # dir for *.a library files
srcdir="$dir/../src"  # dir where the source files reside

# It is sometimes helpful to turn on floating-point trapping for the 
#  standalone program, but this will not work when using the tuner.
# In Sun f95: remove the reference to ftrap, or use -ftrap=common
DEBUG="-C -fns=no -stackvar -xcheck=init_local -ftrap=common -traceback=common"

# == Warnings ==
# This is the preferred warning level when compiling CLUBB with Sun Studio.
#   Level -w4 produces a warning message for each call to an overloaded 
#   operator, resulting in a huge number of warnings.
WARNINGS="-w3 -ansi"

# == Machine specific flags ==
# Note that when linking to sunperf (for LAPACK) you must use -dalign
ARCH="-g -xtarget=native -m64 -dalign -xopenmp=noopt"
#ARCH="-g -m64 -xtarget=native -dalign"

# == NetCDF Location  ==
NETCDF="/usr/local/netcdf-sun64"

# == LAPACK libraries ==
LAPACK="-xlic_lib=sunperf" # Sun performance library
#LAPACK="-L/usr/local/lib -llapack -L/usr/local/atlas/lib -lf77blas -lcblas -latlas"

# == Linking Flags ==
# Use -s to strip (no debugging); 
# -Bstatic; for static linking of libraries
# -xlibmopt; link the optimized version of libm 
LDFLAGS="$ARCH $DEBUG -L$NETCDF/lib -lnetcdf $LAPACK -xlibmopt"

# == Compiler flags ==
# You will need to `make clean' if you change these
FFLAGS="$ARCH $DEBUG"

# Preprocessing Directives:
#   -DNETCDF enables netCDF output
#   -Dradoffline and -Dnooverlap (see bugsrad documentation)
# Define include directories. 
# Need location of include and *.mod files for the netcdf library
CPPDEFS="-DNETCDF -Dnooverlap -Dradoffline"
CPPFLAGS="-M$NETCDF/include"

# == Static library processing ==
AR=ar
ARFLAGS=cru
RANLIB=ranlib

# == Shared library processing ==
SHARED=$FC
SHAREDFLAGS="-G"

# Location of 'mkmf' utility
mkmf=$dir/mkmf

# gmake command to use and options: '-j 2' enables parallel compilation
gmake="make"

