#!/bin/bash
# $Id$
# Usage:
#  Create a new rand_seed.dat 
#  Used by hoc_tuner to randomize initial simplex, called x_array.
#----------------------------------------------------------------------
# Output:
# rand_seed.dat: text file that may be edited by hand.
#----------------------------------------------------------------------
../bin/int2txt /dev/urandom > ../input_misc/tuner/rand_seed.dat
