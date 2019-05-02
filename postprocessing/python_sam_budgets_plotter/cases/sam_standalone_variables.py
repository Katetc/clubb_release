"""
-------------------------------------------------------------------------------
   G E N E R A L   I N F O R M A T I O N
-------------------------------------------------------------------------------
This file contains general constants and information about the SAM variables saved
in the netCDF file needed for plotgen.py.

The list variables sortPlots, plotNames and lines are sorted identically in
order to relate the individual variables.
"""

#-------------------------------------------------------------------------------
#   I M P O R T S
#-------------------------------------------------------------------------------
from numpy import nan

#-------------------------------------------------------------------------------
#   C O N S T A N T S
#-------------------------------------------------------------------------------
DAY = 24                                                    # 1d  = 24h
HOUR = 3600                                                 # 1h  = 3600s
KG = 1000.                                                  # 1kg = 1000g
g_per_second_to_kg_per_day = 1. / (DAY * HOUR * KG)
kg_per_second_to_kg_per_day = 1. / (DAY * HOUR)
filler = nan                                                # Define the fill value which should replace invalid values in the data
startLevel = 0                                              # Set the lower height level at which the plots should begin. For example, startLevel=2 would cut off the lowest 2 data points for each line.
header = 'SAM standalone profiles'
name = 'sam_standalone'                                     # String used as part of the output file name
nc_files = ['sam']                                          # NetCDF files needed for plots, paths are defined

#-------------------------------------------------------------------------------
# P L O T S
#-------------------------------------------------------------------------------
# Names of the variables
sortPlots = ['theta_l', 'r_t', 'theta_l_flux', 'corr_w_tl', 'r_t_flux', 'corr_w_rt', 'cloudliq_frac', 'r_c', 'w_var', 'w3', 'theta_l_var', 'r_t_var', 'covar_thetal_rt', 'wobs', 'U', 'V', 'covar_uw', 'covar_vw', 'u_var', 'v_var', 'corr_uw', 'corr_vw',\
                'QR', 'QR_IP', 'QRP2', 'QRP2_QRIP', \
                'Nrm', 'Nrm_IP', 'Nrp2', 'Nrp2_NrmIP', \
                'Ncm', 'Ncm_IP', 'Ncp2', 'Ncp2_NcmIP', \
                'Ngm', 'Ngm_IP', 'Ngp2', 'Ngp2_NgmIP', \
                'Qgm', 'Qgm_IP', 'Qgp2', 'Qgp2_QgmIP', \
                'Qim', 'Qim_IP', 'Qip2', 'Qip2_QimIP', \
                'Nim', 'Nim_IP', 'Nip2', 'Nip2_NimIP', \
                'Qsm', 'Qsm_IP', 'Qsp2', 'Qsp2_QsmIP', \
                'Nsm', 'Nsm_IP', 'Nsp2', 'Nsp2_NsmIP', \
                'MicroFractions', 'Buoy_Flux', \
                'uprcp', 'uprtp', 'upthlp', 'upthvp', \
                'vprcp', 'vprtp', 'vpthlp', 'vpthvp', \
                'ucld' , 'vcld' , 'wcld',\
                'ucond', 'uweight', 'vcond', 'vweight', 'wcod', 'wweight',\
                'uwcond', 'uwweight', 'vwcond', 'vwweight', 'tvcond', 'tvweight', 'tlcond', 'tlweight', 'qtwcond', 'qtwweight',\
                'uwall','vwall',\
                ]
                
