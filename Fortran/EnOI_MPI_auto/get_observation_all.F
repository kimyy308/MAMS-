!======================================================
! module observation
! Programmed by Y.H. KIM in Apri., 2006
! Note : To prepare the Ensemble Kalman Filter
! Edit : GHSEO in CNU // seogwangho@gmail.com
!        bjchoi 2013 October
!======================================================

 module observation
 use kalman, only : pdomain, cwrank,stdout, T_IO
 use background, only : lon_rho, lat_rho
 
 implicit none
 save
 integer :: Nobs, Nloc
 real(8),allocatable,dimension(:) :: lon_obs,lat_obs,depth_obs,obsdata,obserr
 integer,allocatable,dimension(:) :: ind_obs,rndidx,ind_idx
 real(8),allocatable,dimension(:,:) :: ornds
 
 contains
 
 subroutine get_observation(loop,param_all)
 use kalman
 use netcdf

 implicit none

 character(10)      :: var_name
 character(100)      :: infile
 character(80)      :: inpath
 character(10)      :: cidx,bidx

 integer, intent(in) :: loop
 integer            :: i,k
 integer            :: ncgin, status
 integer            :: dim_xi_rho
 integer            :: len_x
 integer            :: varid_obsdata,varid_ind,varid_ndata
 integer            :: varid_rlon, varid_rlat, varid_rdepth, varid_obserr
 integer,allocatable,dimension(:) :: len_xx
 real(kind=8)       :: clon,clat,cx,cy,ang
 real(8),allocatable,dimension(:) :: lon_tmp,lat_tmp,depth_tmp,obs_tmp,idx_tmp,obserr_tmp
 real(kind=8)       :: x1,x2,x3,x4,y1,y2,y3,y4,s1,s2,s3,s4,rline1,rline2,rline3,rline4  ! added by bjchoi
 TYPE(T_IO), intent(inout) :: param_all ! added by Y-Y. Kim


 allocate(len_xx(1))

 !infile = 'observation.nc'
