subroutine read_grid(loof_num,param_all)

 use netcdf
 use kalman, only : num_domain, num_idomain, pdomain, cwrank, cwsize, idomain, stdout, T_IO
 use background, only : cs_r,cs_w,s_rho,hc,lon_rho,lat_rho,lon_u,lat_u,lon_v,lat_v,hdepth,mask_rho,mask_u,mask_v,&
                       len_xi_rho,len_eta_rho,len_xi_u,len_eta_u,len_xi_v,len_eta_v,len_s_rho,len_s_w,ana
 implicit none
 
 include 'mpif.h'
 
 character(150) :: grd_name, gfile
 character(20) :: ttext
 character(10) :: var_name 
! logical, parameter :: ana = .false.
 integer,intent(out):: loof_num
 integer            :: status,ncgin,ncgrd
 integer            :: dim_xi_rho,dim_eta_rho,dim_xi_u,dim_eta_u,dim_xi_v,dim_eta_v,dim_s_rho,dim_s_w
 integer            :: varid_csr,varid_csw,varid_hc,varid_s_rho
 integer            :: varid_lon_rho,varid_lat_rho,varid_lon_u,varid_lat_u,varid_lon_v,varid_lat_v,varid_h
 integer            :: varid_mask_rho,varid_mask_u,varid_mask_v
 integer            :: i, j, ii, jj 
 logical            :: ndom
 integer            :: ierr,loop
 integer            :: eu,nv,ep,np
 integer            :: ist

 TYPE(T_IO), intent(inout) :: param_all ! added by Y-Y. Kim
 
 
! grd_name =  "roms_grid_yes3km.nc"
! grd_name =  trim('/home/kosu02/ROMS_NP/input/PAC25_grd_wide_hmin_20m.nc')
!  grd_name =  trim('/home/auto/MAMS/Data/01_NWP_1_10/Input/auto01_grid.nc')
grd_name=trim(param_all%grdname)
print *, 'read_grid', grd_name
! gfile = "ocean_rst_ens"
!  gfile = "ocean_rst"
  write(ttext,'(I2.2)') 1
