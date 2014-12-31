import netCDF4
import numpy as np
import pylab as pl

l_all_height_avg = True

sim_points_all = [10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200]

clubb_var_str = 'rrm_auto'
silhs_var_str  = 'lh_rrm_auto'

silhs_dirs = ["out_default", "out_prescribed"]

clubb_var = netCDF4.Dataset(silhs_dirs[0]+'/silhs_'+str(sim_points_all[0])+'/rico_lh_zt.nc').variables[clubb_var_str]

rms_all = list()
for d in silhs_dirs:
    rms_all.append(np.empty(len(sim_points_all)))

time1 = 3000
time2 = 4320

if not l_all_height_avg:
    k_lh_start = netCDF4.Dataset(silhs_dirs[0]+'/silhs_'+str(sim_points_all[0])+'/rico_lh_lh_sfc.nc').variables['k_lh_start']
    k_lh_start = k_lh_start[:,0,0,0]
else:
    n_heights = clubb_var.shape[1]

clubb_var = clubb_var[:,:,0,0]

for n_i in range(0,len(sim_points_all)):
    num_samples = sim_points_all[n_i]
    print("Trying " + str(num_samples) + " sample points.")
    for d_i in range(0,len(silhs_dirs)):
        silhs_dir = silhs_dirs[d_i]
        rms_val = 0.0
        silhs_var = netCDF4.Dataset(silhs_dir+'/silhs_'+str(num_samples)+'/rico_lh_lh_zt.nc').variables[silhs_var_str]
        n_timesteps = time2-time1
        silhs_var = silhs_var[:,:,0,0]

        for t in range(time1,time2):
            if l_all_height_avg:
                for k in range(0,n_heights):
                    rms_val = rms_val + (clubb_var[t,k]-silhs_var[t,k])**2
            else:
                k = int(round(k_lh_start[t]))-1
                rms_val = rms_val + (clubb_var[t,k]-silhs_var[t,k])**2

        rms_val = rms_val / n_timesteps
        if l_all_height_avg:
            rms_val = rms_val / n_heights
        rms_val = np.sqrt(rms_val)
        rms_all[d_i][n_i] = rms_val

for d_i in range(0,len(silhs_dirs)):
    pl.plot(sim_points_all, rms_all[d_i], label=silhs_dirs[d_i])

pl.xlabel('Number of Sample Points')
pl.ylabel('Root Mean Square of Absolute Error')
pl.xscale('log')
pl.yscale('log')
#pl.axis('tight')

pl.legend()
pl.show()
