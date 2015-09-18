% $Id$
function goodness_of_fit_tests( input_file_sam, num_sam_files, ...
                                input_file_clubb, num_clubb_files )

% Path to necessary MATLAB utility functions.
addpath ( '../matlab_scatter_contour_plots', '-end' )

% Note:  In order to set things up properly for this program, make a
%        directory for the SAM LES 3D output results and place ONLY the
%        _micro.nc files from the SAME run into that directory.  That
%        directory is then called, and the files are passed in as
%        input_file_sam.

% Input Variables:
%
% 1) input_file_sam:  A string that contains the path(s)-and-filename(s)
%                     of the SAM LES 3D NetCDF file(s).  When more than one
%                     SAM LES 3D file is entered, the files need to be
%                     listed in a single string with the files delimited by
%                     a single space.  This is done this way because this
%                     is the way that the bash script passes arrays.  This
%                     string is split up into individual filenames in the
%                     code below.
%
% 2) num_sam_files:  The number of SAM LES 3D NetCDF files found in
%                    input_file_sam.  When run with the bash script
%                    (run_goodness_of_fit_tests.bash), this is
%                    automatically calculated.  Otherwise, this number
%                    needs to be passed into this function.
%
% 3) input_file_clubb:  A string that contains the path(s)-and-filename(s)
%                       of the CLUBB zt NetCDF file(s).  When more than one
%                       CLUBB file is entered, the files need to be listed
%                       in a single string with the files delimited by a
%                       single space.  This is done this way because this
%                       is the way that the bash script passes arrays.
%                       This string is split up into individual filenames
%                       in the code below.
%
% 4) num_clubb_files:  The number of CLUBB zt NetCDF files found in
%                      input_file_clubb.  When run with the bash script
%                      (run_goodness_of_fit_tests.bash), this is
%                      automatically calculated.  Otherwise, this number
%                      needs to be passed into this function.

casename = 'RICO';
%casename = 'RF02';
%casename = 'LBA';

% The output times that are analyzed are based on the SAM LES 3D output
% files.
sam_start_file_idx = 70;
sam_stop_file_idx = 70;

% The output altitudes that are analyzed are based on the CLUBB zt output
% files.
clubb_start_height_idx = 39;
clubb_stop_height_idx = 39;

% Flags to perform the tests on a field.
test_w     = true;
test_rt    = true;
test_thl   = true;
test_chi   = true;
test_eta   = true;
test_rr    = true;
test_Nr    = true;
test_rr_ip = true;
test_Nr_ip = true;
if ( strcmp( casename, 'LBA' ) )
   test_ri    = true;
   test_Ni    = true;
   test_ri_ip = true;
   test_Ni_ip = true;
   test_rs    = true;
   test_Ns    = true;
   test_rs_ip = true;
   test_Ns_ip = true;
   test_rg    = true;
   test_Ng    = true;
   test_rg_ip = true;
   test_Ng_ip = true;
else
   test_ri    = false;
   test_Ni    = false;
   test_ri_ip = false;
   test_Ni_ip = false;
   test_rs    = false;
   test_Ns    = false;
   test_rs_ip = false;
   test_Ns_ip = false;
   test_rg    = false;
   test_Ng    = false;
   test_rg_ip = false;
   test_Ng_ip = false;
end

%==========================================================================

% SAM LES 3D file variable indices
global idx_3D_w
global idx_3D_rt
global idx_3D_thl
global idx_3D_chi
global idx_3D_eta
global idx_3D_rr
global idx_3D_Nr
if ( strcmp( casename, 'LBA' ) )
   global idx_3D_ri
   global idx_3D_Ni
   global idx_3D_rs
   global idx_3D_Ns
   global idx_3D_rg
   global idx_3D_Ng
   global idx_mu_ri_1_n
   global idx_mu_ri_2_n
   global idx_mu_Ni_1_n
   global idx_mu_Ni_2_n
   global idx_mu_rs_1_n
   global idx_mu_rs_2_n
   global idx_mu_Ns_1_n
   global idx_mu_Ns_2_n
   global idx_mu_rg_1_n
   global idx_mu_rg_2_n
   global idx_mu_Ng_1_n
   global idx_mu_Ng_2_n
   global idx_sigma_ri_1_n
   global idx_sigma_ri_2_n
   global idx_sigma_Ni_1_n
   global idx_sigma_Ni_2_n
   global idx_sigma_rs_1_n
   global idx_sigma_rs_2_n
   global idx_sigma_Ns_1_n
   global idx_sigma_Ns_2_n
   global idx_sigma_rg_1_n
   global idx_sigma_rg_2_n
   global idx_sigma_Ng_1_n
   global idx_sigma_Ng_2_n
end

% SAM LES 3D NetCDF filename.
% Filenames (and paths) are found in input_file_sam.
if ( num_sam_files > 1 )
   % There multiple SAM LES 3D files named in input_file_sam.
   filename_sam ...
   = parse_input_file_string( input_file_sam, num_sam_files );
else % num_sam_files = 1
   % There is only one SAM LES 3D file named in input_file_sam.
   filename_sam = input_file_sam;
end % num_sam_files > 1

% CLUBB zt NetCDF filename.
% Filenames (and paths) are found in input_file_clubb.
if ( num_clubb_files > 1 )
   % There multiple CLUBB zt files named in input_file_clubb.
   filename_clubb ...
   = parse_input_file_string( input_file_clubb, num_clubb_files );
else % num_clubb_files = 1
   % There is only one CLUBB zt file named in input_file_clubb.
   filename_clubb = input_file_clubb;
end % num_clubb_files > 1

% Read CLUBB zt NetCDF files, check that they are all set up consistently
% with one another (same number of grid levels, same altitudes of grid
% levels, same number of statistical output timesteps, same statistical
% output times, etc.), and obtain variables.
[ nz_clubb, z_clubb, num_t_clubb, time_clubb, num_var_clubb, ...
  units_corrector_type_clubb, var_clubb ] ...
= CLUBB_read_check_files( filename_clubb, num_clubb_files, casename );

% Use appropriate units (SI units).
for clubb_idx = 1:1:num_clubb_files

   var_clubb_inout = reshape( var_clubb(clubb_idx,:,:,:,:,:), ...
                              num_var_clubb, 1, 1, nz_clubb, num_t_clubb );

   [ var_clubb_inout ] ...
   = unit_corrector( num_var_clubb, var_clubb_inout, ...
                     units_corrector_type_clubb, -1 );

   var_clubb(clubb_idx,:,:,:,:,:) = var_clubb_inout;

end % clubb_idx = 1:1:num_clubb_files

% Check that entries for file (time) indices and height indices are valid.
% The output times that are analyzed are based on the SAM LES 3D output
% files.
sam_start_file_idx = max( sam_start_file_idx, 1 );
sam_stop_file_idx = min( sam_stop_file_idx, num_sam_files );
if ( sam_start_file_idx > sam_stop_file_idx )
   fprintf( [ 'The value of sam_start_file_idx is greater than the', ...
              ' value of sam_stop_file_idx.\n' ] );
   fprintf( 'sam_start_file_idx = %d\n', sam_start_file_idx );
   fprintf( 'sam_stop_file_idx = %d\n', sam_stop_file_idx );
   quit force
end % sam_start_file_idx > sam_stop_file_idx
% The output altitudes that are analyzed are based on the CLUBB zt output
% files.
clubb_start_height_idx = max( clubb_start_height_idx, 2 );
clubb_stop_height_idx = min( clubb_stop_height_idx, nz_clubb );
if ( clubb_start_height_idx > clubb_stop_height_idx )
   fprintf( [ 'The value of clubb_start_height_idx is greater than', ...
              ' the value of clubb_stop_height_idx.\n' ] );
   fprintf( 'clubb_start_height_idx = %d\n', clubb_start_height_idx );
   fprintf( 'clubb_stop_height_idx = %d\n', clubb_stop_height_idx );
   quit force
end % clubb_start_height_idx > clubb_stop_height_idx