# settings of each plot:
# plot number, plot title, axis label
plotNames = [\
                [r'Liquid Water Potential Temperature, $\theta_l$', r'$\theta_l\ \mathrm{\left[K\right]}$'],\
                [r'Total Water Mixing Ratio, $r_t}$', r'rtm / qt $\mathrm{\left[kg\,kg^{-1}\right]}$'],\
                [r'Turbulent Flux of $\theta_l$', r'wpthlp / thflux(s) $\mathrm{\left[K\,m\,s^{-1}\right]}$'],\
                [r'Corr($w,\theta_l$)', r"Correlation $\overline{w'\theta_l'} / \sqrt{\overline{w'^2}\;\overline{\theta_l'^2}}\ \mathrm{\left[-\right]}$"],\
                [r'Turbulent Flux of $r_t$', r'wprtp / qtflux(s) $\mathrm{\left[kg\,kg^{-1}\,m\,s^{-1}\right]}$'],\
                [r'Corr($w,r_t$)', r"Correlation, $\overline{w'r_t'} / \sqrt{\overline{w'^2}\;\overline{r_t'^2}}\ \mathrm{\left[-\right]}$"],\
                ['Cloud Liquid Fraction', ' [%/100]'],\
                ['Cloud Water Mixing Ratio, r_c', r'rcm / qcl $\mathrm{\left[kg\,kg^{-1}\right]}$'],\
                [r"$\overline{w'^2}$", r"Momentum variance, $\overline{w'^2}\ \mathrm{\left[m^2\,s^{-2}\right]}$"],\
                [r"$\overline{w'^3}$", r"Third-order Moment, $\overline{w'^3}\ \mathrm{\left[m^3\,s^{-3}\right]}$"],\
                [r'Variance of $\theta_l$', r'thlp2 / tl2 $\mathrm{\left[K^2\right]}$'],\
                [r'Variance of $r_t$', r'rtp2 / qtp2 $\mathrm{\left[kg^2\,kg^{-2}\right]}$'],\
                [r'Covariance of $r_t$ & $\theta_l$', r'rtpthlp $\mathrm{\left[kg\,kg^{-1}\,K\right]}$'],\
                [r"$w_{obs}$", r"Observed wind, $w_{obs}\ \mathrm{\left[m\,s^{-1}\right]}$"],\
                [r"Zonal Wind Component, $\overline{u}$", r"$\overline{u}\ \mathrm{\left[m\,s^{-1}\right]}$"],\
                [r"Meridonal Wind Component, $$overline{v}$", r"$\overline{v}\ \mathrm{\left[m\,s^{-1}\right]}$"],\
                [r"$\overline{u'w'}$", r"Momentum flux, $\overline{u'w'}\ \mathrm{\left[m^2\,s^{-2}\right]}$"],\
                [r"$\overline{v'w'}$", r"Momentum flux, $\overline{v'w'}\ \mathrm{\left[m^2\,s^{-2}\right]}$"],\
                [r"$\overline{u'^2}$", r"Momentum variance, $\overline{u'^2}\ \mathrm{\left[m^2\,s^{-2}\right]}$"],\
                [r"$\overline{v'^2}$", r"Momentum variance, $\overline{v'^2}\ \mathrm{\left[m^2\,s^{-2}\right]}$"],\
                [r"Corr($u,w$)", r"Correlation, $\overline{u'w'} / \sqrt{\overline{u'^2}\;\overline{w'^2}}\ \mathrm{\left[-\right]}$"],\
                [r"Corr($v,w$)", r"Correlation, $\overline{v'w'} / \sqrt{\overline{v'^2}\;\overline{w'^2}}\ \mathrm{\left[-\right]}$"],\
                # Rain Water Mixing Ratio
                ['Rain Water Mixing Ratio', r'qrm $\mathrm{\left[kg\,kg^{-1}\right]}$'],\
                ['Rain Water Mixing Ratio in Rain', r'qrm_ip $\mathrm{\left[kg\,kg^{-1}\right]}$'],\
                ['Domain-wide Variance\nof Rain Water Mixing Ratio', r'qrp2 $\mathrm{\left[kg^2\,kg^{-2}\right]}$'],\
                ['Within-rain Variance\nof Rain Water Mixing Ratio', r'qrp2_ip / qrm_ip^2 [-]'],\
                #Rain Drop Number Concentration
                ['Rain Drop Concentration', r'Nrm $\mathrm{\left[num\,kg^{-1}\right]}$'],\
                ['Rain Drop Concentration in Rain', r'Nrm_ip $\mathrm{\left[num\,kg^{-1}\right]}$'],\
                ['Domain-wide Variance\nof Rain Drop Concentration', r'Nrp2 $\mathrm{\left[num^2\,kg^{-2}\right]}$'],\
                ['Within-rain Variance\nof Rain Drop Concentration', 'Nrp2_ip / Nrm_ip^2 [-]'],\
                #Cloud Droplet Number Concentration
                ['Cloud Droplet Number Concentration', r'Ncm $\mathrm{\left[num\,kg^{-1}\right]}$'],\
                ['Cloud Droplet Number Concentration in Cloud', r'Ncm_ip $\mathrm{\left[num\,kg^{-1}\right]}$'],\
                ['Domain-wide Variance\nof Cloud Droplet Number Concentration', r'Ncp2 $\mathrm{\left[\#^2\,kg^{-2}\right]}$'],\
                ['Within-cloud Variance\nof Cloud Droplet Number Concentration', 'Ncp2_ip / Ncm_ip^2 [-]'],\
                #Graupel Number Concentration
                ['Graupel Number Concentration', r'Ngm $\mathrm{\left[kg\,kg^{-1}\right]}$'],\
                ['Graupel Number Concentration in Graupel', r'Ngm_ip $\mathrm{\left[num\,kg^{-1}\right]}$'],\
                ['Domain-wide Variance\nof Graupel Number Concentration', r'Ngp2 $\mathrm{\left[kg^2\,kg^{-2}\right]}$'],\
                ['Within-graupel Variance\nof Graupel Number Concentration', 'Ngp2_ip / Ngm_ip^2 [-]'],\
                #Graupel Mixing Ratio
                ['Graupel Mixing Ratio', r'qgm $\mathrm{\left[kg\,kg^{-1}\right]}$'],\
                ['Graupel Mixing Ratio in Graupel', r'qgm_ip $\mathrm{\left[kg\,kg^{-1}\right]}$'],\
                ['Domain-wide Variance\nof Graupel Mixing Ratio', r'qgp2 $\mathrm{\left[kg^2\,kg^{-2}\right]}$'],\
                ['Within-graupel Variance\nof Graupel Mixing Ratio', 'qgp2_ip / qgm_ip^2 [-]'],\
                #Cloud Ice Mixing Ratio
                ['Cloud Ice Mixing Ratio', r'qim $\mathrm{\left[kg\,kg^{-1}\right]}$'],\
                ['Cloud Ice Mixing Ratio in Cloud Ice', r'qim_ip $\mathrm{\left[kg\,kg^{-1}\right]}$'],\
                ['Domain-wide Variance\nof Cloud Ice Mixing Ratio', r'qip2 $\mathrm{\left[kg^2\,kg^{-2}\right]}$'],\
                ['Within-cloud-ice Variance\nof Cloud Ice  Mixing Ratio', 'qip2_ip / qim_ip^2 [-]'],\
                #Cloud Ice Number Concentration
                ['Cloud Ice Concentration', r'Nim $\mathrm{\left[num\,kg^{-1}\right]}$'],\
                ['Cloud Ice Number Concentration in Cloud Ice', r'Ni_ip $\mathrm{\left[num\,kg^{-1}\right]}$'],\
                ['Domain-wide Variance\nof Cloud Ice Number Concentration', r'Nip2 $\mathrm{\left[num^2\,kg^{-2}\right]}$'],\
                ['Within-cloud-ice Variance\nof Cloud Ice Number Concentration', 'Nip2_ip / Nim_ip^2 [-]'],\
                #Snow Mixing Ratio
                ['Snow Mixing Ratio ', r'qsm $\mathrm{\left[kg\,kg^{-1}\right]}$'],\
                ['Snow Mixing Ratio in Snow', r'qsm_ip $\mathrm{\left[kg\,kg^{-1}\right]}$'],\
                ['Domain-wide Variance\nof Snow Mixing Ratio', r'qsp2 $\mathrm{\left[kg^2\,kg^{-2}\right]}$'],\
                ['Within-snow Variance\nof Snow Mixing Ratio ', 'qsp2_ip / qsm_ip^2 [-]'],\
                #Snow Number Concentration
                ['Snow Number Concentration', r'Nsm $\mathrm{\left[num\,kg^{-1}\right]}$'],\
                ['Snow Number Concentration in Snow', r'Nsm_ip $\mathrm{\left[num\,kg^{-1}\right]}$'],\
                ['Domain-wide Variance\nof Snow Number Concentration', r'Nsp2 $\mathrm{\left[\#^2\,kg^{-2}\right]}$'],\
                ['Within-snow Variance\nof Snow Number Concentration', 'Nsp2_ip / Nsm_ip^2 [-]'],\
                ['Micro Fractions', '[%/100]'],\
                ['Buoyancy flux', r'wpthvp / tlflux $\mathrm{\left[K\,m\,s^{-1}\right]}$'],\
                #['Liquid Water Path', r'lwp $\mathrm{\left[kg\,m^{-2}\right]}$'],\
                #['Surface rainfall rate', r'rain_rate_sfc $\mathrm{\left[mm\,d^{-1}]}$'],\
                #['Density-Weighted Vertically Averaged wp2', r'wp2 / w2 $\mathrm{\left[m^2\,s^{-2}\right]}$'],\
                #['Cloud Ice Water Path', r'iwp $\mathrm{\left[kg\,m^{-2}]}$'],\
                #['Snow Water Path', r'swp $\mathrm{\left[kg\,m^{-2}]}$'],\
                # buoyancy sub-terms for parameterization in upwp budget
                [r"$\overline{u'r_c'}$", r"Liquid water flux, $\overline{u'r_c'}\ \mathrm{\left[m^2\,s^{-2}\right]}$"],\
                [r"$\overline{u'r_t'}$", r"Total water flux, $\overline{u'r_t'}\ \mathrm{\left[m^2\,s^{-2}\right]}$"],\
                [r"$\overline{u'\theta_l'}$", r"Liq. water pot. temp. flux, $\overline{u'\theta_l'}\ \mathrm{\left[m^2\,s^{-2}\right]}$"],\
                [r"$\overline{u'\theta_v'}$", r"Virtual pot. temp. flux, $\overline{u'\theta_v'}\ \mathrm{\left[m^2\,s^{-2}\right]}$"],\
                # buoyancy sub-terms for parameterization in vpwp budget
                [r"$\overline{v'r_c'}$", r"Liquid water flux, $\overline{v'r_c'}\ \mathrm{\left[m^2\,s^{-2}\right]}$"],\
                [r"$\overline{v'r_t'}$", r"Total water flux, $\overline{v'r_t'}\ \mathrm{\left[m^2\,s^{-2}\right]}$"],\
                [r"$\overline{v'\theta_l'}$", r"Liq. water pot. temp. flux, $\overline{v'\theta_l'}\ \mathrm{\left[m^2\,s^{-2}\right]}$"],\
                [r"$\overline{v'\theta_v'}$", r"Virtual pot.temp. flux, $\overline{v'\theta_v'}\ \mathrm{\left[m^2\,s^{-2}\right]}$"],\
                # Conditional mean wind speeds in clouds
                [r"$\overline{u}^\mathrm{{cld}}$", r"Conditional mean wind, $\overline{u}^\mathrm{{cld}}\ \mathrm{\left[m\,s^{-1}\right]}$"],\
                [r"$\overline{v}^\mathrm{{cld}}$", r"Conditional mean wind, $\overline{v}^\mathrm{{cld}}\ \ \mathrm{\left[m\,s^{-1}\right]}$"],\
                [r"$\overline{w}^\mathrm{{cld}}$", r"Conditional mean wind, $\overline{w}^\mathrm{{cld}}\ \ \mathrm{\left[m\,s^{-1}\right]}$"],\
                # Conditional comparison plots for wind components
                [r"Condt. $\overline{u}^\mathrm{cld},\ \overline{u}^\mathrm{env}$", r"Conditional mean wind, $\overline{u}\ \mathrm{\left[m\,s^{-1}\right]}$"],\
                [r"Weighted $\overline{u}^\mathrm{cld},\ \overline{u}^\mathrm{env}$", r"Weighted mean wind, $\overline{u}\ \mathrm{\left[m\,s^{-1}\right]}$"],\
                [r"Condt. $\overline{v}^\mathrm{cld},\ \overline{v}^\mathrm{env}$", r"Conditional mean wind, $\overline{v}\ \mathrm{\left[m\,s^{-1}\right]}$"],\
                [r"Weighted $\overline{v}^\mathrm{cld},\ \overline{v}^\mathrm{env}$", r"Weighted mean wind, $\overline{v}\ \mathrm{\left[m\,s^{-1}\right]}$"],\
                [r"Condt. $\overline{w}^\mathrm{cld},\ \overline{w}^\mathrm{env}$", r"Conditional mean wind, $\overline{w}\ \mathrm{\left[m\,s^{-1}\right]}$"],\
                [r"Weighted $\overline{w}^\mathrm{cld},\ \overline{w}^\mathrm{env}$", r"Weighted mean wind, $\overline{w}\ \mathrm{\left[m\,s^{-1}\right]}$"],\
                # Conditional comparison plots for momentum flux
                [r"Condt. $\overline{u'w'}^\mathrm{cld}, \overline{u'w'}^\mathrm{env}$", r"Conditional flux, $\overline{u'w'}\ \mathrm{\left[m^2\, s^{-2}\right]}$"],\
                [r"Weighted $\overline{u'w'}^\mathrm{cld}, \overline{u'w'}^\mathrm{env}$", r"Weighted flux, $\overline{u'w'}\ \mathrm{\left[m^2\, s^{-2}\right]}$"],\
                [r"Condt. $\overline{v'w'}^\mathrm{cld}, \overline{v'w'}^\mathrm{env}$", r"Conditional flux, $\overline{v'w'}\ \mathrm{\left[m^2\, s^{-2}\right]}$"],\
                [r"Weighted $\overline{v'w'}^\mathrm{cld}, \overline{v'w'}^\mathrm{env}$", r"Weighted flux, $\overline{v'w'}\ \mathrm{\left[m^2\, s^{-2}\right]}$"],\
                [r"Condt. $\overline{\theta}_v^\mathrm{cld}, \overline{\theta}_v^\mathrm{env}$", r"Conditional virt. pot. temp., $\overline{\theta}_v\ \mathrm{\left[K\right]}$"],\
                [r"Weighted $\overline{\theta}_v^\mathrm{cld}, \overline{\theta}_v^\mathrm{env}$", r"Weighted virt. pot. temp., $\overline{\theta}_v\ \mathrm{\left[K\right]}$"],\
                [r"Condt. $\overline{w's_L'}^\mathrm{cld}, \overline{w's_L'}^\mathrm{env}$", r"Conditional flux, $\overline{w's_L'}\ \mathrm{\left[K\,m\, s^{-1}\right]}$"],\
                [r"Weighted $\overline{w's_L'}^\mathrm{cld}, \overline{w's_L'}^\mathrm{env}$", r"Weighted flux, $\overline{w's_L'}\ \mathrm{\left[K\,m\, s^{-1}\right]}$"],\
                [r"Condt. $\overline{w'r_t'}^\mathrm{cld}, \overline{w'r_t'}^\mathrm{env}$", r"Conditional flux, $\overline{w'r_t'}\ \mathrm{\left[kg\,kg^{-1}\, m\,s^{-1}\right]}$"],\
                [r"Weighted $\overline{w'r_t'}^\mathrm{cld}, \overline{w'r_t'}^\mathrm{env}$", r"Weighted flux, $\overline{w'r_t'}\ \mathrm{\left[kg\,kg^{-1}\, m\,s^{-1}\right]}$"],\
                [r"Eastward 2nd-moments", r"2nd moments $\mathrm{\left[m^2\,s^{-2}\right]}$"],\
                [r"Northward 2nd-moments", r"2nd moments $\mathrm{\left[m^2\,s^{-2}\right]}$"],\
            ]

