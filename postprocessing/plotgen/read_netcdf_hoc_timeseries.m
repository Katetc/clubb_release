function avg_field = read_netcdf_hoc_timeseries(filename,nzmax,t1,t2,varnum,numvars)

% Reads and time-averages profiles from 3D NETCDF *.nc files.
% thlm = read_netcdf_hoc('tune/arm_zt.dat',110,1,1,1,28)
% nzmax = number of z levels in profile
% t1 = beginning timestep to look at
% t2 = ending timestep to look at
% varnum = which variable to read (see .ctl file)
% numvars = total number of variables in grads file (see .ctl file)

% open NETCDF file
fid = netcdf.open(filename,'NC_NOWRITE');

%Ensure the file will be closed no matter what happens
cleanupHandler = onCleanup(@()netcdf.close(fid));

%Preallocate arrays for speed
avg_field(t1:t2) = 0.0;

%Check to see how many dimensions the variable has
[varname, xtype, dimids, numatts] = netcdf.inqVar(fid,varnum);

field = netcdf.getVar(fid,varnum);
if max(size(dimids)) == 1
   for t=t1:t2
      new_field = field(t);
      avg_field(t) = new_field;
   end
else
   % Read in and average profiles over all timesteps
   for t=t1:t2
      if strfind (filename, 'gfdl' ) %GFDL timeseries must be handled differently
         new_field = squeeze(field(1,1,t));
      else
         new_field = squeeze(field(1,1,1,t));	
      end
      avg_field(t) = new_field;
   end
end

end
