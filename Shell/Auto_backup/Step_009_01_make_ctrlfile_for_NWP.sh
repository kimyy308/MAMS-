#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

testname=auto01
#fulldate=`date --date="2 days ago" +%Y%m%d`
fulldate=$1
MAMS=$2
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`
workdir=$MAMS/Model/ROMS/01_NWP_1_10
inputdir=$MAMS/Model/ROMS/01_NWP_1_10/Input
trunkdir=$MAMS/Model/ROMS/trunk

refday=${year}0101.0d0
dt=120
ininame=${inpudir}/auto01_ini.nc

oneday=`echo "(86400/${dt})"|bc`
onehour=`echo "(3600/${dt})"|bc`
tenminute=`echo "(600/${dt})"|bc`
ntimes=`echo "${oneday}*4"|bc`
nrst=${oneday}
nhis=`echo "${onehour}*3"|bc`
ndefhis=${oneday}
navg=${oneday}
ndefavg=${oneday}
nsta=${tenminute}
nflt=${tenminute}
ninfo=1

datadir=$MAMS/Data/01_NWP_1_10/Output/Daily/$year/$month/$fulldate/
mkdir -p $datadir
cd $datadir
ctrlfile=${testname}_${fulldate}.in
#arr_i=(00 03 06 09 12 15 18 21)
cat > $ctrlfile << EOF

! Application title.

       TITLE = ROMS 3.7 - North Western Pacific 10km

! C-preprocessing Flag.

    MyAppCPP = NWP4

! Input variable information file name.  This file needs to be processed
! first so all information arrays can be initialized properly.

     VARNAME = ${trunkdir}/ROMS/External/varinfo.dat


! Number of nested grids.

     Ngrids =   1


! Grid dimension parameters. See notes below in the Glossary for how to set
! these parameters correctly.

          Lm == 468            ! Number of I-direction INTERIOR RHO-points
          Mm == 458            ! Number of J-direction INTERIOR RHO-points
           N == 40              ! Number of vertical levels

        Nbed =  0             ! Number of sediment bed layers

         NAT =  2             ! Number of active tracers (usually, 2)
         NPT =  0             ! Number of inactive passive tracers
         NCS =  0             ! Number of cohesive (mud) sediment tracers
         NNS =  0             ! Number of non-cohesive (sand) sediment tracers

! Domain decomposition parameters for serial, distributed-memory or
! shared-memory configurations used to determine tile horizontal range
! indices (Istr,Iend) and (Jstr,Jend), [1:Ngrids].

      NtileI == 4                               ! I-direction partition
      NtileJ == 3                               ! J-direction partition

! Time-Stepping parameters.

      NTIMES ==  ${ntimes}
          DT == ${dt}.0d0
     NDTFAST == 10


! Set lateral boundary conditions keyword. Notice that a value is expected
! for each boundary segment per nested grid for each state variable.
!
! Each tracer variable requires [1:4,1:NAT+NPT,Ngrids] values. Otherwise,
! [1:4,1:Ngrids] values are expected for other variables. The boundary
! order is: 1=west, 2=south, 3=east, and 4=north. That is, anticlockwise
! starting at the western boundary.
!
! The keyword is case insensitive and usually has three characters. However,
! it is possible to have compound keywords, if applicable. For example, the
! keyword "RadNud" implies radiation boundary condition with nudging. This
! combination is usually used in active/passive radiation conditions.
!
!   Keyword    Lateral Boundary Condition Type
!
!   Cha        Chapman
!   Cla        Clamped
!   Clo        Closed
!   Fla        Flather                                _____N_____     j=Mm
!   Gra        Gradient                              |     4     |
!   Nes        Nested                                |           |
!   Nud        Nudging                             1 W           E 3
!   Per        Periodic                              |           |
!   Rad        Radiation                             |_____S_____|
!   Red        Reduced Physics                             2          j=1
!                                                   i=1         i=Lm
!                   W       S       E       N
!                   e       o       a       o
!                   s       u       s       r
!                   t       t       t       t
!                           h               h
!
!                   1       2       3       4

   LBC(isFsur) ==   Cha     Cha     Cha     Cha         ! free-surface
   LBC(isUbar) ==   Fla     Fla     Fla     Fla         ! 2D U-momentum
   LBC(isVbar) ==   Fla     Fla     Fla     Fla         ! 2D V-momentum
   LBC(isUvel) ==   Cla     Cla     Cla     Cla         ! 3D U-momentum
   LBC(isVvel) ==   Cla     Cla     Cla     Cla         ! 3D V-momentum
   LBC(isMtke) ==   Clo     Clo     Clo     Clo         ! mixing TKE

   LBC(isTvar) ==   Cla     Cla     Cla     Cla \       ! temperature
                    Cla     Cla     Cla     Cla        ! salinity

! Adjoint-based algorithms can have different lateral boundary
! conditions keywords.

ad_LBC(isFsur) ==   Cha     Cha     Cha     Cha         ! free-surface
ad_LBC(isUbar) ==   Fla     Fla     Fla     Fla         ! 2D U-momentum
ad_LBC(isVbar) ==   Fla     Fla     Fla     Fla         ! 2D U-momentum
ad_LBC(isUvel) ==   Cla     Cla     Cla     Cla         ! 3D U-momentum
ad_LBC(isVvel) ==   Cla     Cla     Cla     Cla         ! 3D V-momentum
ad_LBC(isMtke) ==   Clo     Clo     Clo     Clo         ! mixing TKE

ad_LBC(isTvar) ==   Cla     Cla     Cla     Cla \       ! temperature
                    Cla     Cla     Cla     Cla         ! salinity

! Set lateral open boundary edge volume conservation switch for
! nonlinear model and adjoint-based algorithms. Usually activated
! with radiation boundary conditions to enforce global mass
! conservation, except if tidal forcing enabled. [1:Ngrids].

   VolCons(west)  ==  F                            ! western  boundary
   VolCons(east)  ==  F                            ! eastern  boundary
   VolCons(south) ==  F                            ! southern boundary
   VolCons(north) ==  F                             ! northern boundary

ad_VolCons(west)  ==  F                            ! western  boundary
ad_VolCons(east)  ==  F                            ! eastern  boundary
ad_VolCons(south) ==  F                            ! southern boundary
ad_VolCons(north) ==  F                            ! northern boundary


! Model iteration loops parameters.

       ERstr =  1
       ERend =  1
      Nouter =  1
      Ninner =  1
  Nintervals =  1

! Number of eigenvalues (NEV) and eigenvectors (NCV) to compute for the
! Lanczos/Arnoldi problem in the Generalized Stability Theory (GST)
! analysis. NCV must be greater than NEV (see documentation below).

         NEV =  2                               ! Number of eigenvalues
         NCV =  10                              ! Number of eigenvectors

! Input/Output parameters.

       NRREC == 0
   LcycleRST == F
        NRST == ${nrst}
        NSTA == ${nsta}
        NFLT == ${nflt}
!!        NINFO == 479520
       NINFO == ${ninfo}

! Output history, average, diagnostic files parameters.

     LDEFOUT == T
        NHIS == ${nhis}
     NDEFHIS == ${ndefhis}
      NTSAVG == 1
        NAVG == ${navg}
     NDEFAVG == ${ndefavg}
      NTSDIA == 1
        NDIA == 479520
     NDEFDIA == 479520

! Output tangent linear and adjoint models parameters.

   LcycleTLM == F
        NTLM == 72
     NDEFTLM == 0
   LcycleADJ == F
        NADJ == 72
     NDEFADJ == 0
        NSFF == 72
        NOBC == 72

! Output check pointing GST restart parameters.

   LmultiGST =  F                               ! one eigenvector per file
     LrstGST =  F                               ! GST restart switch
  MaxIterGST =  500                             ! maximun number of iterations
        NGST =  10                              ! check pointing interval

! Relative accuracy of the Ritz values computed in the GST analysis.

    Ritz_tol =  1.0d-15

! Harmonic/biharmonic horizontal diffusion of tracer: [1:NAT+NPT,Ngrids].

        TNU2 == 20.0d0  20.0d0                  ! m2/s
        TNU4 == 0.0001d0 0.0001d0                       ! m4/s

     ad_TNU2 == 0.0d0  0.0d0
     ad_TNU4 == 0.0d0  0.0d0

! Harmononic/biharmonic, horizontal viscosity coefficient: [Ngrids].

       VISC2 == 200.0d0                        ! m2/s
       VISC4 == 0.0d0                          ! m4/s

    ad_VISC2 == 0.0d0                        ! m2/s
    ad_VISC4 == 0.0d0                          ! m4/s

! Vertical mixing coefficients for active tracers: [1:NAT+NPT,Ngrids]

    AKT_BAK == 1.0d-6 1.0d-6                   ! m2/s

    ad_AKT_fac == 1.0d0  1.0d0                 ! nondimensional

! Vertical mixing coefficient for momentum: [Ngrids].

    AKV_BAK == 1.0d-5                          ! m2/s

    ad_AKV_fac == 1.0d0                        ! nondimensional

! Turbulent closure parameters.

     AKK_BAK == 1.0d-5                          ! m2/s
     AKP_BAK == 1.0d-5                          ! m2/s
      TKENU2 == 0.0d0                           ! m2/s
      TKENU4 == 0.0d0                           ! m4/s

! Generic length-scale turbulence closure parameters.

        GLS_P ==3.0d0                           ! M-Y 2.5
       GLS_M == 1.5d0
       GLS_N == -1.0d0
    GLS_Kmin == 7.6d-6
    GLS_Pmin == 1.0d-12

    GLS_CMU0 == 0.5477d0           !0.5270d0
      GLS_C1 == 1.44d0
      GLS_C2 == 1.92d0
     GLS_C3M == -0.4d0            !-0.64d0
     GLS_C3P == 1.0d0
    GLS_SIGK == 1.0d0
    GLS_SIGP == 1.3d0

! Constants used in surface turbulent kinetic energy flux computation.

  CHARNOK_ALPHA == 1400.0d0         ! Charnok surface roughness
 ZOS_HSIG_ALPHA == 0.5d0            ! roughness from wave amplitude
       SZ_ALPHA == 0.25d0           ! roughness from wave dissipation
      CRGBAN_CW == 100.0d0          ! Craig and Banner wave breaking

! Constants used in momentum stress computation.

        RDRG == 3.0d-04                    ! m/s
       RDRG2 == 3.0d-03                    ! nondimensional
         Zob == 0.001d0                     ! m
         Zos == 0.02d0                     ! m

! Height (m) of atmospheric measurements for Bulk fluxes parameterization.

      BLK_ZQ ==  2.0d0                     ! air humidity
      BLK_ZT ==  2.0d0                     ! air temperature
      BLK_ZW == 10.0d0                     ! winds

! Minimum depth for wetting and drying.

       DCRIT == 0.10d0                     ! m

! Various parameters.

       WTYPE == 2
     LEVSFRC == 40
     LEVBFRC == 1

! Set vertical, terrain-following coordinates transformation equation and
! stretching function (see below for details), [1:Ngrids].

    Vtransform == 2                          ! transformation equation
    Vstretching == 4                          ! stretching function

! Vertical S-coordinates parameters, [1:Ngrids].

     THETA_S == 10.0d0                      ! surface stretching parameter
     THETA_B == 1.0d0                      ! bottom  stretching parameter
      TCLINE == 250.0d0                      ! critical depth (m)

! Mean Density and Brunt-Vaisala frequency.

        RHO0 =  1025.0d0                   ! kg/m3
     BVF_BAK =  1.0d-5                     ! 1/s2

! Time-stamp assigned for model initialization, reference time
! origin for tidal forcing, and model reference time for output
! NetCDF units attribute.

      DSTART =  0.0d0                      ! days
  TIDE_START =  0.0d0                   ! days
    TIME_REF =  ${year}0101.0d0                      ! yyyymmdd.dd

! Nudging/relaxation time scales, inverse scales will be computed
! internally, [1:Ngrids].

      TNUDG ==  10.0d0                ! days
      ZNUDG ==  0.0d0                      ! days
      M2NUDG == 0.0d0                      ! days
      M3NUDG == 5.0d0                      ! days

! Factor between passive (outflow) and active (inflow) open boundary
! conditions, [1:Ngrids]. If OBCFAC > 1, nudging on inflow is stronger
! than on outflow (recommended).

      OBCFAC == 5.0d0                      ! nondimensional

! Linear equation of State parameters:

          R0 == 1027.0d0                   ! kg/m3
          T0 == 10.0d0                     ! Celsius
          S0 == 35.0d0                     ! PSU
       TCOEF == 1.7d-4                     ! 1/Celsius
       SCOEF == 7.6d-4                     ! 1/PSU

! Slipperiness parameter: 1.0 (free slip) or -1.0 (no slip)

      GAMMA2 == 1.0d0


! Logical switches (TRUE/FALSE) to activate horizontal momentum transport
! point Sources/Sinks (like river runoff transport) and mass point
! Sources/Sinks (like volume vertical influx), [1:Ngrids].

    LuvSrc == T                        ! horizontal momentum transport
    LwSrc == F                         ! volume vertical influx

! Logical switches (TRUE/FALSE) to specify which variables to consider on
! tracers point Sources/Sinks (like river runoff): [1:NAT+NPT,Ngrids].
! See glossary below for details.

  LtracerSrc == T T                        ! temperature, salinity, inert

! Logical switches (TRUE/FALSE) to read and process climatology fields.
! See glossary below for details.

     LsshCLM == F                          ! sea-surface height
      Lm2CLM == F                          ! 2D momentum
      Lm3CLM == F                          ! 3D momentum

  LtracerCLM == F F                        ! temperature, salinity, inert

! Starting (DstrS) and ending (DendS) day for adjoint sensitivity forcing.
! DstrS must be less or equal to DendS. If both values are zero, their
! values are reset internally to the full range of the adjoint integration.

       DstrS == 0.0d0                      ! starting day
       DendS == 0.0d0                      ! ending day

! Starting and ending vertical levels of the 3D adjoint state variables
! whose sensitivity is required.

       KstrS == 1                          ! starting level
       KendS == 1                          ! ending level

! Logical switches (TRUE/FALSE) to specify the adjoint state variables
! whose sensitivity is required.

Lstate(isFsur) == F                        ! free-surface
Lstate(isUbar) == F                        ! 2D U-momentum
Lstate(isVbar) == F                        ! 2D V-momentum
Lstate(isUvel) == F                        ! 3D U-momentum
Lstate(isVvel) == F                        ! 3D V-momentum

! Logical switches (TRUE/FALSE) to specify the adjoint state tracer
! variables whose sensitivity is required (NT values are expected).

Lstate(isTvar) == F F                      ! tracers

! Logical switches (TRUE/FALSE) to specify the state variables for
! which Forcing Singular Vectors or Stochastic Optimals is required.

Fstate(isFsur) == F                        ! free-surface
Fstate(isUbar) == F                        ! 2D U-momentum
Fstate(isVbar) == F                        ! 2D V-momentum
Fstate(isUvel) == F                        ! 3D U-momentum
Fstate(isVvel) == F                        ! 3D V-momentum
Fstate(isTvar) == F F                      ! NT tracers

Fstate(isUstr) == T                        ! surface U-stress
Fstate(isVstr) == T                        ! surface V-stress
Fstate(isTsur) == F F                      ! NT surface tracers flux


! Stochastic optimals time decorrelation scale (days) assumed for
! red noise processes.

    SO_decay == 2.0d0                      ! days

! Stochastic optimals surface forcing standard deviation for
! dimensionalization.

SO_sdev(isFsur) == 1.0d0                   ! free-surface
SO_sdev(isUbar) == 1.0d0                   ! 2D U-momentum
SO_sdev(isVbar) == 1.0d0                   ! 2D V-momentum
SO_sdev(isUvel) == 1.0d0                   ! 3D U-momentum
SO_sdev(isVvel) == 1.0d0                   ! 3D V-momentum
SO_sdev(isTvar) == 1.0d0 1.0d0             ! NT tracers

SO_sdev(isUstr) == 1.0d0                   ! surface u-stress
SO_sdev(isVstr) == 1.0d0                   ! surface v-stress
SO_sdev(isTsur) == 1.0d0 1.0d0             ! NT surface tracer flux

! Logical switches (TRUE/FALSE) to activate writing of fields into
! HISTORY output file.

Hout(idUvel) == T                          ! 3D U-velocity
Hout(idVvel) == T                          ! 3D V-velocity
Hout(idu3dE) == F       ! u_eastward         3D U-eastward  at RHO-points
Hout(idv3dN) == F       ! v_northward        3D V-northward at RHO-points
Hout(idWvel) == T                          ! 3D W-velocity
Hout(idOvel) == F                          ! omega vertical velocity
Hout(idUbar) == T                          ! 2D U-velocity
Hout(idVbar) == T                          ! 2D V-velocity
Hout(idu2dE) == F       ! ubar_eastward      2D U-eastward  at RHO-points
Hout(idv2dN) == F       ! vbar_northward     2D V-northward at RHO-points
Hout(idFsur) == T                          ! free-surface
Hout(idBath) == F                          ! time-dependent bathymetry

Hout(idTvar) == T T                        ! temperature and salinity

Hout(idUsms) == T                          ! surface U-stress
Hout(idVsms) == T                          ! surface V-stress
Hout(idUbms) == T                          ! bottom U-stress
Hout(idVbms) == T                          ! bottom V-stress

Hout(idUbrs) == F                          ! bottom U-current stress
Hout(idVbrs) == F                          ! bottom V-current stress
Hout(idUbws) == F                          ! bottom U-wave stress
Hout(idVbws) == F                          ! bottom V-wave stress
Hout(idUbcs) == F                          ! bottom max wave-current U-stress
Hout(idVbcs) == F                          ! bottom max wave-current V-stress

Hout(idUbot) == F                          ! bed wave orbital U-velocity
Hout(idVbot) == F                          ! bed wave orbital V-velocity
Hout(idUbur) == F                          ! bottom U-velocity above bed
Hout(idVbvr) == F                          ! bottom V-velocity above bed

Hout(idW2xx) == F                          ! 2D radiation stress, Sxx component
Hout(idW2xy) == F                          ! 2D radiation stress, Sxy component
Hout(idW2yy) == F                          ! 2D radiation stress, Syy component
Hout(idU2rs) == F                          ! 2D radiation U-stress
Hout(idV2rs) == F                          ! 2D radiation V-stress
Hout(idU2Sd) == F                          ! 2D U-Stokes velocity
Hout(idV2Sd) == F                          ! 2D V-Stokes velocity

Hout(idW3xx) == F                          ! 3D radiation stress, Sxx component
Hout(idW3xy) == F                          ! 3D radiation stress, Sxy component
Hout(idW3yy) == F                          ! 3D radiation stress, Syy component
Hout(idW3zx) == F                          ! 3D radiation stress, Szx component
Hout(idW3zy) == F                          ! 3D radiation stress, Szy component
Hout(idU3rs) == F                          ! 3D U-radiation stress
Hout(idV3rs) == F                          ! 3D V-radiation stress
Hout(idU3Sd) == F                          ! 3D U-Stokes velocity
Hout(idV3Sd) == F                          ! 3D V-Stokes velocity

Hout(idWamp) == F                          ! wave height
Hout(idWlen) == F                          ! wave length
Hout(idWdir) == F                          ! wave direction
Hout(idWptp) == F       ! Pwave_top          wave surface period
Hout(idWpbt) == F       ! Pwave_bot          wave bottom period
Hout(idWorb) == F       ! Ub_swan            wave bottom orbital velocity
Hout(idWdis) == F       ! Wave_dissip        wave dissipation

Hout(idPair) == T       ! Pair               surface air pressure
Hout(idUair) == T       ! Uair               surface U-wind component
Hout(idVair) == T       ! Vair               surface V-wind component

Hout(idTsur) == T F                        ! surface net heat and salt flux
Hout(idLhea) == T                          ! latent heat flux
Hout(idShea) == T                          ! sensible heat flux
Hout(idLrad) == T                          ! longwave radiation flux
Hout(idSrad) == T                          ! shortwave radiation flux
Hout(idEmPf) == T       ! EminusP            E-P flux
Hout(idevap) == F                          ! evaporation rate
Hout(idrain) == F                          ! precipitation rate

Hout(idDano) == T                          ! density anomaly
Hout(idVvis) == T                          ! vertical viscosity
Hout(idTdif) == T                          ! vertical T-diffusion
Hout(idSdif) == T                          ! vertical Salinity diffusion
Hout(idHsbl) == F                          ! depth of surface boundary layer
Hout(idHbbl) == F                          ! depth of bottom boundary layer
Hout(idMtke) == T                          ! turbulent kinetic energy
Hout(idMtls) == T                          ! turbulent length scale

! Logical switches (TRUE/FALSE) to activate writing of extra inert passive
! tracers other than biological and sediment tracers. An inert passive tracer
! is one that it is only advected and diffused. Other processes are ignored.
! These tracers include, for example, dyes, pollutants, oil spills, etc.
! NPT values are expected. However, these switches can be activated using
! compact parameter specification.

 Hout(inert) == F                          ! inert passive tracers

! Logical switches (TRUE/FALSE) to activate writing of exposed sediment
! layer properties into HISTORY output file.  Currently, MBOTP properties
! are expected for the bottom boundary layer and/or sediment models:
!
!   Hout(idBott(isd50)),  isd50 = 1        ! mean grain diameter
!   Hout(idBott(idens)),  idens = 2        ! mean grain density
!   Hout(idBott(iwsed)),  iwsed = 3        ! mean settling velocity
!   Hout(idBott(itauc)),  itauc = 4        ! critical erosion stress
!   Hout(idBott(irlen)),  irlen = 5        ! ripple length
!   Hout(idBott(irhgt)),  irhgt = 6        ! ripple height
!   Hout(idBott(ibwav)),  ibwav = 7        ! wave excursion amplitude
!   Hout(idBott(izdef)),  izdef = 8        ! default bottom roughness
!   Hout(idBott(izapp)),  izapp = 9        ! apparent bottom roughness
!   Hout(idBott(izNik)),  izNik = 10       ! Nikuradse bottom roughness
!   Hout(idBott(izbio)),  izbio = 11       ! biological bottom roughness
!   Hout(idBott(izbfm)),  izbfm = 12       ! bed form bottom roughness
!   Hout(idBott(izbld)),  izbld = 13       ! bed load bottom roughness
!   Hout(idBott(izwbl)),  izwbl = 14       ! wave bottom roughness
!   Hout(idBott(iactv)),  iactv = 15       ! active layer thickness
!   Hout(idBott(ishgt)),  ishgt = 16       ! saltation height
!
!                                 1 1 1 1 1 1 1
!               1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6

Hout(idBott) == T T T T T T T T T F F F F F F F

! Logical switches (TRUE/FALSE) to activate writing of time-averaged
! fields into AVERAGE output file.

Aout(idUvel) == T       ! u                  3D U-velocity
Aout(idVvel) == T       ! v                  3D V-velocity
Aout(idu3dE) == F       ! u_eastward         3D U-eastward  at RHO-points
Aout(idv3dN) == F       ! v_northward        3D V-northward at RHO-points
Aout(idWvel) == T       ! w                  3D W-velocity
Aout(idOvel) == F       ! omega              omega vertical velocity
Aout(idUbar) == T       ! ubar               2D U-velocity
Aout(idVbar) == T       ! vbar               2D V-velocity
Aout(idu2dE) == F       ! ubar_eastward      2D U-eastward  at RHO-points
Aout(idv2dN) == F       ! vbar_northward     2D V-northward at RHO-points
Aout(idFsur) == T       ! zeta               free-surface

Aout(idTvar) == T T     ! temp, salt         temperature and salinity

Aout(idUsms) == T       ! sustr              surface U-stress
Aout(idVsms) == T       ! svstr              surface V-stress
Aout(idUbms) == F       ! bustr              bottom U-stress
Aout(idVbms) == F       ! bvstr              bottom V-stress

Aout(idW2xx) == F       ! Sxx_bar            2D radiation stress, Sxx component
Aout(idW2xy) == F       ! Sxy_bar            2D radiation stress, Sxy component
Aout(idW2yy) == F       ! Syy_bar            2D radiation stress, Syy component
Aout(idU2rs) == F       ! Ubar_Rstress       2D radiation U-stress
Aout(idV2rs) == F       ! Vbar_Rstress       2D radiation V-stress
Aout(idU2Sd) == F       ! ubar_stokes        2D U-Stokes velocity
Aout(idV2Sd) == F       ! vbar_stokes        2D V-Stokes velocity

Aout(idW3xx) == F       ! Sxx                3D radiation stress, Sxx component
Aout(idW3xy) == F       ! Sxy                3D radiation stress, Sxy component
Aout(idW3yy) == F       ! Syy                3D radiation stress, Syy component
Aout(idW3zx) == F       ! Szx                3D radiation stress, Szx component
Aout(idW3zy) == F       ! Szy                3D radiation stress, Szy component
Aout(idU3rs) == F       ! u_Rstress          3D U-radiation stress
Aout(idV3rs) == F       ! v_Rstress          3D V-radiation stress
Aout(idU3Sd) == F       ! u_stokes           3D U-Stokes velocity
Aout(idV3Sd) == F       ! v_stokes           3D V-Stokes velocity

Aout(idPair) == T       ! Pair               surface air pressure
Aout(idPair) == T       ! Tair               surface air temperature
Aout(idUair) == T       ! Uair               surface U-wind component
Aout(idVair) == T       ! Vair               surface V-wind component

Aout(idTsur) == T F     ! shflux, ssflux     surface net heat and salt flux
Aout(idLhea) == T       ! latent             latent heat flux
Aout(idShea) == T       ! sensible           sensible heat flux
Aout(idLrad) == T       ! lwrad              longwave radiation flux
Aout(idSrad) == T       ! swrad              shortwave radiation flux
Aout(idevap) == F       ! evaporation        evaporation rate
Aout(idrain) == F       ! rain               precipitation rate
Aout(idEmPf) == T       ! EminusP            E-P flux

Aout(idDano) == T       ! rho                density anomaly
Aout(idVvis) == T       ! AKv                vertical viscosity
Aout(idTdif) == T       ! AKt                vertical T-diffusion
Aout(idSdif) == T       ! AKs                vertical Salinity diffusion
Aout(idHsbl) == F       ! Hsbl               depth of surface boundary layer
Aout(idHbbl) == F       ! Hbbl               depth of bottom boundary layer

Aout(id2dRV) == T       ! pvorticity_bar     2D relative vorticity
Aout(id3dRV) == F       ! pvorticity         3D relative vorticity
Aout(id2dPV) == T       ! rvorticity_bar     2D potential vorticity
Aout(id3dPV) == F       ! rvorticity         3D potential vorticity

Aout(idu3dD) == F       ! u_detided          detided 3D U-velocity
Aout(idv3dD) == F       ! v_detided          detided 3D V-velocity
Aout(idu2dD) == T       ! ubar_detided       detided 2D U-velocity
Aout(idv2dD) == T       ! vbar_detided       detided 2D V-velocity
Aout(idFsuD) == T       ! zeta_detided       detided free-surface

Aout(idTrcD) == T T     ! temp_detided, ...  detided temperature and salinity

Aout(idHUav) == F       ! Huon               u-volume flux, Huon
Aout(idHVav) == F       ! Hvom               v-volume flux, Hvom
Aout(idUUav) == F       ! uu                 quadratic <u*u> term
Aout(idUVav) == F       ! uv                 quadratic <u*v> term
Aout(idVVav) == F       ! vv                 quadratic <v*v> term
Aout(idU2av) == F       ! ubar2              quadratic <ubar*ubar> term
Aout(idV2av) == F       ! vbar2              quadratic <vbar*vbar> term
Aout(idZZav) == F       ! zeta2              quadratic <zeta*zeta> term

Aout(idTTav) == F F     ! temp2, ...         quadratic <t*t> tracer terms
Aout(idUTav) == F F     ! utemp, ...         quadratic <u*t> tracer terms
Aout(idVTav) == F F     ! vtemp, ...         quadratic <v*t> tracer terms
Aout(iHUTav) == F F     ! Huontemp, ...      tracer volume flux, <Huon*t>
Aout(iHVTav) == F F     ! Hvomtemp, ...      tracer volume flux, <Hvom*t>

! Logical switches (TRUE/FALSE) to activate writing of extra inert passive
! tracers other than biological and sediment tracers into the AVERAGE file.

 Aout(inert) == F       ! dye_01, ...        inert passive tracers

! Logical switches (TRUE/FALSE) to activate writing of time-averaged,
! 2D momentum (ubar,vbar) diagnostic terms into DIAGNOSTIC output file.

Dout(M2rate) == T       ! ubar_accel, ...    acceleration
Dout(M2pgrd) == T       ! ubar_prsgrd, ...   pressure gradient
Dout(M2fcor) == T       ! ubar_cor, ...      Coriolis force
Dout(M2hadv) == T       ! ubar_hadv, ...     horizontal total advection
Dout(M2xadv) == T       ! ubar_xadv, ...     horizontal XI-advection
Dout(M2yadv) == T       ! ubar_yadv, ...     horizontal ETA-advection
Dout(M2hrad) == T       ! ubar_hrad, ...     horizontal total radiation stress
Dout(M2hvis) == T       ! ubar_hvisc, ...    horizontal total viscosity
Dout(M2xvis) == T       ! ubar_xvisc, ...    horizontal XI-viscosity
Dout(M2yvis) == T       ! ubar_yvisc, ...    horizontal ETA-viscosity
Dout(M2sstr) == T       ! ubar_sstr, ...     surface stress
Dout(M2bstr) == T       ! ubar_bstr, ...     bottom stress

! Logical switches (TRUE/FALSE) to activate writing of time-averaged,
! 3D momentum (u,v) diagnostic terms into DIAGNOSTIC output file.

Dout(M3rate) == T       ! u_accel, ...       acceleration
Dout(M3pgrd) == T       ! u_prsgrd, ...      pressure gradient
Dout(M3fcor) == T       ! u_cor, ...         Coriolis force
Dout(M3hadv) == T       ! u_hadv, ...        horizontal total advection
Dout(M3xadv) == T       ! u_xadv, ...        horizontal XI-advection
Dout(M3yadv) == T       ! u_yadv, ...        horizontal ETA-advection
Dout(M3vadv) == T       ! u_vadv, ...        vertical advection
Dout(M3hrad) == F       ! u_hrad, ...        horizontal total radiation stress
Dout(M3vrad) == F       ! u_vrad, ...        vertical radiation stress
Dout(M3hvis) == F       ! u_hvisc, ...       horizontal total viscosity
Dout(M3xvis) == F       ! u_xvisc, ...       horizontal XI-viscosity
Dout(M3yvis) == F       ! u_yvisc, ...       horizontal ETA-viscosity
Dout(M3vvis) == F       ! u_vvisc, ...       vertical viscosity

! Logical switches (TRUE/FALSE) to activate writing of time-averaged,
! active (temperature and salinity) and passive (inert) tracer diagnostic
! terms into DIAGNOSTIC output file: [1:NAT+NPT,Ngrids].

Dout(iTrate) == F F     ! temp_rate, ...     time rate of change
Dout(iThadv) == F F     ! temp_hadv, ...     horizontal total advection
Dout(iTxadv) == F F     ! temp_xadv, ...     horizontal XI-advection
Dout(iTyadv) == F F     ! temp_yadv, ...     horizontal ETA-advection
Dout(iThdif) == F F     ! temp_hdiff, ...    horizontal total diffusion
Dout(iTxdif) == F F     ! temp_xdiff, ...    horizontal XI-diffusion
Dout(iTydif) == F F     ! temp_ydiff, ...    horizontal ETA-diffusion
Dout(iTsdif) == F F     ! temp_sdiff, ...    horizontal S-diffusion
Dout(iTvdif) == F F     ! temp_vdiff, ...    vertical diffusion

! Generic User parameters, [1:NUSER].

       NUSER =  0
        USER =  0.d0

! NetCDF-4/HDF5 compression parameters for output files.

  NC_SHUFFLE =  1                 ! if non-zero, turn on shuffle filter
  NC_DEFLATE =  1                 ! if non-zero, turn on deflate filter
   NC_DLEVEL =  1                 ! deflate level [0-9]

! Input NetCDF file names, [1:Ngrids].

     GRDNAME == ${inputdir}/${testname}_grid.nc
     ININAME == ${inputdir}/${testname}_ini.nc
     ITLNAME == ocean_itl.nc
     IRPNAME == ocean_irp.nc
     IADNAME == ocean_iad.nc
     FWDNAME == ocean_fwd.nc
     ADSNAME == ocean_ads.nc
     SSFNAME == ${inputdir}/${testname}_river.nc
     BRYNAME == ${inputdir}/${testname}_bndy.nc

! Input forcing NetCDF file name(s).  The USER has the option to enter
! several file names for each nested grid.  For example, the USER may
! have different files for wind products, heat fluxes, rivers, tides,
! etc.  The model will scan the file list and will read the needed data
! from the first file in the list containing the forcing field. Therefore,
! the order of the file names is very important. If using multiple forcing
! files per grid, first enter all the file names for grid 1, then grid 2,
! and so on.  Use a single line per entry with a continuation (\) symbol
! at the each entry, except the last one.

     NFFILES == 7                          ! number of forcing files

     FRCNAME == ${inputdir}/${testname}_tides.nc  \\
                ${inputdir}/${testname}_Uwind.nc  \\
                ${inputdir}/${testname}_Vwind.nc  \\
                ${inputdir}/${testname}_Tair.nc   \\ 
                ${inputdir}/${testname}_Pair.nc   \\ 
                ${inputdir}/${testname}_Qair.nc   \\ 
                ${inputdir}/${testname}_swrad.nc

! Output NetCDF file names, [1:Ngrids].

     GSTNAME == ocean_gst.nc
     RSTNAME == ${datadir}/${testname}_rst_${fulldate}.nc
     HISNAME == ${datadir}/${testname}_his.nc
     TLMNAME == ocean_tlm.nc
     TLFNAME == ocean_tlf.nc
     ADJNAME == ocean_adj.nc
     AVGNAME == ${datadir}/${testname}_avg.nc
     DIANAME == ocean_dia.nc
     STANAME == ${datadir}/${testname}_sta.nc
     FLTNAME == ${datadir}/${testname}_flt.nc

! Input ASCII parameter filenames.

     APARNAM =  ./s4dvar.in
     SPOSNAM =  ${workdir}/${testname}_stations.in
     FPOSNAM =  ${workdir}/${testname}_floats.in
     BPARNAM =  ./bioFasham.in
     SPARNAM =  ./sediment.in
     USRNAME =  ./MyFile.dat

EOF

ln -sf ${datadir}/${ctrlfile} $MAMS/Model/ROMS/01_NWP_1_10/auto01.in