# lines of each plot:
# variable name within python, shall this variable be plotted?, variable name in SAM output, conversion

thetal = [\
         # variables of thetal
         ['THETAL', False, 'THETAL', 1., 0],\
         ['THETA', False, 'THETA', 1., 0],\
         ['TABS', False, 'TABS', 1., 0],\
         ['QI', False, 'QI', 1./KG, 0],\
         [r'$\theta_l$', True, 'THETAL + 2500.4 * (THETA/TABS) * QI', 1., 0],\
        ]        

rt = [\
         # variables of rt
         ['QI', False, 'QI', 1., 0],\
         ['QT', False, 'QT', 1., 0],\
         ['RT', True, '(QT-QI)', 1./KG, 0],\
        ]

thetalflux = [\
         # variables of thetalflux
         ['TLFLUX', False, 'TLFLUX', 1., 0],\
         ['RHO', False, 'RHO', 1., 0],\
         ['WPTHLP_SGS', False, 'WPTHLP_SGS', 1., 0],\
         [r"$\overline{w'\theta_l'}$", True, '((TLFLUX) / (RHO * 1004.)) + WPTHLP_SGS', 1., 0],\
        ]

corr_w_tl = [\
        # variables of corr_w_tl
        ['TLFLUX', False, 'TLFLUX', 1., 0],\
        ['TL2', False, 'TL2', 1., 0],\
        ['W2', False, 'W2', 1., 0],\
        ['RHO', False, 'RHO', 1., 0],\
        ['WPTHLP_SGS', False, 'WPTHLP_SGS', 1., 0],\
        [r'Corr($w,\theta_l$)', True, '(((TLFLUX) / (RHO * 1004.)) + WPTHLP_SGS)/np.sqrt(W2*TL2 + 1e-4)', 1., 0],\
        ]

