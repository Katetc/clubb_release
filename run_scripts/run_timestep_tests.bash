#!/bin/bash
#######################################################################
# $Id$
#
# Script to test CLUBB by running all cases at various time step
# lengths.  This script calls:
#
# ./run_scm_all.bash --timestep_test {time step length}
#
# multiple times, using a different time step length each time.
#
#######################################################################

# Figure out the directory where the script is located
scriptPath=`dirname $0`

# Store the current directory location so it can be restored
restoreDir=`pwd`

# Change directories to the one the script is located in
cd $scriptPath

TEST_TIMESTEP[0]=300.0   # 5 minute time step.
TEST_TIMESTEP[1]=600.0   # 10 minute time step.
TEST_TIMESTEP[2]=900.0   # 15 minute time step.
TEST_TIMESTEP[3]=1200.0  # 20 minute time step.
TEST_TIMESTEP[4]=1800.0  # 30 minute time step.
TEST_TIMESTEP[5]=2700.0  # 45 minute time step.
TEST_TIMESTEP[6]=3600.0  # 60 minute (one hour) time step.

for (( x=0; x < "${#TEST_TIMESTEP[@]}"; x++ )); do
    echo -e "\nRunning all cases at a(n) "${TEST_TIMESTEP[$x]}" second time step."
   ./run_scm_all.bash --timestep_test ${TEST_TIMESTEP[$x]}
   # Move all output files from a given timestep to their own directory.
   # This code assumes that this script is being run from the run_scripts directory
   #   and that the output directory is empty before this script is run.
   #outputDir="../output/timestep_${TEST_TIMESTEP[$x]}s"
   #mkdir $outputDir
   #outputFiles="../output/*.*"
   #mv $outputFiles "$outputDir"
done

cd $restoreDir
