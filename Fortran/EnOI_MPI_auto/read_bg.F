!======================================================
! module background
! Programmed by Y.H. KIM in Apri., 2006
! Modified by G H SEO in JUNE., 2009
! Modified by Y-Y. Kim in JUNE., 2019
! Note : To prepare the Ensemble Kalman Filter
!======================================================

 module background
 use kalman, only : pdomain
 implicit none
 save
 integer,parameter  :: num_zlen=4
 integer,parameter  :: izeta=1,itemp=2,isalt=3,iu=4,iv=5
 logical, parameter :: ana = .false.
 integer, allocatable, dimension(:,:) :: index_back
 integer            :: len_xi_rho,len_eta_rho,len_ocean_time,len_xi_u,hc
 integer            :: len_eta_u,len_xi_v,len_eta_v,len_s_rho,len_s_w
 real(kind=8),allocatable,dimension(:)   :: cs_r,cs_w,s_rho
 real(kind=8),allocatable,dimension(:,:) :: hdepth
 real(kind=8),allocatable,dimension(:,:) :: zeta_r
 real(kind=8),allocatable,dimension(:,:) :: lon_rho,lat_rho,lon_u,lat_u,lon_v,lat_v 
 integer, allocatable, dimension(:,:) :: mask_rho, mask_u, mask_v
 real(kind=8),allocatable,dimension(:,:,:,:) :: temp_bg,salt_bg,u_bg,v_bg
 real(kind=8),allocatable,dimension(:,:,:) :: zeta_bg

!============================================================
! Background field at Observation Position
!------------------------------------------------------------
 real(8),allocatable,dimension(:,:) :: bdata_obs
!============================================================


 contains


subroutine read_bg(param_all)

use netcdf
use kalman, only : stdout, T_IO
!use background

implicit none

character(100) :: bg_file
character(20) :: ttext,dtext
character(10) :: var_name

integer       :: t, ist
integer       :: status,ncrin
integer       :: dim_xi_rho,dim_eta_rho,dim_ocean_time
integer       :: dim_xi_u,dim_eta_u,dim_xi_v,dim_eta_v,dim_s_rho
integer       :: varid_zeta,varid_u,varid_v,varid_temp,varid_salt,varid_rho

TYPE(T_IO), intent(inout) :: param_all ! added by Y-Y. Kim
!---------------------------

write(stdout,*) 'Read Backgroud files'

do t=1,param_all%Nens
 print *, "Processing Nens number = ",t
  bg_file=trim(param_all%enspath)//'/ocean_ens'
  write(ttext,'(I4.4)') t
  if (t<param_all%Nens) then
   bg_file=trim(trim(bg_file)//'_'//trim(ttext)//'.nc')
  print *, bg_file
!  bg_file =trim(bg_file)//trim(ttext)//'.nc'
  else
   bg_file = trim(param_all%outname)
  endif
! bg_file =trim(bg_file)//trim(ttext)//'_out.nc'
  write(stdout,*) bg_file
  status = NF90_OPEN(bg_file,NF90_NOWRITE,ncrin)
    if(status/=nf90_noerr) call handle_err(status) 
!  print *, 'open?'
  status = NF90_INQ_DIMID(ncrin,"xi_rho",dim_xi_rho)
  status = NF90_INQUIRE_DIMENSION(ncrin,dim_xi_rho,var_name,len_xi_rho)
  status = NF90_INQ_DIMID(ncrin,"eta_rho",dim_eta_rho)
  status = NF90_INQUIRE_DIMENSION(ncrin,dim_eta_rho,var_name,len_eta_rho)
  !status = NF90_INQ_DIMID(ncrin,"ocean_time",dim_ocean_time)
  !status = NF90_INQUIRE_DIMENSION(ncrin,dim_ocean_time,var_name,len_ocean_time)
  len_ocean_time=1 !ocean_time is unlimited variable... it should be changed...
  status = NF90_INQ_DIMID(ncrin,"xi_u",dim_xi_u)
  status = NF90_INQUIRE_DIMENSION(ncrin,dim_xi_u,var_name,len_xi_u)
  status = NF90_INQ_DIMID(ncrin,"eta_u",dim_eta_u)
  status = NF90_INQUIRE_DIMENSION(ncrin,dim_eta_u,var_name,len_eta_u)
  status = NF90_INQ_DIMID(ncrin,"xi_v",dim_xi_v)
  status = NF90_INQUIRE_DIMENSION(ncrin,dim_xi_v,var_name,len_xi_v)
  status = NF90_INQ_DIMID(ncrin,"eta_v",dim_eta_v)
  status = NF90_INQUIRE_DIMENSION(ncrin,dim_eta_v,var_name,len_eta_v)
  status = NF90_INQ_DIMID(ncrin,"s_rho",dim_s_rho)
  status = NF90_INQUIRE_DIMENSION(ncrin,dim_s_rho,var_name,len_s_rho)
  
  status = NF90_INQ_VARID(ncrin,"zeta",varid_zeta)
  status = NF90_INQ_VARID(ncrin,"u",varid_u)
  status = NF90_INQ_VARID(ncrin,"v",varid_v)
  status = NF90_INQ_VARID(ncrin,"temp",varid_temp)
  status = NF90_INQ_VARID(ncrin,"salt",varid_salt)
  status = NF90_INQ_VARID(ncrin,"rho",varid_rho)
  
  print *, 'read ensinfo is finished'
  if(.not.allocated(zeta_bg)) then
     allocate(zeta_bg(len_xi_rho,len_eta_rho,param_all%Nens), &
              u_bg(len_xi_u,len_eta_u,len_s_rho,param_all%Nens), &
              v_bg(len_xi_v,len_eta_v,len_s_rho,param_all%Nens), &
              temp_bg(len_xi_rho,len_eta_rho,len_s_rho,param_all%Nens), &
              salt_bg(len_xi_rho,len_eta_rho,len_s_rho,param_all%Nens))
  endif
  
  status = NF90_GET_VAR(ncrin,varid_zeta,zeta_bg(:,:,t) &
          ,start=(/1,1,len_ocean_time/),count=(/len_xi_rho,len_eta_rho,1/))
  status = NF90_GET_VAR(ncrin,varid_u,u_bg(:,:,:,t),start=(/1,1,1,len_ocean_time/) &
          ,count=(/len_xi_u,len_eta_u,len_s_rho,1/))
  status = NF90_GET_VAR(ncrin,varid_v,v_bg(:,:,:,t),start=(/1,1,1,len_ocean_time/) &
          ,count=(/len_xi_v,len_eta_v,len_s_rho,1/))
  status = NF90_GET_VAR(ncrin,varid_temp,temp_bg(:,:,:,t),start=(/1,1,1,len_ocean_time/) &
          ,count=(/len_xi_rho,len_eta_rho,len_s_rho,1/))
  status = NF90_GET_VAR(ncrin,varid_salt,salt_bg(:,:,:,t),start=(/1,1,1,len_ocean_time/) &
          ,count=(/len_xi_rho,len_eta_rho,len_s_rho,1/))
      
  status = NF90_CLOSE(ncrin)

enddo

print *, 'read_bg is finished'
end subroutine read_bg

 end module background