rtflux = [\
         # variables of rtflux
         ['QTFLUX', False, 'QTFLUX', 1., 0],\
         ['RHO', False, 'RHO', 1., 0],\
         ['WPRTP_SGS', False, 'WPRTP_SGS', 1., 0],\
         [r"$\overline{w'r_t'}$", True, '(QTFLUX/ (RHO * 2.5104e+6)) + WPRTP_SGS', 1., 0],\
        ]


corr_w_rt = [\
        # variables of corr_w_rt
        ['QTFLUX', False, 'QTFLUX', 1., 0],\
        ['QT2', False, 'QT2', 1., 0],\
        ['W2', False, 'W2', 1., 0],\
        ['RHO', False, 'RHO', 1., 0],\
        ['WPRTP_SGS', False, 'WPRTP_SGS', 1., 0],\
        [r'Corr($w,r_t$)', True, '((QTFLUX/ (RHO * 2.5104e+6)) + WPRTP_SGS)/np.sqrt((W2*QT2)+1e-4)', 1., 0],\
        ]

cloudliqfrac = [\
        # variables of cloudliqfrac
        ['cloudliq_frac_em6', True, 'cloudliq_frac_em6', 1., 0],\
        ]
        
qcl = [\
         # variables of qcl
         ['QCL', True, 'QCL', 1./KG, 0],\
        ]
        
wVar = [\
         # variables of wVar
         ['WP2_SGS', False, 'WP2_SGS', 1., 0],\
         ['W2', False, 'W2', 1., 0],\
         [r"$\overline{w'^2}$", True, 'WP2_SGS + W2', 1., 0],\
        ]
        
w3 = [\
         # variables of wVar
         ['WP3_SGS', False, 'WP3_SGS', 1., 0],\
         ['W3', False, 'W3', 1., 0],\
         [r"$\overline{w'^3}$", True, 'WP3_SGS + W3', 1., 0],\
        ]
        
thetalVar = [\
         # variables of thetalVar
         ['THLP2_SGS', False, 'THLP2_SGS', 1., 0],\
         ['TL2', False, 'TL2', 1., 0],\
         ['THETALVAR', True, 'THLP2_SGS + TL2', 1., 0],\
        ]
        
rtVar = [\
         # variables of rtVar
         ['RTP2_SGS', False, 'RTP2_SGS', 1., 0],\
         ['QT2', False, 'QT2', 1., 0],\
         ['RTVAR', True, '(QT2 / 1e+6) + RTP2_SGS', 1., 0],\
        ]
        
covarThetalRt = [\
         # variables of covarThetalRt
         ['CovarThetaLRT', True, 'RTPTHLP_SGS', 1., 0],\
        ]
        
wobs = [\
         # variables of wobs
         ['WOBS', True, 'WOBS', 1., 0],\
        ]
        
U = [\
         # variables of U
        [r"$\overline{u}$", True, 'U', 1., 0],\
        ]
        
V = [\
         # variables of V
        [r"$\overline{v}$", True, 'V', 1., 0],\
        ]
        
covarUW = [\
         # variables of covarUW (standard SAM run has no SGS output, only SB)
         ['UPWP_SGS', False, 'UPWP_SGS', 1., 0],\
         [r"$\overline{u'w'}$ (subgrid)", True, 'UWSB', 1., 0],\
         ['UW', False, 'UW', 1., 0],\
         [r"$\overline{u'w'}$ (resolved)", True,'UW-UWSB+UPWP_SGS',1,0],\
         [r"$\overline{u'w'}$ (total)", True, 'UW+UPWP_SGS', 1., 0],\
        ]
        
covarVW = [\
         # variables of covarVW (standard SAM run has no SGS output, only SB)
         ['VPWP_SGS', False, 'VPWP_SGS', 1., 0],\
         [r"$\overline{v'w'}$ (subgrid)", True, 'VWSB', 1., 0],\
         ['VW', False, 'VW', 1., 0],\
         [r"$\overline{v'w'}$ (resolved)", True,'VW-VWSB',1,0],\
         [r"$\overline{v'w'}$ (total)", True, 'VW + VPWP_SGS', 1., 0],\
        ]

