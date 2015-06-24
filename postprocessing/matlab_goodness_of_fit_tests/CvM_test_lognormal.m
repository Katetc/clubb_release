% $Id$
function [ CvM_number_x num_test_pts ] ...
= CvM_test_lognormal( sam_var_x, mu_x_1_n, mu_x_2_n, sigma_x_1_n, ...
                      sigma_x_2_n, mixt_frac, precip_frac_1, ...
                      precip_frac_2, flag_ip_only, num_clubb_files )

% Function that calculates the Cramer-von Mises (C-vM) statistic for
% variable x comparing CLUBB to SAM LES 3D results.  This function is for
% variables that CLUBB uses a sum of two delta-logormal distributions to
% estimate the distribution.

% Sort SAM LES 3D data in ascending order.
sam_var_x_sort = sort( sam_var_x );

% Find the number of SAM LES 3D data points.
num_sam_pts = size( sam_var_x, 2 );

% Find the index in sam_var_x_sort where x is greater than 0.
for idx = 1:1:num_sam_pts
   if ( sam_var_x_sort(idx) > 0.0 )
      first_sam_x_pt_gt_0_idx = idx;
      break
   elseif ( idx == num_sam_pts )
      % The value of sam_var_x is 0 everywhere.
      first_sam_x_pt_gt_0_idx = num_sam_pts + 1;
   end % sam_var_x_sort(idx) > 0
end % idx = 1:1:num_sam_pts

% Calculate the total number of SAM LES 3D data points found within
% precipitation (where x > 0).
num_test_pts = num_sam_pts - first_sam_x_pt_gt_0_idx + 1;

% If there are an insufficient number of sample points, set the test value
% to -1 and return.
if ( num_test_pts < 50 )
   CvM_number_x(1:num_clubb_files) = -1.0;
   num_test_pts = 0;
   return
end % num_test_pts < 50

% Calculate CLUBB overall precipitation fraction.
for clubb_idx = 1:1:num_clubb_files
   precip_frac_clubb(clubb_idx) ...
   = mixt_frac(clubb_idx) * precip_frac_1(clubb_idx) ...
     + ( 1.0 - mixt_frac(clubb_idx) ) * precip_frac_2(clubb_idx);
end % clubb_idx = 1:1:num_clubb_files

if ( flag_ip_only )

   % Don't include x = 0 in CLUBB's CDF.
   for clubb_idx = 1:1:num_clubb_files
      clubb_cdf_at_0(clubb_idx) = 0.0;
   end % clubb_idx = 1:1:num_clubb_files

else % ~flag_ip_only

   % Calculate the CLUBB CDF at x = 0.
   for clubb_idx = 1:1:num_clubb_files
      clubb_cdf_at_0(clubb_idx) = 1.0 - precip_frac_clubb(clubb_idx);
   end % clubb_idx = 1:1:num_clubb_files

end % flag_ip_only

% Loop over all CLUBB data sets (files).
for clubb_idx = 1:1:num_clubb_files
   for idx = first_sam_x_pt_gt_0_idx:1:num_sam_pts

      % Find the value of x at the index location.
      var_x = sam_var_x_sort(idx);

      % Calculate the value of the CLUBB CDF at x.
      clubb_cdf ...
      = clubb_cdf_at_0(clubb_idx) ...
        + mixt_frac(clubb_idx) * precip_frac_1(clubb_idx) ...
          * CDF_comp_Lognormal( var_x, mu_x_1_n(clubb_idx), ...
                                sigma_x_1_n(clubb_idx) ) ...
          + ( 1.0 - mixt_frac(clubb_idx) ) * precip_frac_2(clubb_idx) ...
            * CDF_comp_Lognormal( var_x, mu_x_2_n(clubb_idx), ...
                                  sigma_x_2_n(clubb_idx) );

      if ( flag_ip_only )
         clubb_cdf = clubb_cdf / precip_frac_clubb(clubb_idx);
      end % flag_ip_only

      % Find the difference squared between the CLUBB CDF and the SAM LES
      % CDF at the index point.
      if ( flag_ip_only )
         diff_sqd(clubb_idx,idx-first_sam_x_pt_gt_0_idx+1) ...
         = ( clubb_cdf ...
             - ( 2.0 * (idx-first_sam_x_pt_gt_0_idx+1) - 1.0 ) ...
                 / ( 2.0 * num_test_pts ) )^2;
      else % ~flag_ip_only
         diff_sqd(clubb_idx,idx-first_sam_x_pt_gt_0_idx+1) ...
         = ( clubb_cdf - ( 2.0 * idx - 1.0 ) / ( 2.0 * num_sam_pts ) )^2;
      end % flag_ip_only

   end % idx = 1:1:num_sam_pts

   % The C-vM statisitic is the sum of differences squared between the
   % CLUBB CDF and the SAM LES CDF, plus the factor.
   CvM_number_x(clubb_idx) ...
   = ( 1.0 / ( 12.0 * num_test_pts ) ) + sum( diff_sqd(clubb_idx,:) );

end % clubb_idx = 1:1:num_clubb_files
