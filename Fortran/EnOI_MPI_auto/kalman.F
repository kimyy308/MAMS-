!
! Common blocks for Kalman filter program
!
! dimensions of model state vector
! Modified by Y-Y. Kim in JUNE., 2019

    module kalman
     implicit none
     save
      type domain
        integer :: west, east, south, north, eastu, northv, eastp, northp
        integer :: Nsta, ndomain 
        real(kind=8),allocatable,dimension(:,:) :: old_ens
        integer,allocatable,dimension(:,:) :: index_back
      end type domain
      ! /* added by Y-Y. Kim
      TYPE T_IO
        character (len=256) :: grdname ! grid file name
        character (len=256) :: enspath !ensemble file path
        character (len=256) :: obsname !observation file name
        character (len=256) :: inname !ncfile before DA
        character (len=256) :: inname_piece_path !seperated ncfile before DA
        character (len=256) :: outname !ncfile after DA
        character (len=256) :: logname !ncfile after DA
        integer :: Nens ! # of ensembles
        integer :: ss_dim ! same with # of ensembles
        integer :: dxdomain ! partial xlength
        integer :: dydomain ! partial ylength
        real(kind=8) :: cinf, cinf2 ! DA radius
        real(kind=8) :: hinf, hinf2 ! DA vertical length
        real(kind=8) :: eps ! epsilon for checking error in matrix inversion
        real(kind=8) :: alpha ! weighting factor
      END TYPE T_IO
      ! */

      real(kind=8), parameter :: KLM_TLRNC=1.e-4

!      integer, parameter :: Nens = 35, ss_dim=Nens , sch_ens = 0
      integer, parameter :: sch_ens = 0

      integer            :: istep,stdout
      integer            :: Imean=1, Irms=2, Indq1=1
      integer            :: Delta_ass, ass_start, delta_lin

      integer :: nceofid, vareofid(5),varrefid(5),exit_flag,ncrefid,&
             nceofid2,vareofid2(5),nceofid3,vareofid3(5),ncrefid2,&
             varrefid2(5)
      !! cinf --> DA radius
!      real(kind=8),parameter    :: cinf=35000.0d0,hinf=100.0d0
      real(kind=8), allocatable, dimension(:,:) :: old_ens
      real(kind=8), allocatable, dimension(:) :: stmean,stgref,strms
             
      character(80) ::  eofname,refname,refname2
      character(45) ::  vname_kalm(5,3)
      character(45) ::  vname_ref(5)
  
      integer       :: cwrank, cwsize
      integer       :: num_domain, num_idomain,idomain
      type(domain),dimension(:),allocatable :: pdomain
    end module kalman