uVar = [\
         # variables of uVar
         ['UP2_SGS', False, 'UP2_SGS', 1., 0],\
         ['U2', False, 'U2', 1., 0],\
         [r"$\overline{u'^2}$", True, 'UP2_SGS + U2', 1., 0],\
        ]

vVar = [\
         # variables of vVar
         ['VP2_SGS', False, 'VP2_SGS', 1., 0],\
         ['V2', False, 'V2', 1., 0],\
         [r"$\overline{v'^2}$", True, 'VP2_SGS + V2', 1., 0],\
        ]

corrUW = [\
        # variables of uVar
        ['UP2_SGS', False, 'UP2_SGS', 1., 0],\
        ['U2', False, 'U2', 1., 0],\
        # variables of wVar
        ['WP2_SGS', False, 'WP2_SGS', 1., 0],\
        ['W2', False, 'W2', 1., 0],\
        # variables of covarUW
        ['UPWP_SGS', False, 'UPWP_SGS', 1., 0],\
        ['UW', False, 'UW', 1., 0],\
        [r'Corr($u,w$)', True,'(UW+UPWP_SGS)/(np.sqrt((U2+UP2_SGS)*(W2+WP2_SGS)+1e-4))', 1., 0],\
        ]
    
corrVW = [\
        # variables of vVar
        ['VP2_SGS', False, 'VP2_SGS', 1., 0],\
        ['V2', False, 'V2', 1., 0],\
        # variables of wVar
        ['WP2_SGS', False, 'WP2_SGS', 1., 0],\
        ['W2', False, 'W2', 1., 0],\
        # variables of covarUW
        ['VPWP_SGS', False, 'VPWP_SGS', 1., 0],\
        ['VW', False, 'VW', 1., 0],\
        [r'Corr($v,w$)', True,'(VW+VPWP_SGS)/(np.sqrt((V2+VP2_SGS)*(W2+WP2_SGS)+1e-4))', 1., 0],\
        ]

# Rain Water Mixing Ratio

QR = [\
         # variables of QR
         ['QR', True, 'QR', 1./KG, 0],\
        ]
        
QRIP = [\
         # variables of QRIP
        ['qrainm_ip', True, 'qrainm_ip', 1., 0],\
        ]
          
QRP2 = [\
         # variables of QRP2
        ['qrainp2', True, 'qrainp2', 1., 0],\
        ]
        
QRP2_QRIP = [\
         # variables of QRP2_QRIP
         ['qrainp2_ip', False, 'qrainp2_ip', 1., 0],\
         ['qrainm_ip', False, 'qrainm_ip', 1., 0],\
         ['QRP2_QRIP', True, '(qrainp2_ip / (np.maximum(np.full(n,1e-5),qrainm_ip)**2))', 1., 0],\
        ]
        
#Rain Drop Number Concentration

Nrm = [\
         # variables of Nrm
         ['NR', False, 'NR', 1., 0],\
         ['RHO', False, 'RHO', 1., 0],\
         ['NRM', True, '(NR * 1e+6) / RHO', 1., 0],\
        ]
             
Nrm_IP = [\
         # variables of Nrm_IP
        ['nrainm_ip', True, 'nrainm_ip', 1., 0],\
        ]
        
Nrp2 = [\
         # variables of Nrp2
        ['nrainp2', True, 'nrainp2', 1., 0],\
        ]
        
Nrp2_NrmIP = [\
         # variables of Nrp2_NrmIP
         ['nrainp2_ip', False, 'nrainp2_ip', 1., 0],\
         ['nrainm_ip', False, 'nrainm_ip', 1., 0],\
         ['Nrp2_NrmIP', True, '(nrainp2_ip / (np.maximum(np.full(n,1e-5),nrainm_ip)**2))', 1., 0],\
        ]
        
#Cloud Droplet Number Concentration

Ncm = [\
         # variables of Ncm
         ['NC', False, 'NC', 1., 0],\
         ['RHO', False, 'RHO', 1., 0],\
         ['NCM', True, '(NC * 1e+6) / RHO', 1., 0],\
        ]
             
Ncm_IP = [\
         # variables of Ncm_IP
         ['ncloudliqm_ip', True, 'ncloudliqm_ip', 1., 0],\
        ]
        
Ncp2 = [\
         # variables of Ncp2
         ['Ncp2', True, 'Ncp2', 1., 0],\
        ]
        
Ncp2_NcmIP = [\
         # variables of Ncp2_NcmIP
         ['ncloudliqp2_ip', False, 'ncloudliqp2_ip', 1., 0],\
         ['ncloudliqm_ip', False, 'ncloudliqm_ip', 1., 0],\
         ['Ncp2_NcmIP', True, '(ncloudliqp2_ip / (np.maximum(np.full(n,1e-5),ncloudliqm_ip)**2))', 1., 0],\
        ]
        
#Graupel Number Concentration

Ngm = [\
         # variables of Ngm
         ['NG', False, 'NG', 1., 0],\
         ['RHO', False, 'RHO', 1., 0],\
         ['NGM', True, '(NG * 1e+6) / RHO', 1., 0],\
        ]
             
Ngm_IP = [\
         # variables of Ngm_IP
         ['ngraupelm_ip', True, 'ngraupelm_ip', 1., 0],\
        ]
        
Ngp2 = [\
         # variables of Ngp2
         ['ngraupelp2', True, 'ngraupelp2', 1., 0],\
        ]
        
Ngp2_NgmIP = [\
         # variables of Ngp2_NgmIP
         ['ngraupelp2_ip', False, 'ngraupelp2_ip', 1., 0],\
         ['ngraupelm_ip', False, 'ngraupelm_ip', 1., 0],\
         ['Ngp2_NgmIP', True, '(ngraupelp2_ip / (np.maximum(np.full(n,1e-5),ngraupelm_ip)**2))', 1., 0],\
        ]
        
#Graupel Mixing Ratio

Qgm = [\
         # variables of Qgm
         ['QG', True, 'QG', 1./KG, 0],\
        ]
             
Qgm_IP = [\
         # variables of Qgm_IP
         ['qgraupelm_ip', True, 'qgraupelm_ip', 1., 0],\
        ]
        