! gfile = trim(gfile)//trim(ttext)//'_out.nc'
! gfile = trim('/scratch/kosu02/roms_output/J_EnOI/Feb_v2/'//trim(gfile)//'_out.nc') 
!  gfile = trim('/HDD1/kimyy/reanalysis_data/output/exp01/'//trim(gfile)//'_out.nc')
  gfile=trim(param_all%outname)
  print *, gfile
  status = NF90_OPEN(gfile,NF90_NOWRITE,ncgin)
  if(status/=nf90_noerr) call handle_err(status,19001) 
 
  status = NF90_INQ_DIMID(ncgin,"xi_rho",dim_xi_rho)
  status = NF90_INQUIRE_DIMENSION(ncgin,dim_xi_rho,var_name,len_xi_rho)
  status = NF90_INQ_DIMID(ncgin,"eta_rho",dim_eta_rho)
  status = NF90_INQUIRE_DIMENSION(ncgin,dim_eta_rho,var_name,len_eta_rho)
  status = NF90_INQ_DIMID(ncgin,"xi_u",dim_xi_u)
  status = NF90_INQUIRE_DIMENSION(ncgin,dim_xi_u,var_name,len_xi_u)
  status = NF90_INQ_DIMID(ncgin,"eta_u",dim_eta_u)
  status = NF90_INQUIRE_DIMENSION(ncgin,dim_eta_u,var_name,len_eta_u)
  status = NF90_INQ_DIMID(ncgin,"xi_v",dim_xi_v)
  status = NF90_INQUIRE_DIMENSION(ncgin,dim_xi_v,var_name,len_xi_v)
  status = NF90_INQ_DIMID(ncgin,"eta_v",dim_eta_v)
  status = NF90_INQUIRE_DIMENSION(ncgin,dim_eta_v,var_name,len_eta_v)
  status = NF90_INQ_DIMID(ncgin,"s_rho",dim_s_rho)
  status = NF90_INQUIRE_DIMENSION(ncgin,dim_s_rho,var_name,len_s_rho)
  status = NF90_INQ_DIMID(ncgin,"s_w",dim_s_w)
  status = NF90_INQUIRE_DIMENSION(ncgin,dim_s_w,var_name,len_s_w)
 
  status = NF90_INQ_VARID(ncgin,"Cs_r",varid_csr)
  status = NF90_INQ_VARID(ncgin,"Cs_w",varid_csw)
  status = NF90_INQ_VARID(ncgin,"hc",varid_hc)
  status = NF90_INQ_VARID(ncgin,"s_rho",varid_s_rho)
  if(status/=nf90_noerr) then
  status = NF90_INQ_VARID(ncgin,"sc_r",varid_s_rho)
  if(status/=nf90_noerr) call handle_err(status,19002)
  endif
  
  allocate(cs_r(len_s_rho),cs_w(len_s_w),s_rho(len_s_rho))
  
  status = NF90_GET_VAR(ncgin,varid_csr,cs_r)
  status = NF90_GET_VAR(ncgin,varid_csw,cs_w)
  status = NF90_GET_VAR(ncgin,varid_hc,hc)
  status = NF90_GET_VAR(ncgin,varid_s_rho,s_rho)

  status = NF90_CLOSE(ncgin)
 
  if(.not.ana) then
 
   status = NF90_OPEN(grd_name,NF90_NOWRITE,ncgrd)
 if(status/=nf90_noerr) call handle_err(status,19003)
   status = NF90_INQ_VARID(ncgrd,"lon_rho",varid_lon_rho)
 if(status/=nf90_noerr) call handle_err(status,19004)
   status = NF90_INQ_VARID(ncgrd,"lat_rho",varid_lat_rho)
 if(status/=nf90_noerr) call handle_err(status,19005)
   status = NF90_INQ_VARID(ncgrd,"lon_u",varid_lon_u)
 if(status/=nf90_noerr) call handle_err(status,19006)
   status = NF90_INQ_VARID(ncgrd,"lat_u",varid_lat_u)
 if(status/=nf90_noerr) call handle_err(status,19007)
   status = NF90_INQ_VARID(ncgrd,"lon_v",varid_lon_v)
 if(status/=nf90_noerr) call handle_err(status,19008)
   status = NF90_INQ_VARID(ncgrd,"lat_v",varid_lat_v)
 if(status/=nf90_noerr) call handle_err(status,19009)
   status = NF90_INQ_VARID(ncgrd,"h",varid_h)
 if(status/=nf90_noerr) call handle_err(status,19010)
 
   status = NF90_INQ_VARID(ncgrd,"mask_rho",varid_mask_rho)
 if(status/=nf90_noerr) call handle_err(status,19011)
   status = NF90_INQ_VARID(ncgrd,"mask_u",varid_mask_u)
 if(status/=nf90_noerr) call handle_err(status,19012)
   status = NF90_INQ_VARID(ncgrd,"mask_v",varid_mask_v)
 if(status/=nf90_noerr) call handle_err(status,19013)
 
   allocate(lon_rho(len_xi_rho,len_eta_rho),lat_rho(len_xi_rho,len_eta_rho),&
            lon_u(len_xi_u,len_eta_u),lat_u(len_xi_u,len_eta_u),&
            lon_v(len_xi_v,len_eta_v),lat_v(len_xi_v,len_eta_v),&
            hdepth(len_xi_rho,len_eta_rho))
   allocate(mask_rho(len_xi_rho,len_eta_rho), &
           mask_u(len_xi_u,len_eta_u), &
           mask_v(len_xi_v,len_eta_v))
  
   status = NF90_GET_VAR(ncgrd,varid_lon_rho,lon_rho)
  if(status/=nf90_noerr) call handle_err(status,19014)
   status = NF90_GET_VAR(ncgrd,varid_lat_rho,lat_rho)
  if(status/=nf90_noerr) call handle_err(status,19015)
   status = NF90_GET_VAR(ncgrd,varid_lon_u,lon_u)
  if(status/=nf90_noerr) call handle_err(status,19016)
   status = NF90_GET_VAR(ncgrd,varid_lat_u,lat_u)
  if(status/=nf90_noerr) call handle_err(status,19017)
   status = NF90_GET_VAR(ncgrd,varid_lon_v,lon_v)
  if(status/=nf90_noerr) call handle_err(status,19018)
   status = NF90_GET_VAR(ncgrd,varid_lat_v,lat_v)
  if(status/=nf90_noerr) call handle_err(status,19019)
   status = NF90_GET_VAR(ncgrd,varid_h,hdepth)  
  if(status/=nf90_noerr) call handle_err(status,19020)  
   status = NF90_GET_VAR(ncgrd,varid_mask_rho,mask_rho)
  if(status/=nf90_noerr) call handle_err(status,19021)
   status = NF90_GET_VAR(ncgrd,varid_mask_u,mask_u)
  if(status/=nf90_noerr) call handle_err(status,19022)
   status = NF90_GET_VAR(ncgrd,varid_mask_v,mask_v)
  if(status/=nf90_noerr) call handle_err(status,19023)
 
   status = NF90_CLOSE(ncgrd)
  endif

 !------------------------------------------------------------------
 !
 ! Grid distribution
 !
 !------------------------------------------------------------------
 print *, 'grid distribution'
 num_domain = 0
 num_idomain = 0

 do i=1,len_xi_rho,param_all%dxdomain
   do j=1,len_eta_rho,param_all%dydomain
     num_idomain = num_idomain+1
     ndom = .false.
     do ii = i,min(i+param_all%dxdomain-1,len_xi_rho)
       do jj = j,min(j+param_all%dydomain-1,len_eta_rho)
         if (mask_rho(ii,jj)) then
           num_domain = num_domain + 1
           ndom = .true.
           exit
         endif
       enddo
       if(ndom) exit
     enddo
   enddo
 enddo
 call mpi_barrier(MPI_COMM_WORLD, ierr)
 loof_num = ceiling(real(num_domain)/real(cwsize))
 allocate(pdomain(loof_num))
 
 num_domain = 0
 loop = 0
 idomain = 0
 do i=1,len_xi_rho,param_all%dxdomain
   do j=1,len_eta_rho,param_all%dydomain
     idomain = idomain + 1
     ndom = .false.
     eu=min(len_xi_rho,i+param_all%dxdomain-1)
     nv=min(len_eta_rho,j+param_all%dydomain-1)
     ep=eu
     np=nv
     if (eu.eq.len_xi_rho) then
        ep=eu-1
        eu=eu-1
     endif
     if (nv.eq.len_eta_rho) then
        np=nv-1
        nv=nv-1
     endif
     do ii=i,min(i+param_all%dxdomain-1,len_xi_rho)
       do jj=j,min(j+param_all%dydomain-1,len_eta_rho)
         if (mask_rho(ii,jj)) then
           num_domain = num_domain + 1
           ndom = .true.
           if (mod(num_domain,cwsize) == cwrank) then
             loop = loop+1
             pdomain(loop)%ndomain = idomain
             pdomain(loop)%west = i
             pdomain(loop)%east = min(len_xi_rho,i+param_all%dxdomain-1)
             pdomain(loop)%south = j
             pdomain(loop)%north = min(len_eta_rho,j+param_all%dydomain-1)
             pdomain(loop)%eastu = eu 
             pdomain(loop)%northv = nv 
             pdomain(loop)%eastp = ep 
             pdomain(loop)%northp = np 
           endif           
            exit
         endif
       enddo
       if(ndom) exit
     enddo
     call mpi_barrier(MPI_COMM_WORLD,ierr)
     if (.not.ndom) then
      if (cwrank.eq.0) then
        !call save_dummy(idomain,pdomain(loop)%west,pdomain(loop)%east,pdomain(loop)%south,pdomain(loop)%north)
       call save_dummy(idomain,i,min(len_xi_rho,i+param_all%dxdomain-1),j,min(len_eta_rho,j+param_all%dydomain-1),eu,nv,ep,np,param_all)    !kimyy
      endif
     endif
     call mpi_barrier(MPI_COMM_WORLD,ierr)
   enddo
 enddo
 write(*,*) '# of idomain = ',num_idomain
 write(*,*) '# of domain = ',num_domain
 print *, 'read_grid is finished'
!------------------------------------------------------------------

end subroutine read_grid
