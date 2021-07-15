!======================================================
! module observation
! Programmed by G.D. Pak in Jul., 2012
! Note : To prepare the Ensemble Kalman Filter
!======================================================

 subroutine get_obs_info(IDobs,param_all)

 use netcdf
 use observation
 use kalman, only : T_IO

 implicit none

 character(10)      :: var_name
 character(100)      :: infile
 character(80)      :: inpath
 character(10)      :: cidx,bidx

 integer, intent(in) :: IDobs 
 integer            :: i,k
 integer            :: ncgin, status
 integer            :: dim_xi_rho
 integer            :: len_x
 integer            :: varid_ndata
 real               :: gasdev
 integer,allocatable,dimension(:) :: len_xx
 TYPE(T_IO), intent(inout) :: param_all ! added by Y-Y. Kim

 allocate(len_xx(1))

 !infile = 'observation.nc'
!write(cidx,'(i3.3)') tindex
! write(cidx,'(i5.5)') tindex
!inpath = './observation/'
! inpath = '/HDD1/kimyy/OISST/nwp_1_10_obs_'
!infile = inpath//'all_obs_'//trim(cidx)//'.nc'
! infile = trim(trim(inpath)//trim(cidx)//'.nc')
infile=trim(param_all%obsname)

 !ttindex=tindex/tindex
 
 status = NF90_OPEN(infile,NF90_NOWRITE,ncgin)
 if(status/=nf90_noerr) call handle_err(status) 

 status = NF90_INQ_VARID(ncgin,"ndata",varid_ndata)
 
 status = NF90_GET_VAR(ncgin,varid_ndata,len_xx,start=(/1/),count=(/1/))

 len_x = len_xx(1)

 !write(6,*) 'Number of Observation (',cwrank,') : ', len_x
 
 status = NF90_CLOSE(ncgin)
 allocate(ornds(len_x,param_all%Nens))
 do k=1,param_all%Nens
   do i=1,len_x
      ornds(i,k)=gasdev(IDobs) 
   enddo
 enddo 
 
 
 end subroutine get_obs_info