Qgp2 = [\
         # variables of Qgp2
        ['qgraupelp2', True, 'qgraupelp2', 1., 0],\
        ]
        
Qgp2_QgmIP = [\
         # variables of Qgp2_QgmIP
         ['qgraupelp2_ip', False, 'qgraupelp2_ip', 1., 0],\
         ['qgraupelm_ip', False, 'qgraupelm_ip', 1., 0],\
         ['Qgp2_QgmIP', True, '(qgraupelp2_ip / (np.maximum(np.full(n,1e-5),qgraupelm_ip)**2))', 1., 0],\
        ]
        
#Cloud Ice Mixing Ratio

# Note: redundant, could not find variable in sam
Qim = [\
         # variables of Qim
         ['QG', True, 'QG', 1./KG, 0],\
        ]
             
Qim_IP = [\
         # variables of Qim_IP
        ['qcloudicem_ip', True, 'qcloudicem_ip', 1., 0],\
        ]
        
Qip2 = [\
         # variables of Qip2
        ['qcloudicep2', True, 'qcloudicep2', 1., 0],\
        ]
        
Qip2_QimIP = [\
         # variables of Qip2_QimIP
         ['qcloudicep2_ip', False, 'qcloudicep2_ip', 1., 0],\
         ['qcloudicem_ip', False, 'qcloudicem_ip', 1., 0],\
         ['Qip2_QimIP', True, '(qcloudicep2_ip / (np.maximum(np.full(n,1e-5),qcloudicem_ip)**2))', 1., 0],\
        ]
        
#Cloud Ice Number Concentration

Nim = [\
         # variables of Nim
         ['NI', False, 'NI', 1., 0],\
         ['RHO', False, 'RHO', 1., 0],\
         ['NIM', True, '(NI * 1e+6) / RHO', 1., 0],\
        ]
             
Nim_IP = [\
         # variables of Nim_IP
        ['ncloudicem_ip', True, 'ncloudicem_ip', 1., 0],\
        ]
        
Nip2 = [\
         # variables of Nip2
        ['ncloudicep2', True, 'ncloudicep2', 1., 0],\
        ]
        
Nip2_NimIP = [\
         # variables of Nip2_NimIP
         ['ncloudicep2_ip', False, 'ncloudicep2_ip', 1., 0],\
         ['ncloudicem_ip', False, 'ncloudicem_ip', 1., 0],\
         ['Nip2_NimIP', True, '(ncloudicep2_ip / (np.maximum(np.full(n,1e-5),ncloudicem_ip)**2))', 1., 0],\
        ]

#Snow Mixing Ratio

Qsm = [\
         # variables of Qsm
         ['QSM', True, 'QS', 1./KG, 0],\
        ]
             
Qsm_IP = [\
         # variables of Qsm_IP
        ['qsnowm_ip', True, 'qsnowm_ip', 1., 0],\
        ]
        
Qsp2 = [\
         # variables of Qsp2
        ['qsnowp2', True, 'qsnowp2', 1., 0],\
        ]
        
Qsp2_QsmIP = [\
         # variables of Qsp2_QsmIP
         ['qsnowp2_ip', False, 'qsnowp2_ip', 1., 0],\
         ['qsnowm', False, 'qsnowm', 1., 0],\
         ['Qsp2_QsmIP', True, '(qsnowp2_ip / (np.maximum(np.full(n,1e-5),qsnowm)**2))', 1., 0],\
        ]
        
#Snow Number Concentration

Nsm = [\
         # variables of Nsm
         ['NS', False, 'NS', 1., 0],\
         ['RHO', False, 'RHO', 1., 0],\
         ['NSM', True, '(NS * 1e+6) / RHO', 1., 0],\
        ]
             
Nsm_IP = [\
         # variables of Nsm_IP
        ['nsnowm_ip', True, 'nsnowm_ip', 1., 0],\
        ]
        
Nsp2 = [\
         # variables of Nsp2
        ['nsnowp2', True, 'nsnowp2', 1., 0],\
        ]
        
Nsp2_NsmIP = [\
         # variables of Nsp2_NsmIP
         ['nsnowp2_ip', False, 'nsnowp2_ip', 1., 0],\
         ['nsnowm_ip', False, 'nsnowm_ip', 1., 0],\
         ['Nsp2_NsmIP', True, '(nsnowp2_ip / (np.maximum(np.full(n,1e-5),nsnowm_ip)**2))', 1., 0],\
        ]
        

MicroFractions = [\
         # variables of MicroFractions
         ['Cloud_liq', True, 'cloudliq_frac_em6', 1., 0],\
         ['Rain', True, 'rain_frac_em6', 1., 0],\
         ['Cloud_ice', True, 'cloudice_frac_em6', 1., 0],\
         ['Snow', True, 'snow_frac_em6', 1., 0],\
         ['Graupel', True, 'graupel_frac_em6', 1., 0],\
        ]
        
Buoy_Flux = [\
         # variables of Buoy_Flux
         ['TVFLUX', False, 'TVFLUX', 1., 0],\
         ['RHO', False, 'RHO', 1., 0],\
         ['Buoy_Flux', True, 'TVFLUX / (RHO * 1004)', 1., 0],\
        ]
         
lwp = [\
         # variables of lwp
         ['CWP', True, 'CWP', 1./KG, 0],\
        ]
        
PREC = [\
         # variables of lwp
         ['PREC', True, 'PREC', 1., 0],\
        ]
           
WP2_W2 = [\
         # variables of WP2_W2
         ['NS', True, 'NS', 0., 0],\
        ]

IWP = [\
         # variables of IWP
         ['IWP', True, 'IWP', 1./KG, 0],\
        ]
        
SWP = [\
         # variables of SWP
         ['SWP', True, 'SWP', 1./KG, 0],\
        ]

uprcp = [\
        [r"$\overline{u'r_c'}$", True, 'UPRCP', 1., 0],\
        ]

uprtp = [\
        [r"$\overline{u'r_t'}$", True, 'UPRTP', 1., 0],\
        ]

upthlp = [\
        [r"$\overline{u'\theta_l'}$", True, 'UPTHLP', 1., 0],\
        ]
    
upthvp = [\
        [r"$\overline{u'\theta_v'}$", True, 'UPTHVP', 1., 0],\
        ]
    
vprcp = [\
        [r"$\overline{v'r_c'}$", True, 'VPRCP', 1., 0],\
        ]