! write(cidx,'(i5.5)') tindex
!inpath = './observation/'
! inpath = '/HDD1/kimyy/OISST/nwp_1_10_obs_'
!infile = inpath//'all_obs_'//trim(cidx)//'.nc'
! infile = trim(trim(inpath)//trim(cidx)//'.nc')
infile = trim(param_all%obsname)
 write(stdout,*) infile
 print *, infile
 !ttindex=tindex/tindex
 
 status = NF90_OPEN(infile,NF90_NOWRITE,ncgin)
 if(status/=nf90_noerr) call handle_err(status) 

 !status = NF90_INQ_DIMID(ncgin,"rlon",dim_xi_rho)
 !status = NF90_INQUIRE_DIMENSION(ncgin,dim_xi_rho,var_name,len_x)

 status = NF90_INQ_VARID(ncgin,"ndata",varid_ndata)
 
 status = NF90_INQ_VARID(ncgin,"rlon",varid_rlon)
 status = NF90_INQ_VARID(ncgin,"rlat",varid_rlat)
 status = NF90_INQ_VARID(ncgin,"rdepth",varid_rdepth)
 status = NF90_INQ_VARID(ncgin,"obsdata",varid_obsdata)
 status = NF90_INQ_VARID(ncgin,"obserr",varid_obserr)
 status = NF90_INQ_VARID(ncgin,"dindex",varid_ind)

 !status = NF90_GET_VAR(ncgin,varid_ndata,len_xx,start=(/ttindex/),count=(/1/))
 status = NF90_GET_VAR(ncgin,varid_ndata,len_xx,start=(/1/),count=(/1/))

 len_x = len_xx(1)

 !write(6,*) 'Number of Observation (',cwrank,') : ', len_x
 
 allocate(lon_tmp(len_x),lat_tmp(len_x),depth_tmp(len_x),obs_tmp(len_x),obserr_tmp(len_x),idx_tmp(len_x))
 ! 2D
 !status = NF90_GET_VAR(ncgin,varid_rlon,lon_tmp,start=(/1,ttindex/),count=(/len_x,1/))
 !status = NF90_GET_VAR(ncgin,varid_rlat,lat_tmp,start=(/1,ttindex/),count=(/len_x,1/))
 !status = NF90_GET_VAR(ncgin,varid_rdepth,depth_tmp,start=(/1,ttindex/),count=(/len_x,1/))
 !status = NF90_GET_VAR(ncgin,varid_obsdata,obs_tmp,start=(/1,ttindex/),count=(/len_x,1/))
 !status = NF90_GET_VAR(ncgin,varid_ind,idx_tmp,start=(/1,ttindex/),count=(/len_x,1/))

 ! 1D
 status = NF90_GET_VAR(ncgin,varid_rlon,lon_tmp,start=(/1/),count=(/len_x/))
 status = NF90_GET_VAR(ncgin,varid_rlat,lat_tmp,start=(/1/),count=(/len_x/))
 status = NF90_GET_VAR(ncgin,varid_rdepth,depth_tmp,start=(/1/),count=(/len_x/))
 status = NF90_GET_VAR(ncgin,varid_obsdata,obs_tmp,start=(/1/),count=(/len_x/))
 status = NF90_GET_VAR(ncgin,varid_obserr,obserr_tmp,start=(/1/),count=(/len_x/))
 status = NF90_GET_VAR(ncgin,varid_ind,idx_tmp,start=(/1/),count=(/len_x/))
 
 status = NF90_CLOSE(ncgin)
 
 Nobs = len_x
 Nloc = len_x 
 
! for rectangular lon lat grid
! clat = (lat_rho(1,pdomain(loop)%south) &
!        +lat_rho(1,pdomain(loop)%north))/2
! clon = (lon_rho(pdomain(loop)%west,1) &
!       +lon_rho(pdomain(loop)%east,1))/2

! For titled model grid with angle from the east. added by bjchoi
! It also works for the  rectangular lon lat grid
 clat = (lat_rho(pdomain(loop)%west,pdomain(loop)%south) &
        +lat_rho(pdomain(loop)%east,pdomain(loop)%north))/2
 clon = (lon_rho(pdomain(loop)%west,pdomain(loop)%south) &
        +lon_rho(pdomain(loop)%east,pdomain(loop)%north))/2

 !write(*,*) 'clon: ',clon,', clat: ',clat
 call distance(cx, ang, clat, clon, clat, clon+0.1)  ! cx is distance, ang is cycle angle
 call distance(cy, ang, clat, clon, clat+0.1, clon)  ! cy is distance, ang is cycle angle
 clon = 2.*0.12*param_all%cinf/cx  ! 20% up  --> hori decor length * 0.21, it should be 100% bjchoi
 clat = 2.*0.12*param_all%cinf/cy  ! 20% up  --> hori decor length * 0.21, it should be 100% bjchoi
 

   ! For titled model grid with angle from the east
   ! four points of a tilted rectangle. added by bjchoi
    x1 = lon_rho(pdomain(loop)%west,pdomain(loop)%south) - clon
    y1 = lat_rho(pdomain(loop)%west,pdomain(loop)%south) - clat 
    x2 = lon_rho(pdomain(loop)%east,pdomain(loop)%south) + clon
    y2 = lat_rho(pdomain(loop)%east,pdomain(loop)%south) - clat  
    x3 = lon_rho(pdomain(loop)%east,pdomain(loop)%north) + clon
    y3 = lat_rho(pdomain(loop)%east,pdomain(loop)%north) + clat
    x4 = lon_rho(pdomain(loop)%west,pdomain(loop)%north) - clon 
    y4 = lat_rho(pdomain(loop)%west,pdomain(loop)%north) + clat

 Nobs = 0
 do i = 1, len_x
  if (abs(x4-x1) < 0.01 .or. abs(x3-x2) < 0.01 .or. abs(x2-x1) < 0.01 .or. abs(x3-x4) < 0.01 ) then
    !For rectangular lon lat grid 
    if(lon_tmp(i) > lon_rho(pdomain(loop)%west,1)  - clon .and. &
       lon_tmp(i) < lon_rho(pdomain(loop)%east,1)  + clon .and. & 
       lat_tmp(i) > lat_rho(1,pdomain(loop)%south) - clat .and. & 
       lat_tmp(i) < lat_rho(1,pdomain(loop)%north) + clat) then	
       Nobs = Nobs + 1
       if (Nobs.gt.2000) write(*,*) 'Warn : No over 2000', cwrank
    endif
  else
   ! For titled model grid with angle from the east
   ! define four line based on four corner
    s1 = (y4-y1)/(x4-x1)
    rline1 = lat_tmp(i) - y1 - s1 * (lon_tmp(i)  - x1)
    s2 = (y3-y2)/(x3-x2)
    rline2 = lat_tmp(i) - y2 - s2 * (lon_tmp(i)  - x2)
    s3 = (y2-y1)/(x2-x1)
    rline3 = lat_tmp(i) - y1 - s3 * (lon_tmp(i)  - x1)
    s4 = (y3-y4)/(x3-x4)
    rline4 = lat_tmp(i) - y4 - s4 * (lon_tmp(i)  - x4) 
    if( rline1 > 0.0 .and. rline2 < 0.0 .and. & 
        rline3 > 0.0 .and. rline4 < 0.0 ) then
     Nobs = Nobs + 1
     if (Nobs.gt.2000) write(*,*) 'Warn : No over 2000', cwrank
    endif
  endif
 enddo
 Nloc = Nobs
 !write(6,*) 'Number of loc. obs (',cwrank,'): ',Nloc
 
 if(allocated(lon_obs)) then
   deallocate(lon_obs,lat_obs,depth_obs,obsdata,ind_obs,obserr,rndidx)
 endif
 
 allocate(lon_obs(Nloc),lat_obs(Nloc),depth_obs(Nloc),&
          obsdata(Nloc),ind_obs(Nloc),obserr(Nloc),rndidx(Nloc))
 
 Nobs = 0
 do i = 1, len_x
  if (abs(x4-x1) < 0.01 .or. abs(x3-x2) < 0.01 .or. abs(x2-x1) < 0.01 .or. abs(x3-x4) < 0.01 )  then
    !For rectangular lon lat grid 
    if(lon_tmp(i) > lon_rho(pdomain(loop)%west,1)  - clon .and. &
       lon_tmp(i) < lon_rho(pdomain(loop)%east,1)  + clon .and. & 
       lat_tmp(i) > lat_rho(1,pdomain(loop)%south) - clat .and. & 
       lat_tmp(i) < lat_rho(1,pdomain(loop)%north) + clat) then
     Nobs = Nobs + 1
     lon_obs(Nobs) = lon_tmp(i)
     lat_obs(Nobs) = lat_tmp(i)
     depth_obs(Nobs) = depth_tmp(i)
     obsdata(Nobs) = obs_tmp(i)
     obserr(Nobs) = obserr_tmp(i)
     ind_obs(Nobs) = idx_tmp(i)
     rndidx(Nobs) = i
    endif
  else
    !For titled model grid with angle from the east,
    !define four line based on four corner. added by bjchoi
    s1 = (y4-y1)/(x4-x1)
    rline1 = lat_tmp(i) - y1 - s1 * (lon_tmp(i)  - x1)
    s2 = (y3-y2)/(x3-x2)
    rline2 = lat_tmp(i) - y2 - s2 * (lon_tmp(i)  - x2)
    s3 = (y2-y1)/(x2-x1)
    rline3 = lat_tmp(i) - y1 - s3 * (lon_tmp(i)  - x1)
    s4 = (y3-y4)/(x3-x4)
    rline4 = lat_tmp(i) - y4 - s4 * (lon_tmp(i)  - x4)   
    if( rline1 > 0.0 .and. rline2 < 0.0 .and. & 
       rline3 > 0.0 .and. rline4 < 0.0 ) then
     Nobs = Nobs + 1
     lon_obs(Nobs) = lon_tmp(i)
     lat_obs(Nobs) = lat_tmp(i)
     depth_obs(Nobs) = depth_tmp(i)
     obsdata(Nobs) = obs_tmp(i)
     obserr(Nobs) = obserr_tmp(i)
     ind_obs(Nobs) = idx_tmp(i)
     rndidx(Nobs) = i
    endif
  endif
 enddo
 if(allocated(lon_tmp)) then
   deallocate(lon_tmp,lat_tmp,depth_tmp,obs_tmp,idx_tmp)
 endif
 
 
 end subroutine get_observation
 
 subroutine handle_err(status)

 use netcdf

 integer, intent (in) :: status
     
  if(status /= nf90_noerr) then
   print *, trim(nf90_strerror(status))
   stop "Stopped"
  end if
 end subroutine handle_err

 end module observation