% Initialize statistical score variables to -1.  When a score can be
% calculated, the value must be greater than or equal to 0.
% Initial the K-S number for w.
KS_number_w  = -ones( num_clubb_files, ...
                      sam_stop_file_idx-sam_start_file_idx+1, ...
                      clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for w.
CvM_number_w = -ones( num_clubb_files, ...
                      sam_stop_file_idx-sam_start_file_idx+1, ...
                      clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for rt.
KS_number_rt  = -ones( num_clubb_files, ...
                       sam_stop_file_idx-sam_start_file_idx+1, ...
                       clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for rt.
CvM_number_rt = -ones( num_clubb_files, ...
                       sam_stop_file_idx-sam_start_file_idx+1, ...
                       clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for thl.
KS_number_thl  = -ones( num_clubb_files, ...
                        sam_stop_file_idx-sam_start_file_idx+1, ...
                        clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for thl.
CvM_number_thl = -ones( num_clubb_files, ...
                        sam_stop_file_idx-sam_start_file_idx+1, ...
                        clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for chi.
KS_number_chi  = -ones( num_clubb_files, ...
                        sam_stop_file_idx-sam_start_file_idx+1, ...
                        clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for chi.
CvM_number_chi = -ones( num_clubb_files, ...
                        sam_stop_file_idx-sam_start_file_idx+1, ...
                        clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for eta.
KS_number_eta  = -ones( num_clubb_files, ...
                        sam_stop_file_idx-sam_start_file_idx+1, ...
                        clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for eta.
CvM_number_eta = -ones( num_clubb_files, ...
                        sam_stop_file_idx-sam_start_file_idx+1, ...
                        clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for rr.
KS_number_rr  = -ones( num_clubb_files, ...
                       sam_stop_file_idx-sam_start_file_idx+1, ...
                       clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for rr.
CvM_number_rr = -ones( num_clubb_files, ...
                       sam_stop_file_idx-sam_start_file_idx+1, ...
                       clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for Nr.
KS_number_Nr  = -ones( num_clubb_files, ...
                       sam_stop_file_idx-sam_start_file_idx+1, ...
                       clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for Nr.
CvM_number_Nr = -ones( num_clubb_files, ...
                       sam_stop_file_idx-sam_start_file_idx+1, ...
                       clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for rr in-precip.
KS_number_rr_ip  = -ones( num_clubb_files, ...
                          sam_stop_file_idx-sam_start_file_idx+1, ...
                          clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for rr in-precip.
CvM_number_rr_ip = -ones( num_clubb_files, ...
                          sam_stop_file_idx-sam_start_file_idx+1, ...
                          clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for Nr in-precip.
KS_number_Nr_ip  = -ones( num_clubb_files, ...
                          sam_stop_file_idx-sam_start_file_idx+1, ...
                          clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for Nr in-precip.
CvM_number_Nr_ip = -ones( num_clubb_files, ...
                          sam_stop_file_idx-sam_start_file_idx+1, ...
                          clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for ri.
KS_number_ri  = -ones( num_clubb_files, ...
                       sam_stop_file_idx-sam_start_file_idx+1, ...
                       clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for ri.
CvM_number_ri = -ones( num_clubb_files, ...
                       sam_stop_file_idx-sam_start_file_idx+1, ...
                       clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for Ni.
KS_number_Ni  = -ones( num_clubb_files, ...
                       sam_stop_file_idx-sam_start_file_idx+1, ...
                       clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for Ni.
CvM_number_Ni = -ones( num_clubb_files, ...
                       sam_stop_file_idx-sam_start_file_idx+1, ...
                       clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for ri in-precip.
KS_number_ri_ip  = -ones( num_clubb_files, ...
                          sam_stop_file_idx-sam_start_file_idx+1, ...
                          clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for ri in-precip.
CvM_number_ri_ip = -ones( num_clubb_files, ...
                          sam_stop_file_idx-sam_start_file_idx+1, ...
                          clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for Ni in-precip.
KS_number_Ni_ip  = -ones( num_clubb_files, ...
                          sam_stop_file_idx-sam_start_file_idx+1, ...
                          clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for Ni in-precip.
CvM_number_Ni_ip = -ones( num_clubb_files, ...
                          sam_stop_file_idx-sam_start_file_idx+1, ...
                          clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for rs.
KS_number_rs  = -ones( num_clubb_files, ...
                       sam_stop_file_idx-sam_start_file_idx+1, ...
                       clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for rs.
CvM_number_rs = -ones( num_clubb_files, ...
                       sam_stop_file_idx-sam_start_file_idx+1, ...
                       clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for Ns.
KS_number_Ns  = -ones( num_clubb_files, ...
                       sam_stop_file_idx-sam_start_file_idx+1, ...
                       clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for Ns.
CvM_number_Ns = -ones( num_clubb_files, ...
                       sam_stop_file_idx-sam_start_file_idx+1, ...
                       clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for rs in-precip.
KS_number_rs_ip  = -ones( num_clubb_files, ...
                          sam_stop_file_idx-sam_start_file_idx+1, ...
                          clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for rs in-precip.
CvM_number_rs_ip = -ones( num_clubb_files, ...
                          sam_stop_file_idx-sam_start_file_idx+1, ...
                          clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for Ns in-precip.
KS_number_Ns_ip  = -ones( num_clubb_files, ...
                          sam_stop_file_idx-sam_start_file_idx+1, ...
                          clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for Ns in-precip.
CvM_number_Ns_ip = -ones( num_clubb_files, ...
                          sam_stop_file_idx-sam_start_file_idx+1, ...
                          clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for rg.
KS_number_rg  = -ones( num_clubb_files, ...
                       sam_stop_file_idx-sam_start_file_idx+1, ...
                       clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for rg.
CvM_number_rg = -ones( num_clubb_files, ...
                       sam_stop_file_idx-sam_start_file_idx+1, ...
                       clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for Ng.
KS_number_Ng  = -ones( num_clubb_files, ...
                       sam_stop_file_idx-sam_start_file_idx+1, ...
                       clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for Ng.
CvM_number_Ng = -ones( num_clubb_files, ...
                       sam_stop_file_idx-sam_start_file_idx+1, ...
                       clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for rg in-precip.
KS_number_rg_ip  = -ones( num_clubb_files, ...
                          sam_stop_file_idx-sam_start_file_idx+1, ...
                          clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for rg in-precip.
CvM_number_rg_ip = -ones( num_clubb_files, ...
                          sam_stop_file_idx-sam_start_file_idx+1, ...
                          clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the K-S number for Ng in-precip.
KS_number_Ng_ip  = -ones( num_clubb_files, ...
                          sam_stop_file_idx-sam_start_file_idx+1, ...
                          clubb_stop_height_idx-clubb_start_height_idx+1 );
% Initial the C-vM number for Ng in-precip.
CvM_number_Ng_ip = -ones( num_clubb_files, ...
                          sam_stop_file_idx-sam_start_file_idx+1, ...
                          clubb_stop_height_idx-clubb_start_height_idx+1 );

% Loop over all requested SAM LES 3D output files.
% This is the loop over time.
for sam_idx = sam_start_file_idx:1:sam_stop_file_idx

   % Read SAM NetCDF files and obtain variables.
   [ z_sam, time_sam, var_sam, units_corrector_type_sam, ...
     nx_sam, ny_sam, nz_sam, num_t_sam, num_var_sam ] ...
   = read_SAM_3D_file( strtrim( filename_sam(sam_idx,:) ), casename );

   % Use appropriate units (SI units).
   [ var_sam ] ...
   = unit_corrector( num_var_sam, var_sam, units_corrector_type_sam, -1 );

   % Find the time in the CLUBB zt output file that is equal (or closest)
   % to the SAM LES output time.
   clubb_time_idx ...
   = get_clubb_time_index( time_sam, time_clubb, num_t_clubb );

   % Loop over all requested CLUBB zt vertical levels.
   % This is the loop over altitude.
   for clubb_height_idx = clubb_start_height_idx:1:clubb_stop_height_idx

      % Use SAM 3D data from the SAM level that is at the same altitude as
      % the requested CLUBB level (z_clubb(clubb_height_idx)).  If SAM does
      % not have a grid level at that altitude, interpolate the SAM 3D
      % output to that grid level.
      sam_var_lev ...
      = interp_SAM_3D_points( z_clubb, clubb_height_idx, ...
                              z_sam, nx_sam, ny_sam, nz_sam, ...
                              var_sam, num_var_sam );

      if ( strcmp( casename, 'LBA' ) )
         % QRFRAC cuts of at 1.0 x 10^-6 kg/kg.
         for idx = 1:1:nx_sam*ny_sam
            if ( sam_var_lev(idx_3D_rr,idx) < 1.0e-6 )
               sam_var_lev(idx_3D_rr,idx) = 0.0;
               sam_var_lev(idx_3D_Nr,idx) = 0.0;
            end
         end
         % QIFRAC cuts of at 1.0 x 10^-6 kg/kg.
         for idx = 1:1:nx_sam*ny_sam
            if ( sam_var_lev(idx_3D_ri,idx) < 1.0e-6 )
               sam_var_lev(idx_3D_ri,idx) = 0.0;
               sam_var_lev(idx_3D_Ni,idx) = 0.0;
            end
         end
         % QSFRAC cuts of at 1.0 x 10^-6 kg/kg.
         for idx = 1:1:nx_sam*ny_sam
            if ( sam_var_lev(idx_3D_rs,idx) < 1.0e-6 )
               sam_var_lev(idx_3D_rs,idx) = 0.0;
               sam_var_lev(idx_3D_Ns,idx) = 0.0;
            end
         end
         % QGFRAC cuts of at 1.0 x 10^-6 kg/kg.
         for idx = 1:1:nx_sam*ny_sam
            if ( sam_var_lev(idx_3D_rg,idx) < 1.0e-6 )
               sam_var_lev(idx_3D_rg,idx) = 0.0;
               sam_var_lev(idx_3D_Ng,idx) = 0.0;
            end
         end
      end

      % Unpack CLUBB variables (PDF parameters).
      for clubb_idx = 1:1:num_clubb_files

         var_clubb_in = reshape( var_clubb(clubb_idx,:,:,:,:,:), ...
                                 num_var_clubb, 1, 1, nz_clubb, ...
                                 num_t_clubb );

         [ mu_w_1(clubb_idx), mu_w_2(clubb_idx), ...
           mu_rt_1(clubb_idx), mu_rt_2(clubb_idx), ...
           mu_thl_1(clubb_idx), mu_thl_2(clubb_idx), ...
           mu_chi_1(clubb_idx), mu_chi_2(clubb_idx), ...
           mu_eta_1(clubb_idx), mu_eta_2(clubb_idx), ...
           mu_rr_1_n(clubb_idx), mu_rr_2_n(clubb_idx), ...
           mu_Nr_1_n(clubb_idx), mu_Nr_2_n(clubb_idx), ...
           sigma_w_1(clubb_idx), sigma_w_2(clubb_idx), ...
           sigma_rt_1(clubb_idx), sigma_rt_2(clubb_idx), ...
           sigma_thl_1(clubb_idx), sigma_thl_2(clubb_idx), ...
           sigma_chi_1(clubb_idx), sigma_chi_2(clubb_idx), ...
           sigma_eta_1(clubb_idx), sigma_eta_2(clubb_idx), ...
           sigma_rr_1_n(clubb_idx), sigma_rr_2_n(clubb_idx), ...
           sigma_Nr_1_n(clubb_idx), sigma_Nr_2_n(clubb_idx), ...
           mixt_frac(clubb_idx), precip_frac_1(clubb_idx), ...
           precip_frac_2(clubb_idx) ] ...
         = unpack_CLUBB_vars_fit_tests( var_clubb_in, clubb_height_idx, ...
                                        clubb_time_idx );

         if ( strcmp( casename, 'LBA' ) )

            mu_ri_1_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_mu_ri_1_n, ...
                         1, 1, clubb_height_idx, clubb_time_idx );
            mu_ri_2_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_mu_ri_2_n, ...
                         1, 1, clubb_height_idx, clubb_time_idx );
            mu_Ni_1_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_mu_Ni_1_n, ...
                         1, 1, clubb_height_idx, clubb_time_idx );
            mu_Ni_2_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_mu_Ni_2_n, ...
                         1, 1, clubb_height_idx, clubb_time_idx );
            mu_rs_1_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_mu_rs_1_n, ...
                         1, 1, clubb_height_idx, clubb_time_idx );
            mu_rs_2_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_mu_rs_2_n, ...
                         1, 1, clubb_height_idx, clubb_time_idx );
            mu_Ns_1_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_mu_Ns_1_n, ...
                         1, 1, clubb_height_idx, clubb_time_idx );
            mu_Ns_2_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_mu_Ns_2_n, ...
                         1, 1, clubb_height_idx, clubb_time_idx );
            mu_rg_1_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_mu_rg_1_n, ...
                         1, 1, clubb_height_idx, clubb_time_idx );
            mu_rg_2_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_mu_rg_2_n, ...
                         1, 1, clubb_height_idx, clubb_time_idx );
            mu_Ng_1_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_mu_Ng_1_n, ...
                         1, 1, clubb_height_idx, clubb_time_idx );
            mu_Ng_2_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_mu_Ng_2_n, ...
                         1, 1, clubb_height_idx, clubb_time_idx );
            sigma_ri_1_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_sigma_ri_1_n, 1, 1, ...
                         clubb_height_idx, clubb_time_idx );
            sigma_ri_2_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_sigma_ri_2_n, 1, 1, ...
                         clubb_height_idx, clubb_time_idx );
            sigma_Ni_1_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_sigma_Ni_1_n, 1, 1, ...
                         clubb_height_idx, clubb_time_idx );
            sigma_Ni_2_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_sigma_Ni_2_n, 1, 1, ...
                         clubb_height_idx, clubb_time_idx );
            sigma_rs_1_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_sigma_rs_1_n, 1, 1, ...
                         clubb_height_idx, clubb_time_idx );
            sigma_rs_2_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_sigma_rs_2_n, 1, 1, ...
                         clubb_height_idx, clubb_time_idx );
            sigma_Ns_1_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_sigma_Ns_1_n, 1, 1, ...
                         clubb_height_idx, clubb_time_idx );
            sigma_Ns_2_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_sigma_Ns_2_n, 1, 1, ...
                         clubb_height_idx, clubb_time_idx );
            sigma_rg_1_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_sigma_rg_1_n, 1, 1, ...
                         clubb_height_idx, clubb_time_idx );
            sigma_rg_2_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_sigma_rg_2_n, 1, 1, ...
                         clubb_height_idx, clubb_time_idx );
            sigma_Ng_1_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_sigma_Ng_1_n, 1, 1, ...
                         clubb_height_idx, clubb_time_idx );
            sigma_Ng_2_n(clubb_idx) ...
            = var_clubb( clubb_idx, idx_sigma_Ng_2_n, 1, 1, ...
                         clubb_height_idx, clubb_time_idx );

         end
   
      end % clubb_idx = 1:1:num_clubb_files

      % Time and height indices in the storage variables.
      time_idx_store   = sam_idx-sam_start_file_idx+1;
      height_idx_store = clubb_height_idx-clubb_start_height_idx+1;

      % Values of time and height in the storage variables.
      time_store(time_idx_store) = time_sam * 86400.0;
      if ( time_idx_store == 1 )
         height_store(height_idx_store) = z_clubb(clubb_height_idx);
      end

      % Run the goodness-of-fit tests for w.
      if ( test_w )

         % The K-S test for w.
         KS_number_w(:,time_idx_store,height_idx_store) ...
         = KS_test_normal( sam_var_lev(idx_3D_w,:), mu_w_1, mu_w_2, ...
                           sigma_w_1, sigma_w_2, mixt_frac, ...
                           num_clubb_files );

         % The C-vM test for w.
         [ CvM_number_w(:,time_idx_store,height_idx_store) ...
           num_pts_test_w(time_idx_store,height_idx_store) ] ...
         = CvM_test_normal( sam_var_lev(idx_3D_w,:), mu_w_1, mu_w_2, ...
                            sigma_w_1, sigma_w_2, mixt_frac, ...
                            num_clubb_files );

      end % test_w

      % Run the goodness-of-fit tests for rt.
      if ( test_rt )

         % The K-S test for rt.
         KS_number_rt(:,time_idx_store,height_idx_store) ...
         = KS_test_normal( sam_var_lev(idx_3D_rt,:), mu_rt_1, mu_rt_2, ...
                           sigma_rt_1, sigma_rt_2, mixt_frac, ...
                           num_clubb_files );

         % The C-vM test for rt.
         [ CvM_number_rt(:,time_idx_store,height_idx_store) ...
           num_pts_test_rt(time_idx_store,height_idx_store) ] ...
         = CvM_test_normal( sam_var_lev(idx_3D_rt,:), mu_rt_1, mu_rt_2, ...
                            sigma_rt_1, sigma_rt_2, mixt_frac, ...
                            num_clubb_files );

      end % test_rt

      % Run the goodness-of-fit tests for thl.
      if ( test_thl )

         % The K-S test for thl.
         KS_number_thl(:,time_idx_store,height_idx_store) ...
         = KS_test_normal( sam_var_lev(idx_3D_thl,:), mu_thl_1, ...
                           mu_thl_2, sigma_thl_1, sigma_thl_2, ...
                           mixt_frac, num_clubb_files );

         % The C-vM test for thl.
         [ CvM_number_thl(:,time_idx_store,height_idx_store) ...
           num_pts_test_thl(time_idx_store,height_idx_store) ] ...
         = CvM_test_normal( sam_var_lev(idx_3D_thl,:), mu_thl_1, ...
                            mu_thl_2, sigma_thl_1, sigma_thl_2, ...
                            mixt_frac, num_clubb_files );

      end % test_thl

      % Run the goodness-of-fit tests for chi.
      if ( test_chi )

         % The K-S test for chi.
         KS_number_chi(:,time_idx_store,height_idx_store) ...
         = KS_test_normal( sam_var_lev(idx_3D_chi,:), mu_chi_1, ...
                           mu_chi_2, sigma_chi_1, sigma_chi_2, ...
                           mixt_frac, num_clubb_files );

         % The C-vM test for chi.
         [ CvM_number_chi(:,time_idx_store,height_idx_store) ...
           num_pts_test_chi(time_idx_store,height_idx_store) ] ...
         = CvM_test_normal( sam_var_lev(idx_3D_chi,:), mu_chi_1, ...
                            mu_chi_2, sigma_chi_1, sigma_chi_2, ...
                            mixt_frac, num_clubb_files );

      end % test_chi

      % Run the goodness-of-fit tests for eta.
      if ( test_eta )

         % The K-S test for eta.
         KS_number_eta(:,time_idx_store,height_idx_store) ...
         = KS_test_normal( sam_var_lev(idx_3D_eta,:), mu_eta_1, ...
                           mu_eta_2, sigma_eta_1, sigma_eta_2, ...
                           mixt_frac, num_clubb_files );

         % The C-vM test for eta.
         [ CvM_number_eta(:,time_idx_store,height_idx_store) ...
           num_pts_test_eta(time_idx_store,height_idx_store) ] ...
         = CvM_test_normal( sam_var_lev(idx_3D_eta,:), mu_eta_1, ...
                            mu_eta_2, sigma_eta_1, sigma_eta_2, ...
                            mixt_frac, num_clubb_files );

      end % test_eta

      % Run the goodness-of-fit tests for rr.
      if ( test_rr )

         flag_ip_only = false;

         % The K-S test for rr.
         KS_number_rr(:,time_idx_store,height_idx_store) ...
         = KS_test_lognormal( sam_var_lev(idx_3D_rr,:), mu_rr_1_n, ...
                              mu_rr_2_n, sigma_rr_1_n, sigma_rr_2_n, ...
                              mixt_frac, precip_frac_1, precip_frac_2, ...
                              flag_ip_only, num_clubb_files );

         % The C-vM test for rr.
         [ CvM_number_rr(:,time_idx_store,height_idx_store) ...
           num_pts_test_rr(time_idx_store,height_idx_store) ] ...
         = CvM_test_lognormal( sam_var_lev(idx_3D_rr,:), mu_rr_1_n, ...
                               mu_rr_2_n, sigma_rr_1_n, sigma_rr_2_n, ...
                               mixt_frac, precip_frac_1, precip_frac_2, ...
                               flag_ip_only, num_clubb_files );

      end % test_rr

      % Run the goodness-of-fit tests for Nr.
      if ( test_Nr )

         flag_ip_only = false;

         % The K-S test for Nr.
         KS_number_Nr(:,time_idx_store,height_idx_store) ...
         = KS_test_lognormal( sam_var_lev(idx_3D_Nr,:), mu_Nr_1_n, ...
                              mu_Nr_2_n, sigma_Nr_1_n, sigma_Nr_2_n, ...
                              mixt_frac, precip_frac_1, precip_frac_2, ...
                              flag_ip_only, num_clubb_files );

         % The C-vM test for Nr.
         [ CvM_number_Nr(:,time_idx_store,height_idx_store) ...
           num_pts_test_Nr(time_idx_store,height_idx_store) ] ...
         = CvM_test_lognormal( sam_var_lev(idx_3D_Nr,:), mu_Nr_1_n, ...
                               mu_Nr_2_n, sigma_Nr_1_n, sigma_Nr_2_n, ...
                               mixt_frac, precip_frac_1, precip_frac_2, ...
                               flag_ip_only, num_clubb_files );

      end % test_Nr

      % Run the goodness-of-fit tests for rr in-precip.
      if ( test_rr_ip )

         flag_ip_only = true;

         % The K-S test for rr in-precip.
         KS_number_rr_ip(:,time_idx_store,height_idx_store) ...
         = KS_test_lognormal( sam_var_lev(idx_3D_rr,:), mu_rr_1_n, ...
                              mu_rr_2_n, sigma_rr_1_n, sigma_rr_2_n, ...
                              mixt_frac, precip_frac_1, precip_frac_2, ...
                              flag_ip_only, num_clubb_files );

         % The C-vM test for rr in-precip.
         [ CvM_number_rr_ip(:,time_idx_store,height_idx_store) ...
           num_pts_test_rr_ip(time_idx_store,height_idx_store) ] ...
         = CvM_test_lognormal( sam_var_lev(idx_3D_rr,:), mu_rr_1_n, ...
                               mu_rr_2_n, sigma_rr_1_n, sigma_rr_2_n, ...
                               mixt_frac, precip_frac_1, precip_frac_2, ...
                               flag_ip_only, num_clubb_files );

      end % test_rr_ip

      % Run the goodness-of-fit tests for Nr in-precip.
      if ( test_Nr_ip )

         flag_ip_only = true;

         % The K-S test for Nr in-precip.
         KS_number_Nr_ip(:,time_idx_store,height_idx_store) ...
         = KS_test_lognormal( sam_var_lev(idx_3D_Nr,:), mu_Nr_1_n, ...
                              mu_Nr_2_n, sigma_Nr_1_n, sigma_Nr_2_n, ...
                              mixt_frac, precip_frac_1, precip_frac_2, ...
                              flag_ip_only, num_clubb_files );

         % The C-vM test for Nr in-precip.
         [ CvM_number_Nr_ip(:,time_idx_store,height_idx_store) ...
           num_pts_test_Nr_ip(time_idx_store,height_idx_store) ] ...
         = CvM_test_lognormal( sam_var_lev(idx_3D_Nr,:), mu_Nr_1_n, ...
                               mu_Nr_2_n, sigma_Nr_1_n, sigma_Nr_2_n, ...
                               mixt_frac, precip_frac_1, precip_frac_2, ...
                               flag_ip_only, num_clubb_files );

      end % test_Nr_ip

      % Run the goodness-of-fit tests for ri.
      if ( test_ri )

         flag_ip_only = false;

         % The K-S test for ri.
         KS_number_ri(:,time_idx_store,height_idx_store) ...
         = KS_test_lognormal( sam_var_lev(idx_3D_ri,:), mu_ri_1_n, ...
                              mu_ri_2_n, sigma_ri_1_n, sigma_ri_2_n, ...
                              mixt_frac, precip_frac_1, precip_frac_2, ...
                              flag_ip_only, num_clubb_files );

         % The C-vM test for ri.
         [ CvM_number_ri(:,time_idx_store,height_idx_store) ...
           num_pts_test_ri(time_idx_store,height_idx_store) ] ...
         = CvM_test_lognormal( sam_var_lev(idx_3D_ri,:), mu_ri_1_n, ...
                               mu_ri_2_n, sigma_ri_1_n, sigma_ri_2_n, ...
                               mixt_frac, precip_frac_1, precip_frac_2, ...
                               flag_ip_only, num_clubb_files );

      end % test_ri

      % Run the goodness-of-fit tests for Ni.
      if ( test_Ni )

         flag_ip_only = false;

         % The K-S test for Ni.
         KS_number_Ni(:,time_idx_store,height_idx_store) ...
         = KS_test_lognormal( sam_var_lev(idx_3D_Ni,:), mu_Ni_1_n, ...
                              mu_Ni_2_n, sigma_Ni_1_n, sigma_Ni_2_n, ...
                              mixt_frac, precip_frac_1, precip_frac_2, ...
                              flag_ip_only, num_clubb_files );

         % The C-vM test for Ni.
         [ CvM_number_Ni(:,time_idx_store,height_idx_store) ...
           num_pts_test_Ni(time_idx_store,height_idx_store) ] ...
         = CvM_test_lognormal( sam_var_lev(idx_3D_Ni,:), mu_Ni_1_n, ...
                               mu_Ni_2_n, sigma_Ni_1_n, sigma_Ni_2_n, ...
                               mixt_frac, precip_frac_1, precip_frac_2, ...
                               flag_ip_only, num_clubb_files );

      end % test_Ni

      % Run the goodness-of-fit tests for ri in-precip.
      if ( test_ri_ip )

         flag_ip_only = true;

         % The K-S test for ri in-precip.
         KS_number_ri_ip(:,time_idx_store,height_idx_store) ...
         = KS_test_lognormal( sam_var_lev(idx_3D_ri,:), mu_ri_1_n, ...
                              mu_ri_2_n, sigma_ri_1_n, sigma_ri_2_n, ...
                              mixt_frac, precip_frac_1, precip_frac_2, ...
                              flag_ip_only, num_clubb_files );

         % The C-vM test for ri in-precip.
         [ CvM_number_ri_ip(:,time_idx_store,height_idx_store) ...
           num_pts_test_ri_ip(time_idx_store,height_idx_store) ] ...
         = CvM_test_lognormal( sam_var_lev(idx_3D_ri,:), mu_ri_1_n, ...
                               mu_ri_2_n, sigma_ri_1_n, sigma_ri_2_n, ...
                               mixt_frac, precip_frac_1, precip_frac_2, ...
                               flag_ip_only, num_clubb_files );

      end % test_ri_ip

      % Run the goodness-of-fit tests for Ni in-precip.
      if ( test_Ni_ip )

         flag_ip_only = true;

         % The K-S test for Ni in-precip.
         KS_number_Ni_ip(:,time_idx_store,height_idx_store) ...
         = KS_test_lognormal( sam_var_lev(idx_3D_Ni,:), mu_Ni_1_n, ...
                              mu_Ni_2_n, sigma_Ni_1_n, sigma_Ni_2_n, ...
                              mixt_frac, precip_frac_1, precip_frac_2, ...
                              flag_ip_only, num_clubb_files );

         % The C-vM test for Ni in-precip.
         [ CvM_number_Ni_ip(:,time_idx_store,height_idx_store) ...
           num_pts_test_Ni_ip(time_idx_store,height_idx_store) ] ...
         = CvM_test_lognormal( sam_var_lev(idx_3D_Ni,:), mu_Ni_1_n, ...
                               mu_Ni_2_n, sigma_Ni_1_n, sigma_Ni_2_n, ...
                               mixt_frac, precip_frac_1, precip_frac_2, ...
                               flag_ip_only, num_clubb_files );

      end % test_Ni_ip

      % Run the goodness-of-fit tests for rs.
      if ( test_rs )

         flag_ip_only = false;

         % The K-S test for rs.
         KS_number_rs(:,time_idx_store,height_idx_store) ...
         = KS_test_lognormal( sam_var_lev(idx_3D_rs,:), mu_rs_1_n, ...
                              mu_rs_2_n, sigma_rs_1_n, sigma_rs_2_n, ...
                              mixt_frac, precip_frac_1, precip_frac_2, ...
                              flag_ip_only, num_clubb_files );

         % The C-vM test for rs.
         [ CvM_number_rs(:,time_idx_store,height_idx_store) ...
           num_pts_test_rs(time_idx_store,height_idx_store) ] ...
         = CvM_test_lognormal( sam_var_lev(idx_3D_rs,:), mu_rs_1_n, ...
                               mu_rs_2_n, sigma_rs_1_n, sigma_rs_2_n, ...
                               mixt_frac, precip_frac_1, precip_frac_2, ...
                               flag_ip_only, num_clubb_files );

      end % test_rs

      % Run the goodness-of-fit tests for Ns.
      if ( test_Ns )

         flag_ip_only = false;

         % The K-S test for Ns.
         KS_number_Ns(:,time_idx_store,height_idx_store) ...
         = KS_test_lognormal( sam_var_lev(idx_3D_Ns,:), mu_Ns_1_n, ...
                              mu_Ns_2_n, sigma_Ns_1_n, sigma_Ns_2_n, ...
                              mixt_frac, precip_frac_1, precip_frac_2, ...
                              flag_ip_only, num_clubb_files );

         % The C-vM test for Ns.
         [ CvM_number_Ns(:,time_idx_store,height_idx_store) ...
           num_pts_test_Ns(time_idx_store,height_idx_store) ] ...
         = CvM_test_lognormal( sam_var_lev(idx_3D_Ns,:), mu_Ns_1_n, ...
                               mu_Ns_2_n, sigma_Ns_1_n, sigma_Ns_2_n, ...
                               mixt_frac, precip_frac_1, precip_frac_2, ...
                               flag_ip_only, num_clubb_files );

      end % test_Ns

      % Run the goodness-of-fit tests for rs in-precip.
      if ( test_rs_ip )

         flag_ip_only = true;

         % The K-S test for rs in-precip.
         KS_number_rs_ip(:,time_idx_store,height_idx_store) ...
         = KS_test_lognormal( sam_var_lev(idx_3D_rs,:), mu_rs_1_n, ...
                              mu_rs_2_n, sigma_rs_1_n, sigma_rs_2_n, ...
                              mixt_frac, precip_frac_1, precip_frac_2, ...
                              flag_ip_only, num_clubb_files );

         % The C-vM test for rs in-precip.
         [ CvM_number_rs_ip(:,time_idx_store,height_idx_store) ...
           num_pts_test_rs_ip(time_idx_store,height_idx_store) ] ...
         = CvM_test_lognormal( sam_var_lev(idx_3D_rs,:), mu_rs_1_n, ...
                               mu_rs_2_n, sigma_rs_1_n, sigma_rs_2_n, ...
                               mixt_frac, precip_frac_1, precip_frac_2, ...
                               flag_ip_only, num_clubb_files );

      end % test_rs_ip

      % Run the goodness-of-fit tests for Ns in-precip.
      if ( test_Ns_ip )

         flag_ip_only = true;

         % The K-S test for Ns in-precip.
         KS_number_Ns_ip(:,time_idx_store,height_idx_store) ...
         = KS_test_lognormal( sam_var_lev(idx_3D_Ns,:), mu_Ns_1_n, ...
                              mu_Ns_2_n, sigma_Ns_1_n, sigma_Ns_2_n, ...
                              mixt_frac, precip_frac_1, precip_frac_2, ...
                              flag_ip_only, num_clubb_files );

         % The C-vM test for Ns in-precip.
         [ CvM_number_Ns_ip(:,time_idx_store,height_idx_store) ...
           num_pts_test_Ns_ip(time_idx_store,height_idx_store) ] ...
         = CvM_test_lognormal( sam_var_lev(idx_3D_Ns,:), mu_Ns_1_n, ...
                               mu_Ns_2_n, sigma_Ns_1_n, sigma_Ns_2_n, ...
                               mixt_frac, precip_frac_1, precip_frac_2, ...
                               flag_ip_only, num_clubb_files );

      end % test_Ns_ip

      % Run the goodness-of-fit tests for rg.
      if ( test_rg )

         flag_ip_only = false;

         % The K-S test for rg.
         KS_number_rg(:,time_idx_store,height_idx_store) ...
         = KS_test_lognormal( sam_var_lev(idx_3D_rg,:), mu_rg_1_n, ...
                              mu_rg_2_n, sigma_rg_1_n, sigma_rg_2_n, ...
                              mixt_frac, precip_frac_1, precip_frac_2, ...
                              flag_ip_only, num_clubb_files );

         % The C-vM test for rg.
         [ CvM_number_rg(:,time_idx_store,height_idx_store) ...
           num_pts_test_rg(time_idx_store,height_idx_store) ] ...
         = CvM_test_lognormal( sam_var_lev(idx_3D_rg,:), mu_rg_1_n, ...
                               mu_rg_2_n, sigma_rg_1_n, sigma_rg_2_n, ...
                               mixt_frac, precip_frac_1, precip_frac_2, ...
                               flag_ip_only, num_clubb_files );

      end % test_rg

      % Run the goodness-of-fit tests for Ng.
      if ( test_Ng )

         flag_ip_only = false;

         % The K-S test for Ng.
         KS_number_Ng(:,time_idx_store,height_idx_store) ...
         = KS_test_lognormal( sam_var_lev(idx_3D_Ng,:), mu_Ng_1_n, ...
                              mu_Ng_2_n, sigma_Ng_1_n, sigma_Ng_2_n, ...
                              mixt_frac, precip_frac_1, precip_frac_2, ...
                              flag_ip_only, num_clubb_files );

         % The C-vM test for Ng.
         [ CvM_number_Ng(:,time_idx_store,height_idx_store) ...
           num_pts_test_Ng(time_idx_store,height_idx_store) ] ...
         = CvM_test_lognormal( sam_var_lev(idx_3D_Ng,:), mu_Ng_1_n, ...
                               mu_Ng_2_n, sigma_Ng_1_n, sigma_Ng_2_n, ...
                               mixt_frac, precip_frac_1, precip_frac_2, ...
                               flag_ip_only, num_clubb_files );

      end % test_Ng

      % Run the goodness-of-fit tests for rg in-precip.
      if ( test_rg_ip )

         flag_ip_only = true;

         % The K-S test for rg in-precip.
         KS_number_rg_ip(:,time_idx_store,height_idx_store) ...
         = KS_test_lognormal( sam_var_lev(idx_3D_rg,:), mu_rg_1_n, ...
                              mu_rg_2_n, sigma_rg_1_n, sigma_rg_2_n, ...
                              mixt_frac, precip_frac_1, precip_frac_2, ...
                              flag_ip_only, num_clubb_files );

         % The C-vM test for rg in-precip.
         [ CvM_number_rg_ip(:,time_idx_store,height_idx_store) ...
           num_pts_test_rg_ip(time_idx_store,height_idx_store) ] ...
         = CvM_test_lognormal( sam_var_lev(idx_3D_rg,:), mu_rg_1_n, ...
                               mu_rg_2_n, sigma_rg_1_n, sigma_rg_2_n, ...
                               mixt_frac, precip_frac_1, precip_frac_2, ...
                               flag_ip_only, num_clubb_files );

      end % test_rg_ip

      % Run the goodness-of-fit tests for Ng in-precip.
      if ( test_Ng_ip )

         flag_ip_only = true;

         % The K-S test for Ng in-precip.
         KS_number_Ng_ip(:,time_idx_store,height_idx_store) ...
         = KS_test_lognormal( sam_var_lev(idx_3D_Ng,:), mu_Ng_1_n, ...
                              mu_Ng_2_n, sigma_Ng_1_n, sigma_Ng_2_n, ...
                              mixt_frac, precip_frac_1, precip_frac_2, ...
                              flag_ip_only, num_clubb_files );

         % The C-vM test for Ng in-precip.
         [ CvM_number_Ng_ip(:,time_idx_store,height_idx_store) ...
           num_pts_test_Ng_ip(time_idx_store,height_idx_store) ] ...
         = CvM_test_lognormal( sam_var_lev(idx_3D_Ng,:), mu_Ng_1_n, ...
                               mu_Ng_2_n, sigma_Ng_1_n, sigma_Ng_2_n, ...
                               mixt_frac, precip_frac_1, precip_frac_2, ...
                               flag_ip_only, num_clubb_files );

      end % test_Ng_ip

   end % clubb_height_idx = clubb_start_height_idx:1:clubb_stop_height_idx

end % sam_idx = sam_start_file_idx:1:sam_stop_file_idx

% Print the names of the CLUBB files.
fprintf( '\n' );
fprintf( 'CLUBB filenames\n' );
for clubb_idx = 1:1:num_clubb_files
   fprintf( 'CLUBB file %d:  %s\n', ...
            clubb_idx, strtrim( filename_clubb(clubb_idx,:) ) );
end % clubb_idx = 1:1:num_clubb_files

% Print the range of times in the averaging period.
fprintf( '\n' )
fprintf( [ 'The averaging includes all SAM LES 3D statistical output' ...
           ' times from %d seconds to %d seconds, inclusive.\n' ], ...
           time_store(1), ...
           time_store(sam_stop_file_idx-sam_start_file_idx+1) );

% Print the range of altitudes in the averaging period.
fprintf( '\n' )
fprintf( [ 'The averaging includes all CLUBB altitudes from %d meters' ...
           ' to %d meters, inclusive.\n' ], ...
           height_store(1), ...
           height_store(clubb_stop_height_idx-clubb_start_height_idx+1) );

% Print a message about how the value of a test is -1 when no results are
% found (this is due to missing or insufficient data).
fprintf( '\n' )
fprintf( 'Note about K-S and C-vM test scores:\n' );
fprintf( [ 'A value of -1 denotes a missing field, usually because' ...
           ' there is insufficient data (e.g. too few sample points)' ...
           ' for the test.  Levels like this are excluded from any' ...
           ' average.\n' ] );
fprintf( '\n' )
fprintf( 'Note about average ranks and winning fractions:\n' );
fprintf( [ 'A value of -1 denotes that all CLUBB files had the same' ...
           ' score, so they could not be ranked.\n' ] );

% Calculate and output the average value of the statistics.
if ( test_w )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for w.
   avg_KS_number_w = average_KS_stat( KS_number_w, num_clubb_files );

   % Print the average value of the K-S statistic for w.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for w\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_w(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for w.
   [ avg_rank_KS_w win_frac_KS_w ] ...
   = avg_rank_and_win_frac( KS_number_w, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for w\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_w(clubb_idx), ...
               win_frac_KS_w(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic for w.
   % The normalized C-vM number is CvM_number_w / num_pts_test_w.
   avg_nrmlzed_CvM_number_w ...
   = average_normalized_CvM_stat( CvM_number_w, num_pts_test_w, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic for w.
   fprintf( '\n' );
   fprintf( 'Average of normalized C-vM test results for w\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_w(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for w.
   [ avg_rank_CvM_w win_frac_CvM_w ] ...
   = avg_rank_and_win_frac( CvM_number_w, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for w\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_w(clubb_idx), ...
               win_frac_CvM_w(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_w

if ( test_rt )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for rt.
   avg_KS_number_rt = average_KS_stat( KS_number_rt, num_clubb_files );

   % Print the average value of the K-S statistic for rt.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for rt\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_rt(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for rt.
   [ avg_rank_KS_rt win_frac_KS_rt ] ...
   = avg_rank_and_win_frac( KS_number_rt, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for rt\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_rt(clubb_idx), ...
               win_frac_KS_rt(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic for rt.
   % The normalized C-vM number is CvM_number_rt / num_pts_test_rt.
   avg_nrmlzed_CvM_number_rt ...
   = average_normalized_CvM_stat( CvM_number_rt, num_pts_test_rt, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic for rt.
   fprintf( '\n' );
   fprintf( 'Average of normalized C-vM test results for rt\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_rt(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for rt.
   [ avg_rank_CvM_rt win_frac_CvM_rt ] ...
   = avg_rank_and_win_frac( CvM_number_rt, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for rt\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_rt(clubb_idx), ...
               win_frac_CvM_rt(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_rt

if ( test_thl )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for thl.
   avg_KS_number_thl = average_KS_stat( KS_number_thl, num_clubb_files );

   % Print the average value of the K-S statistic for thl.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for thl\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_thl(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for thl.
   [ avg_rank_KS_thl win_frac_KS_thl ] ...
   = avg_rank_and_win_frac( KS_number_thl, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for thl\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_thl(clubb_idx), ...
               win_frac_KS_thl(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic for thl.
   % The normalized C-vM number is CvM_number_thl / num_pts_test_thl.
   avg_nrmlzed_CvM_number_thl ...
   = average_normalized_CvM_stat( CvM_number_thl, num_pts_test_thl, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic for thl.
   fprintf( '\n' );
   fprintf( 'Average of normalized C-vM test results for thl\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_thl(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for thl.
   [ avg_rank_CvM_thl win_frac_CvM_thl ] ...
   = avg_rank_and_win_frac( CvM_number_thl, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for thl\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_thl(clubb_idx), ...
               win_frac_CvM_thl(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_thl

if ( test_chi )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for chi.
   avg_KS_number_chi = average_KS_stat( KS_number_chi, num_clubb_files );

   % Print the average value of the K-S statistic for chi.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for chi\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_chi(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for chi.
   [ avg_rank_KS_chi win_frac_KS_chi ] ...
   = avg_rank_and_win_frac( KS_number_chi, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for chi\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_chi(clubb_idx), ...
               win_frac_KS_chi(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic for chi.
   % The normalized C-vM number is CvM_number_chi / num_pts_test_chi.
   avg_nrmlzed_CvM_number_chi ...
   = average_normalized_CvM_stat( CvM_number_chi, num_pts_test_chi, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic for chi.
   fprintf( '\n' );
   fprintf( 'Average of normalized C-vM test results for chi\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_chi(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for chi.
   [ avg_rank_CvM_chi win_frac_CvM_chi ] ...
   = avg_rank_and_win_frac( CvM_number_chi, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for chi\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_chi(clubb_idx), ...
               win_frac_CvM_chi(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_chi

if ( test_eta )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for eta.
   avg_KS_number_eta = average_KS_stat( KS_number_eta, num_clubb_files );

   % Print the average value of the K-S statistic for eta.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for eta\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_eta(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for eta.
   [ avg_rank_KS_eta win_frac_KS_eta ] ...
   = avg_rank_and_win_frac( KS_number_eta, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for eta\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_eta(clubb_idx), ...
               win_frac_KS_eta(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic for eta.
   % The normalized C-vM number is CvM_number_eta / num_pts_test_eta.
   avg_nrmlzed_CvM_number_eta ...
   = average_normalized_CvM_stat( CvM_number_eta, num_pts_test_eta, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic for eta.
   fprintf( '\n' );
   fprintf( 'Average of normalized C-vM test results for eta\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_eta(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for eta.
   [ avg_rank_CvM_eta win_frac_CvM_eta ] ...
   = avg_rank_and_win_frac( CvM_number_eta, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for eta\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_eta(clubb_idx), ...
               win_frac_CvM_eta(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_eta

if ( test_rr )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for rr.
   avg_KS_number_rr = average_KS_stat( KS_number_rr, num_clubb_files );

   % Print the average value of the K-S statistic for rr.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for rr\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_rr(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for rr.
   [ avg_rank_KS_rr win_frac_KS_rr ] ...
   = avg_rank_and_win_frac( KS_number_rr, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for rr\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_rr(clubb_idx), ...
               win_frac_KS_rr(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic for rr.
   % The normalized C-vM number is CvM_number_rr / num_pts_test_rr.
   avg_nrmlzed_CvM_number_rr ...
   = average_normalized_CvM_stat( CvM_number_rr, num_pts_test_rr, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic for rr.
   fprintf( '\n' );
   fprintf( 'Average of normalized C-vM test results for rr\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_rr(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for rr.
   [ avg_rank_CvM_rr win_frac_CvM_rr ] ...
   = avg_rank_and_win_frac( CvM_number_rr, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for rr\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_rr(clubb_idx), ...
               win_frac_CvM_rr(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_rr

if ( test_Nr )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for Nr.
   avg_KS_number_Nr = average_KS_stat( KS_number_Nr, num_clubb_files );

   % Print the average value of the K-S statistic for Nr.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for Nr\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_Nr(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for Nr.
   [ avg_rank_KS_Nr win_frac_KS_Nr ] ...
   = avg_rank_and_win_frac( KS_number_Nr, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for Nr\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_Nr(clubb_idx), ...
               win_frac_KS_Nr(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic for Nr.
   % The normalized C-vM number is CvM_number_Nr / num_pts_test_Nr.
   avg_nrmlzed_CvM_number_Nr ...
   = average_normalized_CvM_stat( CvM_number_Nr, num_pts_test_Nr, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic for Nr.
   fprintf( '\n' );
   fprintf( 'Average of normalized C-vM test results for Nr\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_Nr(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for Nr.
   [ avg_rank_CvM_Nr win_frac_CvM_Nr ] ...
   = avg_rank_and_win_frac( CvM_number_Nr, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for Nr\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_Nr(clubb_idx), ...
               win_frac_CvM_Nr(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_Nr

if ( test_rr_ip )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for rr in-precip.
   avg_KS_number_rr_ip ...
   = average_KS_stat( KS_number_rr_ip, num_clubb_files );

   % Print the average value of the K-S statistic for rr in-precip.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for rr in-precip.\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_rr_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for rr in-precip.
   [ avg_rank_KS_rr_ip win_frac_KS_rr_ip ] ...
   = avg_rank_and_win_frac( KS_number_rr_ip, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for rr in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_rr_ip(clubb_idx), ...
               win_frac_KS_rr_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic
   % for rr in-precip.
   % The normalized C-vM number is CvM_number_rr_ip / num_pts_test_rr_ip.
   avg_nrmlzed_CvM_number_rr_ip ...
   = average_normalized_CvM_stat( CvM_number_rr_ip, num_pts_test_rr_ip, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic
   % for rr in-precip.
   fprintf( '\n' );
   fprintf( [ 'Average of normalized C-vM test results for' ...
              ' rr in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_rr_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for rr in-precip.
   [ avg_rank_CvM_rr_ip win_frac_CvM_rr_ip ] ...
   = avg_rank_and_win_frac( CvM_number_rr_ip, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for rr in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_rr_ip(clubb_idx), ...
               win_frac_CvM_rr_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_rr_ip

if ( test_Nr_ip )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for Nr in-precip.
   avg_KS_number_Nr_ip ...
   = average_KS_stat( KS_number_Nr_ip, num_clubb_files );

   % Print the average value of the K-S statistic for Nr in-precip.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for Nr in-precip.\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_Nr_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for Nr in-precip.
   [ avg_rank_KS_Nr_ip win_frac_KS_Nr_ip ] ...
   = avg_rank_and_win_frac( KS_number_Nr_ip, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for Nr in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_Nr_ip(clubb_idx), ...
               win_frac_KS_Nr_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic
   % for Nr in-precip.
   % The normalized C-vM number is CvM_number_Nr_ip / num_pts_test_Nr_ip.
   avg_nrmlzed_CvM_number_Nr_ip ...
   = average_normalized_CvM_stat( CvM_number_Nr_ip, num_pts_test_Nr_ip, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic
   % for Nr in-precip.
   fprintf( '\n' );
   fprintf( [ 'Average of normalized C-vM test results for' ...
              ' Nr in-precip\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_Nr_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for Nr in-precip.
   [ avg_rank_CvM_Nr_ip win_frac_CvM_Nr_ip ] ...
   = avg_rank_and_win_frac( CvM_number_Nr_ip, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for Nr in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_Nr_ip(clubb_idx), ...
               win_frac_CvM_Nr_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_Nr_ip

if ( test_ri )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for ri.
   avg_KS_number_ri = average_KS_stat( KS_number_ri, num_clubb_files );

   % Print the average value of the K-S statistic for ri.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for ri\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_ri(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for ri.
   [ avg_rank_KS_ri win_frac_KS_ri ] ...
   = avg_rank_and_win_frac( KS_number_ri, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for ri\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_ri(clubb_idx), ...
               win_frac_KS_ri(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic for ri.
   % The normalized C-vM number is CvM_number_ri / num_pts_test_ri.
   avg_nrmlzed_CvM_number_ri ...
   = average_normalized_CvM_stat( CvM_number_ri, num_pts_test_ri, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic for ri.
   fprintf( '\n' );
   fprintf( 'Average of normalized C-vM test results for ri\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_ri(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for ri.
   [ avg_rank_CvM_ri win_frac_CvM_ri ] ...
   = avg_rank_and_win_frac( CvM_number_ri, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for ri\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_ri(clubb_idx), ...
               win_frac_CvM_ri(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_ri

if ( test_Ni )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for Ni.
   avg_KS_number_Ni = average_KS_stat( KS_number_Ni, num_clubb_files );

   % Print the average value of the K-S statistic for Ni.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for Ni\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_Ni(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for Ni.
   [ avg_rank_KS_Ni win_frac_KS_Ni ] ...
   = avg_rank_and_win_frac( KS_number_Ni, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for Ni\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_Ni(clubb_idx), ...
               win_frac_KS_Ni(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic for Ni.
   % The normalized C-vM number is CvM_number_Ni / num_pts_test_Ni.
   avg_nrmlzed_CvM_number_Ni ...
   = average_normalized_CvM_stat( CvM_number_Ni, num_pts_test_Ni, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic for Ni.
   fprintf( '\n' );
   fprintf( 'Average of normalized C-vM test results for Ni\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_Ni(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for Ni.
   [ avg_rank_CvM_Ni win_frac_CvM_Ni ] ...
   = avg_rank_and_win_frac( CvM_number_Ni, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for Ni\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_Ni(clubb_idx), ...
               win_frac_CvM_Ni(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_Ni

if ( test_ri_ip )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for ri in-precip.
   avg_KS_number_ri_ip ...
   = average_KS_stat( KS_number_ri_ip, num_clubb_files );

   % Print the average value of the K-S statistic for ri in-precip.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for ri in-precip.\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_ri_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for ri in-precip.
   [ avg_rank_KS_ri_ip win_frac_KS_ri_ip ] ...
   = avg_rank_and_win_frac( KS_number_ri_ip, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for ri in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_ri_ip(clubb_idx), ...
               win_frac_KS_ri_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic
   % for ri in-precip.
   % The normalized C-vM number is CvM_number_ri_ip / num_pts_test_ri_ip.
   avg_nrmlzed_CvM_number_ri_ip ...
   = average_normalized_CvM_stat( CvM_number_ri_ip, num_pts_test_ri_ip, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic
   % for ri in-precip.
   fprintf( '\n' );
   fprintf( [ 'Average of normalized C-vM test results for' ...
              ' ri in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_ri_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for ri in-precip.
   [ avg_rank_CvM_ri_ip win_frac_CvM_ri_ip ] ...
   = avg_rank_and_win_frac( CvM_number_ri_ip, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for ri in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_ri_ip(clubb_idx), ...
               win_frac_CvM_ri_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_ri_ip

if ( test_Ni_ip )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for Ni in-precip.
   avg_KS_number_Ni_ip ...
   = average_KS_stat( KS_number_Ni_ip, num_clubb_files );

   % Print the average value of the K-S statistic for Ni in-precip.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for Ni in-precip.\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_Ni_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for Ni in-precip.
   [ avg_rank_KS_Ni_ip win_frac_KS_Ni_ip ] ...
   = avg_rank_and_win_frac( KS_number_Ni_ip, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for Ni in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_Ni_ip(clubb_idx), ...
               win_frac_KS_Ni_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic
   % for Ni in-precip.
   % The normalized C-vM number is CvM_number_Ni_ip / num_pts_test_Ni_ip.
   avg_nrmlzed_CvM_number_Ni_ip ...
   = average_normalized_CvM_stat( CvM_number_Ni_ip, num_pts_test_Ni_ip, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic
   % for Ni in-precip.
   fprintf( '\n' );
   fprintf( [ 'Average of normalized C-vM test results for' ...
              ' Ni in-precip\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_Ni_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for Ni in-precip.
   [ avg_rank_CvM_Ni_ip win_frac_CvM_Ni_ip ] ...
   = avg_rank_and_win_frac( CvM_number_Ni_ip, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for Ni in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_Ni_ip(clubb_idx), ...
               win_frac_CvM_Ni_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_Ni_ip

if ( test_rs )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for rs.
   avg_KS_number_rs = average_KS_stat( KS_number_rs, num_clubb_files );

   % Print the average value of the K-S statistic for rs.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for rs\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_rs(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for rs.
   [ avg_rank_KS_rs win_frac_KS_rs ] ...
   = avg_rank_and_win_frac( KS_number_rs, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for rs\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_rs(clubb_idx), ...
               win_frac_KS_rs(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic for rs.
   % The normalized C-vM number is CvM_number_rs / num_pts_test_rs.
   avg_nrmlzed_CvM_number_rs ...
   = average_normalized_CvM_stat( CvM_number_rs, num_pts_test_rs, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic for rs.
   fprintf( '\n' );
   fprintf( 'Average of normalized C-vM test results for rs\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_rs(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for rs.
   [ avg_rank_CvM_rs win_frac_CvM_rs ] ...
   = avg_rank_and_win_frac( CvM_number_rs, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for rs\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_rs(clubb_idx), ...
               win_frac_CvM_rs(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_rs

if ( test_Ns )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for Ns.
   avg_KS_number_Ns = average_KS_stat( KS_number_Ns, num_clubb_files );

   % Print the average value of the K-S statistic for Ns.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for Ns\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_Ns(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for Ns.
   [ avg_rank_KS_Ns win_frac_KS_Ns ] ...
   = avg_rank_and_win_frac( KS_number_Ns, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for Ns\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_Ns(clubb_idx), ...
               win_frac_KS_Ns(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic for Ns.
   % The normalized C-vM number is CvM_number_Ns / num_pts_test_Ns.
   avg_nrmlzed_CvM_number_Ns ...
   = average_normalized_CvM_stat( CvM_number_Ns, num_pts_test_Ns, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic for Ns.
   fprintf( '\n' );
   fprintf( 'Average of normalized C-vM test results for Ns\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_Ns(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for Ns.
   [ avg_rank_CvM_Ns win_frac_CvM_Ns ] ...
   = avg_rank_and_win_frac( CvM_number_Ns, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for Ns\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_Ns(clubb_idx), ...
               win_frac_CvM_Ns(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_Ns

if ( test_rs_ip )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for rs in-precip.
   avg_KS_number_rs_ip ...
   = average_KS_stat( KS_number_rs_ip, num_clubb_files );

   % Print the average value of the K-S statistic for rs in-precip.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for rs in-precip.\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_rs_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for rs in-precip.
   [ avg_rank_KS_rs_ip win_frac_KS_rs_ip ] ...
   = avg_rank_and_win_frac( KS_number_rs_ip, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for rs in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_rs_ip(clubb_idx), ...
               win_frac_KS_rs_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic
   % for rs in-precip.
   % The normalized C-vM number is CvM_number_rs_ip / num_pts_test_rs_ip.
   avg_nrmlzed_CvM_number_rs_ip ...
   = average_normalized_CvM_stat( CvM_number_rs_ip, num_pts_test_rs_ip, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic
   % for rs in-precip.
   fprintf( '\n' );
   fprintf( [ 'Average of normalized C-vM test results for' ...
              ' rs in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_rs_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for rs in-precip.
   [ avg_rank_CvM_rs_ip win_frac_CvM_rs_ip ] ...
   = avg_rank_and_win_frac( CvM_number_rs_ip, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for rs in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_rs_ip(clubb_idx), ...
               win_frac_CvM_rs_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_rs_ip

if ( test_Ns_ip )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for Ns in-precip.
   avg_KS_number_Ns_ip ...
   = average_KS_stat( KS_number_Ns_ip, num_clubb_files );

   % Print the average value of the K-S statistic for Ns in-precip.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for Ns in-precip.\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_Ns_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for Ns in-precip.
   [ avg_rank_KS_Ns_ip win_frac_KS_Ns_ip ] ...
   = avg_rank_and_win_frac( KS_number_Ns_ip, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for Ns in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_Ns_ip(clubb_idx), ...
               win_frac_KS_Ns_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic
   % for Ns in-precip.
   % The normalized C-vM number is CvM_number_Ns_ip / num_pts_test_Ns_ip.
   avg_nrmlzed_CvM_number_Ns_ip ...
   = average_normalized_CvM_stat( CvM_number_Ns_ip, num_pts_test_Ns_ip, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic
   % for Ns in-precip.
   fprintf( '\n' );
   fprintf( [ 'Average of normalized C-vM test results for' ...
              ' Ns in-precip\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_Ns_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for Ns in-precip.
   [ avg_rank_CvM_Ns_ip win_frac_CvM_Ns_ip ] ...
   = avg_rank_and_win_frac( CvM_number_Ns_ip, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for Ns in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_Ns_ip(clubb_idx), ...
               win_frac_CvM_Ns_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_Ns_ip

if ( test_rg )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for rg.
   avg_KS_number_rg = average_KS_stat( KS_number_rg, num_clubb_files );

   % Print the average value of the K-S statistic for rg.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for rg\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_rg(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for rg.
   [ avg_rank_KS_rg win_frac_KS_rg ] ...
   = avg_rank_and_win_frac( KS_number_rg, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for rg\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_rg(clubb_idx), ...
               win_frac_KS_rg(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic for rg.
   % The normalized C-vM number is CvM_number_rg / num_pts_test_rg.
   avg_nrmlzed_CvM_number_rg ...
   = average_normalized_CvM_stat( CvM_number_rg, num_pts_test_rg, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic for rg.
   fprintf( '\n' );
   fprintf( 'Average of normalized C-vM test results for rg\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_rg(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for rg.
   [ avg_rank_CvM_rg win_frac_CvM_rg ] ...
   = avg_rank_and_win_frac( CvM_number_rg, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for rg\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_rg(clubb_idx), ...
               win_frac_CvM_rg(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_rg

if ( test_Ng )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for Ng.
   avg_KS_number_Ng = average_KS_stat( KS_number_Ng, num_clubb_files );

   % Print the average value of the K-S statistic for Ng.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for Ng\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_Ng(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for Ng.
   [ avg_rank_KS_Ng win_frac_KS_Ng ] ...
   = avg_rank_and_win_frac( KS_number_Ng, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for Ng\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_Ng(clubb_idx), ...
               win_frac_KS_Ng(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic for Ng.
   % The normalized C-vM number is CvM_number_Ng / num_pts_test_Ng.
   avg_nrmlzed_CvM_number_Ng ...
   = average_normalized_CvM_stat( CvM_number_Ng, num_pts_test_Ng, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic for Ng.
   fprintf( '\n' );
   fprintf( 'Average of normalized C-vM test results for Ng\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_Ng(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for Ng.
   [ avg_rank_CvM_Ng win_frac_CvM_Ng ] ...
   = avg_rank_and_win_frac( CvM_number_Ng, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for Ng\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_Ng(clubb_idx), ...
               win_frac_CvM_Ng(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_Ng

if ( test_rg_ip )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for rg in-precip.
   avg_KS_number_rg_ip ...
   = average_KS_stat( KS_number_rg_ip, num_clubb_files );

   % Print the average value of the K-S statistic for rg in-precip.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for rg in-precip.\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_rg_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for rg in-precip.
   [ avg_rank_KS_rg_ip win_frac_KS_rg_ip ] ...
   = avg_rank_and_win_frac( KS_number_rg_ip, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for rg in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_rg_ip(clubb_idx), ...
               win_frac_KS_rg_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic
   % for rg in-precip.
   % The normalized C-vM number is CvM_number_rg_ip / num_pts_test_rg_ip.
   avg_nrmlzed_CvM_number_rg_ip ...
   = average_normalized_CvM_stat( CvM_number_rg_ip, num_pts_test_rg_ip, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic
   % for rg in-precip.
   fprintf( '\n' );
   fprintf( [ 'Average of normalized C-vM test results for' ...
              ' rg in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_rg_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for rg in-precip.
   [ avg_rank_CvM_rg_ip win_frac_CvM_rg_ip ] ...
   = avg_rank_and_win_frac( CvM_number_rg_ip, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for rg in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_rg_ip(clubb_idx), ...
               win_frac_CvM_rg_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_rg_ip

if ( test_Ng_ip )

   fprintf( '\n' )
   fprintf( '==================================================\n' )

   % Calculate the average value of the K-S statistic for Ng in-precip.
   avg_KS_number_Ng_ip ...
   = average_KS_stat( KS_number_Ng_ip, num_clubb_files );

   % Print the average value of the K-S statistic for Ng in-precip.
   fprintf( '\n' );
   fprintf( 'Average of K-S test results for Ng in-precip.\n' );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_KS_number_Ng_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the K-S test for Ng in-precip.
   [ avg_rank_KS_Ng_ip win_frac_KS_Ng_ip ] ...
   = avg_rank_and_win_frac( KS_number_Ng_ip, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for K-S test results for Ng in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_KS_Ng_ip(clubb_idx), ...
               win_frac_KS_Ng_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average value of the normalized C-vM statistic
   % for Ng in-precip.
   % The normalized C-vM number is CvM_number_Ng_ip / num_pts_test_Ng_ip.
   avg_nrmlzed_CvM_number_Ng_ip ...
   = average_normalized_CvM_stat( CvM_number_Ng_ip, num_pts_test_Ng_ip, ...
                                  num_clubb_files );

   % Print the average value of the normalized C-vM statistic
   % for Ng in-precip.
   fprintf( '\n' );
   fprintf( [ 'Average of normalized C-vM test results for' ...
              ' Ng in-precip\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( 'CLUBB file %d:  %g\n', ...
               clubb_idx, avg_nrmlzed_CvM_number_Ng_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

   % Calculate the average rank and winning fraction for each CLUBB
   % statistical file from the C-vM test for Ng in-precip.
   [ avg_rank_CvM_Ng_ip win_frac_CvM_Ng_ip ] ...
   = avg_rank_and_win_frac( CvM_number_Ng_ip, num_clubb_files );

   % Print the average rank and winning fraction for each CLUBB file.
   fprintf( '\n' );
   fprintf( [ 'Average rank and winning fraction for each CLUBB file' ...
              ' for C-vM test results for Ng in-precip.\n' ] );
   for clubb_idx = 1:1:num_clubb_files
      fprintf( [ 'CLUBB file %d:  average rank:  %g;' ...
                 '  winning fraction:  %g\n' ], ...
               clubb_idx, avg_rank_CvM_Ng_ip(clubb_idx), ...
               win_frac_CvM_Ng_ip(clubb_idx) );
   end % clubb_idx = 1:1:num_clubb_files

end % test_Ng_ip

fprintf( '\n' );
