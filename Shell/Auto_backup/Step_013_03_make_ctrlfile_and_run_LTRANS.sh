#!/bin/sh

#arithmetic operation example
#abc = `echo 3 + 3 * 1|bc`      # get 7
#abcd = `printf "%04d" ${abc}`   # get 0007

testname=auto01
#fulldate=`date --date="3 days ago" +%Y%m%d`
#fulldate=`date -d "$1 0 day" +%Y%m%d`
MAMS=$2
workdir=$MAMS/Model/LTRANS
inputdir=$workdir/Input
dayinfofile=$inputdir/dayinfo
fulldate=`head -1 $dayinfofile`
numday=`tail -1 $dayinfofile`
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`
yearday=`date -d "$fulldate" +%j`
yearday_4=`printf "%04d" ${yearday}`

outputdir=$workdir/Output/$year/$month/$fulldate
datadir=/home/auto/ext_hdi/nwp_1_10/reanalysis
ctrlfile=$outputdir/ltrans_ctrl_${fulldate}.data
locfile=$outputdir/ltrans_loc_${fulldate}.txt

numline=`wc -l < $locfile`
numday_ltrans=`echo $numday |bc`
hoursec=3600
daysec=86400
deadage=`expr $daysec \* 365`
cd $workdir

cat > $ctrlfile << EOF
! ******************************* LTRANS Input Data File  *******************************

!----  This is the file that contains input values for LTRANS with parameters grouped ---
!----  (Previously LTRANS.inc)


!*** NUMBER OF PARTICLES ***
\$numparticles

  numpar = $numline              ! Number of particles (total number for whole simulation)
                             ! numpar should equal the number of rows in the particle 
                             ! locations input file
\$end



!*** TIME PARAMETERS ***
\$timeparam

  
  days   = $numday_ltrans               ! Number of days to run the model
  iprint = $hoursec              ! Print interval for LTRANS output (s); 3600 = every hour
  dt     = $daysec              ! External time step (duration between hydro model predictions) (s) 
  idt    = $hoursec               ! Internal (particle tracking) time step (s)

\$end



!*** ROMS HYDRODYNAMIC MODULE PARAMETERS ***
\$hydroparam

  us         = 40            ! Number of Rho grid s-levels in ROMS hydro model
  ws         = 41            ! Number of W grid s-levels in ROMS hydro model
  tdim       = 1            ! Number of time steps per ROMS hydro predictions file
  hc         = 250.0           ! Min Depth - used in ROMS S-level transformations
  z0         = 0.001        ! ROMS bottom roughness parameter (Zob)
  Vtransform = 2             ! 1-WikiRoms Eq. 1, 2-WikiRoms Eq. 2, 3-Song/Haidvogel 1994 Eq.
                             !
  readZeta   = .TRUE.        ! If .TRUE. read in sea-surface height   (zeta) from NetCDF file, else use constZeta
  constZeta  = 0.0           ! Constant value for Zeta if readZeta is .FALSE.
  readSalt   = .TRUE.        ! If .TRUE. read in salinity             (salt) from NetCDF file, else use constSalt
  constSalt  = 0.0           ! Constant value for Salt if readSalt is .FALSE.
  readTemp   = .TRUE.        ! If .TRUE. read in temperature          (temp) from NetCDF file, else use constTemp
  constTemp  = 0.0           ! Constant value for Temp if readTemp is .FALSE.
  readU      = .TRUE.        ! If .TRUE. read in u-momentum component (U   ) from NetCDF file, else use constU
  constU     = 0.0           ! Constant value for U if readU is .FALSE.
  readV      = .TRUE.        ! If .TRUE. read in v-momentum component (V   ) from NetCDF file, else use constV
  constV     = 0.0           ! Constant value for V if readV is .FALSE.
  readW      = .FALSE.        ! If .TRUE. read in w-momentum component (W   ) from NetCDF file, else use constW
  constW     = 0.0           ! Constant value for W if readW is .FALSE.
  readAks    = .FALSE.        ! If .TRUE. read in salinity vertical diffusion coefficient (Aks ) from NetCDF file, else 
                             ! use constAks
  constAks   = 0.0           ! Constant value for Aks if readAks is .FALSE.
  readDens   = .FALSE.
  constDens  = 0.0 


\$end



!*** TURBULENCE MODULE PARAMETERS ***
\$turbparam

  HTurbOn       = .FALSE.     ! Horizontal Turbulence on (.TRUE.) or off (.FALSE.)
  VTurbOn       = .FALSE.     ! Vertical   Turbulence on (.TRUE.) or off (.FALSE.)
  ConstantHTurb = 1.0        ! Constant value of horizontal turbulence (m2/s)

\$end



!*** BEHAVIOR MODULE PARAMETERS ***
\$behavparam

  Behavior = 0               ! Behavior type (specify a number)
                             !   Note: The behavior types numbers are: 
                             !     0 Passive, 1 near-surface, 2 near-bottom, 3 DVM, 
                             !     4 C.virginica oyster larvae, 5 C.ariakensis oyster larvae, 
                             !     6 constant, 7 Tidal Stream Transport
  OpenOceanBoundary = .TRUE. ! Note: If you want to allow particles to "escape" via open ocean 
                             !   boundaries, set this to TRUE; Escape means that the particle 
                             !   will stick to the boundary and stop moving
  mortality = .TRUE.         ! TRUE if particles can die; else FALSE
  deadage = $deadage           ! Age at which a particle stops moving (i.e., dies) (s)
                             !   Note: deadage stops particle motion for all behavior types
  pediage = $deadage           ! Age when particle reaches max swim speed and can settle (s)
  	                        ! Note: for oyster larvae behavior types (4 & 5), 
                             !     pediage = age at which a particle becomes a pediveliger
                             !   Note: pediage does not cause particles to settle if 
                             !     the Settlement module is not on
  swimstart = 0.0            ! Age that swimming or sinking begins (s) 1 day = 1.*24.*3600.
  swimslow  = 0.005          ! Swimming speed when particle begins to swim (m/s)
  swimfast  = 0.005          ! Maximum swimming speed (m/s)  0.05 m/s for 5 mm/s
                             !   Note: for constant swimming speed for behavior types 1,2 & 3, 
                             !     set swimslow = swimfast = constant speed
  Sgradient = 1.0            ! Salinity gradient threshold that cues larval behavior (psu/m)
                             !   Note: This parameter is only used if Behavior = 4 or 5. 
  sink      = 0.0        ! Sinking velocity for behavior type 6
                             !   Note: This parameter is only used if Behavior = 6.

! Tidal Stream Transport behavior type:
  Hswimspeed = 0.0           ! Horizontal swimming speed (m/s)
  Swimdepth  = 0             ! Depth at which fish swims during flood time 
                             ! in meters above bottom (this should be a positive value
                             ! Note: this formulation may need some work

\$end



!*** DVM. The following are parameters for the Diurnal Vertical Migration (DVM) behavior type ***
!  Note: These values were calculated for September 1 at the latitude of 37.0 (Chesapeake Bay mouth)
!  Note: Variables marked with ** were calculated with light_v2BlueCrab.f (not included in LTRANS yet)
!  Note: These parameters are only used if Behavior = 3 
\$dvmparam

  twistart  = 4.801821       ! Time of twilight start (hr) **
  twiend    = 19.19956       ! Time of twilight end (hr) **
  daylength = 14.39774       ! Length of day (hr) **
  Em        = 1814.328       ! Irradiance at solar noon (microE m^-2 s^-1) **
  Kd        = 1.07           ! Vertical attenuation coefficient
  thresh    = 0.0166         ! Light threshold that cues behavior (microE m^-2 s^-1)

\$end



!*** SETTLEMENT MODULE PARAMETERS ***
\$settleparam

 settlementon = .TRUE.      ! settlement module on (.TRUE.) or off (.FALSE.)
                             ! Note: If settlement is off: set minholeid, maxholeid, minpolyid,
                             !   maxpolyid, pedges, & hedges to 1 
                             !   to avoid both wasted variable space and errors due to arrays of size 0.
                             ! If settlement is on and there are no holes: set minholeid,
                             !   maxholeid, and hedges to 1
 holesExist = .FALSE.         ! Are there holes in habitat? yes(TRUE) no(FALSE)
 minpolyid  = 101001         ! Lowest habitat polygon id number
 maxpolyid  = 101001         ! Highest habitat polygon id number
 minholeid  = 100201         ! Lowest hole id number
 maxholeid  = 100401         ! Highest hole id number
 pedges     = 4             ! Number of habitat polygon edge points (# of rows in habitat polygon file)
 hedges     = 32             ! Number of hole edge points (number of rows in holes file)

\$end



!*** CONVERSION MODULE PARAMETERS ***
\$convparam

  PI = 3.14159265358979      ! Pi
  Earth_Radius = 6378000     ! Equatorial radius of Earth (m)
  SphericalProjection = .FALSE.  ! Spherical Projection from ROMS if TRUE. If FALSE, mercator projection is used. 
  latmin = 15                ! Minimum longitude value, only used if SphericalProjection is .TRUE.
  lonmin = -77              ! Minimum  latitude value, only used if SphericalProjection is .TRUE.
\$end



!*** INPUT FILE NAME AND LOCATION PARAMETERS ***; 
! ** ROMS NetCDF Model Grid file **
  !Note: the path to the file is necessary if the file is not in the same folder as the code
  !Note: if .nc file in separate folder in Linux, then include path. For example:
  !      NCgridfile = '/share/enorth/CPB_GRID_wUV.nc' 
  !Note: if .nc file in separate folder in Windows, then include path. For example:
  !      NCgridfile = 'D:\ROMS\CPB_GRID_wUV.nc'
\$romsgrid
  !!NCgridfile='/data2/kimyy/ext_hdd2/roms_grid02_2.nc'
  !!NCgridfile='/data2/kimyy/ext_hdd2/roms_grid_final.nc'
  NCgridfile='$inputdir/input_0001.nc'

\$end


! ** ROMS Predictions NetCDF Input (History) File **
  !Filename = prefix + filenum + suffix
  !Note: the path to the file is necessary if the file is not in the same folder as the code
  !Note: if .nc file in separate folder in Windows, then include path in prefix. For example:
  !      prefix='D:\ROMS\y95hdr_'   
  !      if .nc file in separate folder in Linux, then include path in prefix. For example:
  !      prefix='/share/lzhong/1995/y95hdr_'   
\$romsoutput
  prefix='$inputdir/input_'   ! NetCDF Input Filename prefix                     
  suffix='.nc'               ! NetCDF Input Filename suffix
  filenum = 1      ! Number in first NetCDF input filename
  numdigits = 4              ! Number of digits in number portion of file name (with leading zeros)
  startfile = .TRUE.         ! Is it the first file, i.e. does the file have an additional time step?
\$end


! ** Particle Location Input File **
  !Note: the path to the file is necessary if the file is not in the same folder as the code
\$parloc

  parfile  = '$inputdir/loc.txt'    !Particle locations 

\$end


! ** Habitat Polygon Location Input Files **
!Note: the path to the file is necessary if the file is not in the same folder as the code
\$habpolyloc

  habitatfile = '$inputdir/pollack_polygons.csv'  !Habitat polygons
  holefile    = '$inputdir/End_holes.csv'     !Holes in habitat polygons

\$end


! ** Output Related Variables **
\$output

  !NOTE: Full path must already exist.  Model can create files, but not directories.
  outpath = '${outputdir}/'      ! Location to write output .csv and/or .nc files  
                             ! Use outpath = './' to write in same folder as the executable
  NCOutFile = 'ltrans_output_${fulldate}'       ! Name of the NetCDF output files (do not include .nc)
  outpathGiven = .TRUE.      ! If TRUE files are written to the path given in outpath
  writeCSV     = .FALSE.      ! If TRUE write CSV output files
  writeNC      = .TRUE.     ! If TRUE write .NC output files
  NCtime       = 0           ! Time interval between creation of new NetCDF output files (seconds)
                             ! Note: setting this to 0 will result in just one large output file

  !NetCDF Model Metadata (these will be stale unless you edit them):
!  SVN_Version  = \'https:\/\/cmgsoft.repositoryhosting.com\/svn\/cmgsoft_ltrans\/trunk\'
!  RunName      = \'LTRANS v\.2 Walleye pollack test case\'
!  ExeDir       = \'.\'
!  OutDir       = \'.\/output\'
!  RunBy        = \'Yong-Yub Kim\'
!  Institution  = \'Seoul National University\'
!  StartedOn    = \'$today\'
\$end



!*** OTHER PARAMETERS *** 
\$other

  seed         = 9           ! Seed value for random number generator (Mersenne Twister)
  ErrorFlag    = 1           ! What to do if an error is encountered: 0=stop, 1=return particle to previous location,
                             ! 2=kill particle & stop tracking that particle, 3=set particle out of bounds & 
                             ! stop tracking that particle
                             ! Note: Options 1-3 will output information to ErrorLog.txt
                             ! Note: This is only for particles that travel out of bounds illegally
  BoundaryBLNs = .TRUE.      ! Create Surfer Blanking Files of boundaries? .TRUE.=yes, .FALSE.=no
  SaltTempOn   = .TRUE.     ! Calculate salinity and temperature at particle 
        	                  ! location: yes (.TRUE.) or no (.FALSE.)
  TrackCollisions  = .TRUE. ! Write Bottom and Land Hit Files? .TRUE.=yes, .FALSE.=no
  WriteHeaders     = .TRUE.  ! Write .txt files with column headers? .TRUE.=yes, .FALSE.=no
  WriteModelTiming = .TRUE.  ! Write .csv file with model timing data? .TRUE.=yes, .FALSE.=no

  ijbuff = 4                 ! number of extra elements to read in on every side of the particles

  FreeSlip = .FALSE.         ! enable the use of the free slip condition

\$end

EOF


ln -sf $ctrlfile $workdir/LTRANS.data
cd $workdir
./LTRANS.exe > $outputdir/ltrans_log_${fulldate}".log"