vprtp = [\
        [r"$\overline{v'r_t'}$", True, 'VPRTP', 1., 0],\
        ]

vpthlp = [\
        [r"$\overline{v'\theta_l'}$", True, 'VPTHLP', 1., 0],\
        ]

vpthvp = [\
        [r"$\overline{v'\theta_v'}$", True, 'VPTHVP', 1., 0],\
        ]

# Conditional plots
ucld = [\
    [r'Layer averaged, $\overline{u}$', True, 'U', 1., 0 ],\
    [r'Cloud averaged, $\overline{u}^\mathrm{cld}$', True, 'UCLD', 1., 0 ],\
    ]

vcld = [\
    [r'Layer averaged, $\overline{v}}$', True, 'V', 1., 0 ],\
    [r'Cloud averaged, $\overline{v}^\mathrm{cld}$', True, 'VCLD', 1., 0 ],\
    ]

wcld = [\
    [r'Layer averaged, $\overline{w}$', True, 'WM', 1., 0 ],\
        [r'Cloud averaged, $\overline{w}^\mathrm{cld}$', True, 'WCLD', 1., 0 ],\
    ]

# Conditional comparison plots

ucond = [\
    [r'Layer averaged, $\overline{u}$', True, None, 1., 0 ],\
    [r'Cloud averaged, $\overline{u}^\mathrm{cld}$', True, 'UCLD', 1., 0 ],\
    ['U', False, 'U', 1., 0 ],\
    ['CLD', False, 'CLD', 1., 0],\
    [r'Environment averaged, $\overline{u}^\mathrm{env}$', True, '(U - CLD*UCLD)/(1-CLD)', 1., 0],\
    ]

uweight = [\
    ['UCLD', False, 'UCLD', 1., 0 ],\
    ['U', False, 'U', 1., 0 ],\
    ['CLD', False, 'CLD', 1., 0],\
    [r'Layer averaged, $\overline{u}$', True, None, 1., 0 ],\
    [r'Cloud averaged, $\overline{u}^\mathrm{cld}$', True, 'CLD * UCLD', 1., 0 ],\
    [r'Environment averaged, $\overline{u}^\mathrm{env}$', True, '(U - CLD*UCLD)', 1., 0],\
    ]

vcond = [\
    [r'Layer averaged, $\overline{v}$', True, None, 1., 0 ],\
    [r'Cloud averaged, $\overline{v}^\mathrm{cld}$', True, 'VCLD', 1., 0 ],\
    ['V', False, 'V', 1., 0 ],\
    ['CLD', False, 'CLD', 1., 0],\
    [r'Environment averaged, $\overline{v}^\mathrm{env}$', True, '(V - CLD*VCLD)/(1-CLD)', 1., 0],\
    ]

vweight = [\
    ['VCLD', False, 'VCLD', 1., 0 ],\
    ['V', False, 'V', 1., 0 ],\
    ['CLD', False, 'CLD', 1., 0],\
    [r'Layer averaged, $\overline{v}$', True, None, 1., 0 ],\
    [r'Cloud averaged, $\overline{v}^\mathrm{cld}$', True, 'CLD * VCLD', 1., 0 ],\
    [r'Environment averaged, $\overline{v}^\mathrm{env}$', True, '(V - CLD*VCLD)', 1., 0],\
    ]

wcond = [\
    ['WM', False, 'WM', 1., 0 ],\
    [r'Layer averaged, $\overline{w}$', True, None, 1., 0 ],\
    [r'Cloud averaged, $\overline{w}^\mathrm{cld}$', True, 'WCLD', 1., 0 ],\
    ['CLD', False, 'CLD', 1., 0],\
    [r'Environment averaged, $\overline{w}^\mathrm{env}$', True, '(WM - CLD*WCLD)/(1-CLD)', 1., 0],\
    ]

wweight = [\
    ['WM', False, 'WM', 1., 0 ],\
    ['WCLD', False, 'WCLD', 1., 0 ],\
    ['CLD', False, 'CLD', 1., 0],\
    [r'Layer averaged, $\overline{w}$', True, None, 1., 0 ],\
    [r'Cloud averaged, $\overline{w}^\mathrm{cld}$', True, 'CLD * WCLD', 1., 0 ],\
    [r'Environment averaged, $\overline{w}^\mathrm{env}$', True, '(WM - CLD*WCLD)', 1., 0],\
    ]

uwcond = [\
    [r"Layer averaged, $\overline{u'w'}$", True, None, 1., 0 ],\
    [r"Cloud averaged, $\overline{u'w'}^\mathrm{cld}$", True, 'UWCLD', 1., 0 ],\
    ['UW', False, 'UW', 1., 0 ],\
    ['CLD', False, 'CLD', 1., 0],\
    [r"Environment averaged, $\overline{u'w'}^\mathrm{env}$", True, '(UW - CLD*UWCLD)/(1-CLD)', 1., 1],\
    ]

uwweight = [\
    ['UWCLD', False, 'UWCLD', 1., 0 ],\
    ['UW', False, 'UW', 1., 0 ],\
    ['CLD', False, 'CLD', 1., 0],\
    [r"Layer averaged, $\overline{u'w'}$", True, None, 1., 0 ],\
    [r"Cloud averaged, $\overline{u'w'}^\mathrm{cld}$", True, 'CLD*UWCLD', 1., 0 ],\
    [r"Environment averaged, $\overline{u'w'}^\mathrm{env}$", True, '(UW - CLD*UWCLD)', 1., 0],\
    ]

vwcond = [\
    [r"Layer averaged, $\overline{v'w'}$", True, None, 1., 0 ],\
    [r"Cloud averaged, $\overline{v'w'}^\mathrm{cld}$", True, 'VWCLD', 1., 0 ],\
    ['VW', False, 'VW', 1., 0 ],\
    ['CLD', False, 'CLD', 1., 0],\
    [r"Environment averaged, $\overline{v'w'}^\mathrm{env}$", True, '(VW - CLD*VWCLD)/(1-CLD)', 1., 1],\
    ]

vwweight = [\
    ['VWCLD', False, 'VWCLD', 1., 0 ],\
    ['VW', False, 'VW', 1., 0 ],\
    ['CLD', False, 'CLD', 1., 0],\
    [r"Layer averaged, $\overline{v'w'}$", True, None, 1., 0 ],\
    [r"Cloud averaged, $\overline{v'w'}^\mathrm{cld}$", True, 'CLD * VWCLD', 1., 0 ],\
    [r"Environment averaged, $\overline{v'w'}^\mathrm{env}$", True, '(VW - CLD*VWCLD)', 1., 1],\
    ]

