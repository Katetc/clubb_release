% $Id$
function plot_CLUBB_PDF_LES_pts_L( var_x_LES, ...
                                   nx_LES_grid, ny_LES_grid, ...
                                   num_x_pts, log_Px_plot, ...
                                   mu_x_1_n, mu_x_2_n, ...
                                   sigma_x_1_n, sigma_x_2_n, ...
                                   precip_frac_1, precip_frac_2, ...
                                   mixt_frac, var_x_label, ...
                                   case_name, field_plotted, ...
                                   time_plotted, ...
                                   altitude_plotted, ...
                                   note )
                                
% Path to PDF analysis functions.
addpath ( '../../utilities/PDF_analysis', '-end' )

scr_size= get(0,'ScreenSize');
fig_height = 0.9*scr_size(4);
fig_width  = fig_height;
figure('Position',[ 0 0 fig_width fig_height ])

subplot( 'Position', [ 0.1 0.1 0.8 0.8 ] )

% Histogram and marginal for x, a variable that is distributed
% delta-lognormally in each PDF component.
pos_count_x = 0;
zero_count_x = 0;
% The variable var_x_LES_pos contains only x > 0 results from the LES.
for i = 1:1:nx_LES_grid*ny_LES_grid
   if ( var_x_LES(i) > 0.0 )
      pos_count_x = pos_count_x + 1;
      var_x_LES_pos(pos_count_x) = var_x_LES(i);
   else
      zero_count_x = zero_count_x + 1;
   end
end
precip_frac_x_LES = pos_count_x / ( nx_LES_grid * ny_LES_grid );
precip_frac_clubb ...
= mixt_frac * precip_frac_1 + ( 1.0 - mixt_frac ) * precip_frac_2;
min_x = min( var_x_LES_pos );
max_x = max( var_x_LES_pos );
num_x_divs = num_x_pts + 1;
delta_x = ( max_x - min_x ) / num_x_pts;
x_divs = zeros( num_x_divs, 1 );
x = zeros( num_x_pts, 1 );
P_x = zeros( num_x_pts, 1 );
% Calculate the x "division points" (edges of the bins).
for i = 1:1:num_x_divs
   x_divs(i) = min_x + delta_x * ( i - 1 );
end
% Calculate the x points (center of each bin).
for i = 1:1:num_x_pts
   x(i) = 0.5 * ( x_divs(i) + x_divs(i+1) );
end
% CLUBB's PDF marginal for x (lognormal or in-precip portion).
for i = 1:1:num_x_pts
   P_x(i) ...
   = mixt_frac * precip_frac_1 ...
     * PDF_comp_Lognormal( x(i), mu_x_1_n, sigma_x_1_n ) ...
     + ( 1.0 - mixt_frac ) * precip_frac_2 ...
       * PDF_comp_Lognormal( x(i), mu_x_2_n, sigma_x_2_n );
end
% Centerpoints and counts for each bin (from LES results) for x, where
% x > 0.
binranges_x = x;
[bincounts_x] = histc( var_x_LES, binranges_x );
% Plot normalized histogram of LES results for x, where x > 0.
if ( log_Px_plot )
   semilogy( binranges_x, ...
             max( bincounts_x, 1.0e-300 ) ...
             / ( nx_LES_grid * ny_LES_grid * delta_x ), ...
             '-r', 'LineWidth', 3 );
else
   bar( binranges_x, ...
        bincounts_x / ( nx_LES_grid * ny_LES_grid * delta_x ), ...
        1.0, 'r', 'EdgeColor', 'r' );
end
if ( precip_frac_x_LES < 1.0 )
   hold on
   % Plot normalized histogram of LES results for x, where x = 0.
   arrow_vec = get( gca, 'Position' );
   annotation( 'arrow', [ arrow_vec(1) arrow_vec(1) ], ...
               [ arrow_vec(2) arrow_vec(2)+arrow_vec(4) ], ...
               'Color', 'r', 'LineStyle', '-', 'LineWidth', 3, ...
               'HeadLength', 11, 'HeadWidth', 11 );
end
hold on
% Plot PDF of x for CLUBB, where x > 0.
if ( log_Px_plot )
   semilogy( x, P_x, '-b', 'LineWidth', 2 )
else
   plot( x, P_x, '-b', 'LineWidth', 2 )
end
if ( precip_frac_clubb < 1.0 )
   hold on
   % Plot PDF of x for CLUBB, where x = 0.
   arrow_vec = get( gca, 'Position' );
   annotation( 'arrow', [ arrow_vec(1) arrow_vec(1) ], ...
               [ arrow_vec(2) arrow_vec(2)+arrow_vec(4) ], ...
               'Color', 'b', 'LineStyle', '-', 'LineWidth', 2, ...
               'HeadLength', 7, 'HeadWidth', 7 );
end
hold off
% Set the range of the plot on both the x-axis and y-axis.
if ( precip_frac_clubb < 1.0 || precip_frac_x_LES < 1.0 )
   xlim([0 max_x]);
else
   xlim([min_x max_x]);
end
if ( log_Px_plot )
   min_pos_bincounts_x = max(bincounts_x);
   for i = 1:1:num_x_pts
      if ( bincounts_x(i) > 0 )
         min_pos_bincounts_x = min( min_pos_bincounts_x, bincounts_x(i) );
      end
   end
   ylim( [ 0.001 * min_pos_bincounts_x ...
                   / ( nx_LES_grid * ny_LES_grid * delta_x ) ...
           max( max(bincounts_x) ...
                / ( nx_LES_grid * ny_LES_grid * delta_x ), ...
                max(P_x) ) ] );
else
   ylim( [ 0 max( max(bincounts_x) ...
                  / ( nx_LES_grid * ny_LES_grid * delta_x ), ...
                  max(P_x) ) ] );
end
xlabel( var_x_label )
ylabel( [ 'P( ', field_plotted, ' )' ] )
legend( 'LES', 'CLUBB', 'Location', 'NorthEast' );
grid on
box on

% Figure title and other important information.
title( [ case_name, '; ', field_plotted, '; ',  time_plotted, '; ', ...
         altitude_plotted, '; ', note ] );
