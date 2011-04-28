#!/bin/bash

###############################################################################
# compiler_tests.bash 
# This script runs a set of compiler tests similar to the way the nightly tests
# do. This script will run the g95, OracleSolarisStudio, and Intel compilers. Most of 
# this script was taken directly from the nightly tests version, but combined
# into one script.
#
# To execute the compiler tests:
#   ./compiler_tests.bash
###############################################################################

# Figure out the directory where the script is located
scriptPath=`dirname $0`

# Store the current directory location so it can be restored
restoreDir=`pwd`

# Change directories to the one the script is located in
cd $scriptPath

# The location to where the output should be placed
outputFile="./compiler_output"

# The base location of the CLUBB source code
clubbSource="`pwd`/.."

# This function reads all the arguments and sets variables that will be used
# later in the script and also passed to other scripts.
set_args()
{
	# Loop through the list of arguments ($1, $2...). This loop ignores
	# anything not starting with '-'.
	while [ -n "$(echo $1 | grep "-")" ]; do
		case $1 in			  
			# Handles help, and any unknown argument
			-help | -h | -? | * ) echo "usage: compiler_tests.bash"
			                      exit 1;;
		esac
		# Shift moves the parameters up one. Ex: $2 -> $1 and so on.
		# This is so we only have to check $1 on each iteration.
		shift
	done
}

###############################################################################
# Runs a make distclean to clean up.
###############################################################################
clean()
{
	rm $clubbSource/obj/*
	rm $clubbSource/bin/*
}

###############################################################################
# Compiles the source code.
###############################################################################
compile()
{
	case $1 in			  
		"oracle" ) compiler="./config/linux_x86_64_oracle_debug.bash"
		              ;;
		"ifort" ) compiler="./config/linux_x86_64_ifort.bash"
			  ;;
		"g95" ) compiler="./config/linux_x86_64_g95_optimize.bash"
		        ;;
		"gfortran" ) compiler="./config/linux_x86_64_gfortran.bash"
		        ;;
	esac

	# Change to CLUBB's compile directory
	cd $clubbSource/compile
	./compile.bash $compiler > /dev/null 2>> $outputFile
}

set_args $*

# Run the compiler tests
echo -e "Running the compiler tests. Output will be placed in compiler_output."
echo -e "Use 'tail -f compiler_output' to view the progress."

# Compile with OracleSolarisStudio
echo -e "\nOracle Solaris Studio Compiler Warnings/Errors:" > $outputFile
echo "------------------------------------" >> $outputFile
clean
compile oracle

# Compile with Intel
echo -e "\nIntel Fortran Compiler Warnings/Errors:" >> $outputFile
echo "---------------------------------------" >> $outputFile
clean
compile ifort

# Compile with g95
echo -e "\ng95 Compiler Warnings/Errors:" >> $outputFile
echo "-----------------------------" >> $outputFile
clean
compile g95

# Compile with g95
echo -e "\nGNU Fortran Compiler Warnings/Errors:" >> $outputFile
echo "-----------------------------" >> $outputFile
clean
compile gfortran


echo -e "\nDone! View the file 'compiler_output' to see the results."

cd $restoreDir