tvcond = [\
    [r"Layer averaged, $\overline{\theta}_v}$", True, None, 1., 0 ],\
    [r'Cloud averaged, $\overline{\theta}_v^\mathrm{cld}$', True, 'TVCLD', 1., 0 ],\
    ['THETAV', False, 'THETAV', 1., 0 ],\
    ['CLD', False, 'CLD', 1., 0],\
    [r'Environment averaged, $\overline{\theta}_v^\mathrm{env}$', True, '(THETAV - CLD*TVCLD)/(1-CLD)', 1., 0],\
    ]

tvweight = [\
    ['THETAV', False, 'THETAV', 1., 0 ],\
    [r'TVCLD', False, 'TVCLD', 1., 0 ],\
    ['CLD', False, 'CLD', 1., 0],\
    [r"Layer averaged, $\overline{\theta}_v}$", True, None, 1., 0 ],\
    [r'Cloud averaged, $\overline{\theta}_v^\mathrm{cld}$', True, 'CLD * TVCLD', 1., 0 ],\
    [r'Environment averaged, $\overline{\theta}_v^\mathrm{env}$', True, '(THETAV - CLD*TVCLD)/(1-CLD)', 1., 0],\
    ]

tlcond = [\
    [r"Layer averaged $\overline{w's_L'}$", True, None, 1., 0 ],\
    [r"Cloud averaged, $\overline{w's'_L}^\mathrm{cld}$", True, 'TLWCLD', 1., 0 ],\
    ['TLFLUX', False, 'TLFLUX', 1., 0 ],\
    ['CLD', False, 'CLD', 1., 0],\
    [r"Environment averaged, $\overline{w's'_L}^\mathrm{env}$", True, '(TLFLUX - CLD*TLWCLD)/(1-CLD)', 1., 0],\
    ]

tlweight = [\
    ['TLFLUX', False, 'TLFLUX', 1., 0 ],\
    [r"TLWCLD", False, 'TLWCLD', 1., 0 ],\
    ['CLD', False, 'CLD', 1., 0],\
    [r"Layer averaged $\overline{w's_L'}$", True, None, 1., 0 ],\
    [r"Cloud averaged, $\overline{w's'_L}^\mathrm{cld}$", True, 'CLD * TLWCLD', 1., 0 ],\
    [r"Environment averaged, $\overline{w's'_L}^\mathrm{env}$", True, '(TLFLUX - CLD*TLWCLD)/(1-CLD)', 1., 0],\
    ]

qtwcond= [\
    ['QTFLUX', False, 'QTFLUX', 1., 0 ],\
    #['WPRTP_SGS', False, 'WPRTP_SGS', 1., 0],\
    [r"QTWCLD", False, 'QTWCLD', 1., 0 ],\
    ['RHO', False, 'RHO', 1., 0],\
    ['CLD', False, 'CLD', 1., 0],\
    [r"Layer averaged $\overline{w'r_t'}$", True, None, 1., 0 ],\
    [r"Cloud averaged, $\overline{w'r_t'}^\mathrm{cld}$", True, 'QTWCLD/1000', 1., 0 ],\
    [r"Environment averaged, $\overline{w'r_t'}^\mathrm{env}$", True, '((QTFLUX/ (RHO * 2.5104e+6)) - CLD*QTWCLD/1000)/(1-CLD)', 1., 0],\
    ]

qtwweight = [\
    ['QTFLUX', False, 'QTFLUX', 1., 0 ],\
    #['WPRTP_SGS', False, 'WPRTP_SGS', 1., 0],\
    [r"QTWCLD", False, 'QTWCLD', 1., 0 ],\
    ['RHO', False, 'RHO', 1., 0],\
    ['CLD', False, 'CLD', 1., 0],\
    [r"Layer averaged $\overline{w'r_t'}$", True, None, 1., 0 ],\
    [r"Cloud averaged, $\overline{w'r_t'}^\mathrm{cld}$", True, 'CLD*QTWCLD/1000', 1., 0 ],\
    [r"Environment averaged, $\overline{w'r_t'}^\mathrm{env}$", True, '((QTFLUX/ (RHO * 2.5104e+6)) - CLD*QTWCLD/1000)', 1., 0],\
    ]

uwall = [\
    [r"Layer averaged, $\overline{u'w'}$", True, 'UW', 1., 0],\
    [r"Layer averaged, $\overline{u'^2}$", True, 'U2', 1., 0],\
    [r"Layer averaged, $\overline{w'^2}$", True, 'W2', 1., 0],\
        ]
    
vwall = [\
    [r"Layer averaged, $\overline{v'w'}$", True, 'VW', 1., 0],\
    [r"Layer averaged, $\overline{v'^2}$", True, 'V2', 1., 0],\
    [r"Layer averaged, $\overline{w'^2}$", True, 'W2', 1., 0],\
        ]

lines = [thetal, rt, thetalflux, corr_w_tl, rtflux, corr_w_rt, cloudliqfrac, qcl, \
        wVar, w3, thetalVar, rtVar, covarThetalRt, wobs, U, V, covarUW, covarVW, uVar, vVar, corrUW, corrVW, \
        QR, QRIP, QRP2, QRP2_QRIP, \
        Nrm, Nrm_IP, Nrp2, Nrp2_NrmIP, \
        Ncm, Ncm_IP, Ncp2, Ncp2_NcmIP, \
        Ngm, Ngm_IP, Ngp2, Ngp2_NgmIP, \
        Qgm, Qgm_IP, Qgp2, Qgp2_QgmIP, \
        Qim, Qim_IP, Qip2, Qip2_QimIP, \
        Nim, Nim_IP, Nip2, Nip2_NimIP, \
        Qsm, Qsm_IP, Qsp2, Qsp2_QsmIP, \
        Nsm, Nsm_IP, Nsp2, Nsp2_NsmIP, \
        MicroFractions, Buoy_Flux, \
        uprcp, uprtp, upthlp, upthvp, \
        vprcp, vprtp, vpthlp, vpthvp,\
        ucld, vcld, wcld,\
        ucond, uweight, vcond, vweight, wcond, wweight,\
        uwcond, uwweight, vwcond, vwweight, tvcond, tvweight, tlcond, tlweight, qtwcond, qtwweight,\
        uwall,vwall,\
        ]