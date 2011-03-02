#!/bin/bash
###############################################################################
# This script edits the matlab file used to generate the output required
# for the Cloud Feedback cases. The script uses vim editing to switch between
# the different cases.
# Edit input_path to be the location where the desired CLUBB output is located.
# Edit output_path to be the location where the .nc files should be created.
###############################################################################

# Path to the CLUBB output files
input_path="/home/meyernr/ticket_388/clubb_fresh/output/"
# Desired path to place the .nc files
output_path="/home/meyernr/ticket_388/nc_output/"
# Desired path to the verify PDFs
pdf_path="/home/meyernr/ticket_388/verify/"

# List of cases to be converted
CASES=( astex_a209 )

############################################
# Nothing below should need to be modified.
############################################

# Calculate the size of the array for the loop
num_cases=${#CASES[@]}

# Check if the output path needs to be created
if [ -d $output_path ]; then
	# Make sure matlabuser can write to this directory
	chmod 777 $output_path
else
	# Create the directory and change the permissions
	mkdir $output_path
	chmod 777 $output_path
fi
# Check if the pdf path needs to be created
if [ -d $pdf_path ]; then
	# Make sure matlabuser can write to this directory
	chmod 777 $pdf_path
else
	# Create the directory and change the permissions
	mkdir $pdf_path
	chmod 777 $pdf_path
fi

# Loop through all the cases 
for (( i=0;i<num_cases;i++)); do
	# Edit the .m files using the current array value
	vim -E -s astex_a209_output_creator.m <<-EOF
		:%s/curr_case\s*=\s*\'[a-zA-Z0-9_]*\'/curr_case = \'${CASES[${i}]}\'/
		:update
		:quit
	EOF

	vim -E -s astex_a209_plot.m <<-EOF
		:%s/curr_case\s*=\s*\'[a-zA-Z0-9_]*\'/curr_case = \'${CASES[${i}]}\'/
		:update
		:quit
	EOF

	# Create the netcdf files
	echo "astex_a209_output_creator('$input_path', '$output_path')" | sudo -u matlabuser matlab -nodisplay -nodesktop

	# Create the verify pdfs
	echo "astex_a209_plot('$output_path', '$pdf_path')"| sudo -u matlabuser matlab -nodisplay -nodesktop
done

# This will loop through the cases as above and create a single pdf for each case by merging all created pdfs.
# The single pdfs will all be deleted from the directory.
cd $pdf_path
	
for ((i=0;i<num_cases;i++));do
        gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=verify_${CASES[${i}]}.pdf -dBATCH ${CASES[${i}]}_*
        rm -f ./${CASES[${i}]}\_*
done
