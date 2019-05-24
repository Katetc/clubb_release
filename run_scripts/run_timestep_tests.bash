#!/bin/bash
#######################################################################
# $Id: run_timestep_tests.bash 4307 2010-01-04 19:50:51Z senkbeil@uwm.edu $
#
# Script to test CLUBB by running all cases at various time step
# lengths.  This script calls:
#
# ./run_standalone_all.bash --timestep_test {time step length}
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
done

cd $restoreDir
