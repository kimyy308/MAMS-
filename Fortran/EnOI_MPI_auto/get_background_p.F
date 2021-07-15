 subroutine get_background_new(loop,cwrank,param_all)

 use netcdf
 use kalman
 use background

 implicit none
 
 include 'mpif.h'

 character(10)      :: var_name
 character(16)      :: grd_name
 character(100)      :: infile, gfile, ttext, bg_file
 
 integer,intent(in) :: loop,cwrank
 integer            :: ierr

 integer            :: i,j,k,inum
 integer            :: ii,jj
 integer            :: ncgin, ncgrd, ncrin, status, t, tt
 integer            :: dim_xi_rho,dim_eta_rho,dim_ocean_time,dim_xi_u
 integer            :: dim_eta_u, dim_xi_v, dim_eta_v, dim_s_rho,dim_s_w
 integer            :: varid_s_rho,varid_s_w
 integer            :: varid_zeta,varid_ubar,varid_vbar,varid_u,varid_v
 integer            :: varid_temp,varid_salt,varid_rho,varid_h
 integer            :: varid_mask_u, varid_mask_v, varid_mask_rho
 integer            :: varid_lon_rho,varid_lon_u,varid_lon_v
 integer            :: varid_lat_rho,varid_lat_u,varid_lat_v
 integer            :: varid_csr,varid_csw,varid_hc
 TYPE(T_IO), intent(inout) :: param_all ! added by Y-Y. Kim


pdomain(loop)%Nsta = 0
 if(ana) then
!    Nsta = len_xi_rho*len_eta_rho+len_s_rho*(len_xi_u*len_eta_u+len_xi_v*len_eta_v+len_xi_rho*len_eta_rho+len_xi_rho*len_eta_rho)
!    Nsta = len_xi_rho*len_eta_rho*len_s_rho

 else
    inum = 0
    pdomain(loop)%Nsta = 0
    do i=pdomain(loop)%west,pdomain(loop)%east
      do j=pdomain(loop)%south,pdomain(loop)%north
        inum = inum + mask_rho(i,j)
        !if (mask_rho(i,j).ne.0) then
        ! write(*,*) inum, mask_rho(i,j)
        !endif
      enddo
    enddo
    pdomain(loop)%Nsta = pdomain(loop)%Nsta + inum*(len_s_rho+1)
    
    inum = 0
    do i=pdomain(loop)%west,pdomain(loop)%east
      do j=pdomain(loop)%south,pdomain(loop)%north
        inum = inum + mask_rho(i,j)
      enddo
    enddo
    pdomain(loop)%Nsta = pdomain(loop)%Nsta + inum*len_s_rho
    
    inum = 0
    do i=pdomain(loop)%west,pdomain(loop)%eastu
      do j=pdomain(loop)%south,pdomain(loop)%north
        inum = inum + mask_u(i,j)
      enddo
    enddo
    pdomain(loop)%Nsta = pdomain(loop)%Nsta + inum*len_s_rho
    
    inum = 0
    do i=pdomain(loop)%west,pdomain(loop)%east
      do j=pdomain(loop)%south,pdomain(loop)%northv
        inum = inum + mask_v(i,j)
      enddo
    enddo
    pdomain(loop)%Nsta = pdomain(loop)%Nsta + inum*len_s_rho
 endif
    
 write(*,*) 'Size of State Vector for CPU',cwrank,' : ', pdomain(loop)%Nsta
 !write(*,*) 'Size of Ensemble : ', Nens
 if (allocated(pdomain(loop)%index_back)) then
   deallocate(pdomain(loop)%index_back,pdomain(loop)%old_ens)
 endif
 allocate(pdomain(loop)%index_back(pdomain(loop)%Nsta,4))
 allocate(pdomain(loop)%old_ens(pdomain(loop)%Nsta,param_all%Nens))

 inum = 0
 if(ana) then
    ! ^^
 else
    inum = 0
    do i=pdomain(loop)%west,pdomain(loop)%east
      do j=pdomain(loop)%south,pdomain(loop)%north
        if(mask_rho(i,j) == 1) then
          inum = inum + 1
          pdomain(loop)%index_back(inum,1) = izeta
          pdomain(loop)%index_back(inum,2) = i
          pdomain(loop)%index_back(inum,3) = j
          pdomain(loop)%index_back(inum,4) = 20
        endif
      enddo
    enddo
    do i=pdomain(loop)%west,pdomain(loop)%eastu
      do j=pdomain(loop)%south,pdomain(loop)%north
        do k=1,len_s_rho
          if(mask_u(i,j) == 1) then
            inum = inum + 1
            pdomain(loop)%index_back(inum,1) = iu
            pdomain(loop)%index_back(inum,2) = i
            pdomain(loop)%index_back(inum,3) = j
            pdomain(loop)%index_back(inum,4) = k
          endif
        enddo
      enddo
    enddo
    do i=pdomain(loop)%west,pdomain(loop)%east
      do j=pdomain(loop)%south,pdomain(loop)%northv
        do k=1,len_s_rho
          if(mask_v(i,j) == 1) then
            inum = inum + 1
            pdomain(loop)%index_back(inum,1) = iv
            pdomain(loop)%index_back(inum,2) = i
            pdomain(loop)%index_back(inum,3) = j
            pdomain(loop)%index_back(inum,4) = k
          endif
        enddo
      enddo
    enddo
    do i=pdomain(loop)%west,pdomain(loop)%east
      do j=pdomain(loop)%south,pdomain(loop)%north
        do k=1,len_s_rho
          if(mask_rho(i,j) == 1) then
            inum = inum + 1
            pdomain(loop)%index_back(inum,1) = itemp
            pdomain(loop)%index_back(inum,2) = i
            pdomain(loop)%index_back(inum,3) = j
            pdomain(loop)%index_back(inum,4) = k
          endif
        enddo
      enddo
    enddo
     do i=pdomain(loop)%west,pdomain(loop)%east
      do j=pdomain(loop)%south,pdomain(loop)%north
        do k=1,len_s_rho
          if(mask_rho(i,j) == 1) then
            inum = inum + 1
            pdomain(loop)%index_back(inum,1) = isalt
            pdomain(loop)%index_back(inum,2) = i
            pdomain(loop)%index_back(inum,3) = j
            pdomain(loop)%index_back(inum,4) = k
          endif
        enddo
      enddo
    enddo

 endif


 do t=1,param_all%Nens
    do i=1,pdomain(loop)%Nsta
      if(pdomain(loop)%index_back(i,1) == izeta) then
        pdomain(loop)%old_ens(i,t) = zeta_bg(pdomain(loop)%index_back(i,2),pdomain(loop)%index_back(i,3),t)
      else if(pdomain(loop)%index_back(i,1) == iu) then
        pdomain(loop)%old_ens(i,t) = u_bg(pdomain(loop)%index_back(i,2),pdomain(loop)%index_back(i,3),pdomain(loop)%index_back(i,4),t)
      else if(pdomain(loop)%index_back(i,1) == iv) then
        pdomain(loop)%old_ens(i,t) = v_bg(pdomain(loop)%index_back(i,2),pdomain(loop)%index_back(i,3),pdomain(loop)%index_back(i,4),t)
      else if(pdomain(loop)%index_back(i,1) == itemp) then
        pdomain(loop)%old_ens(i,t) = temp_bg(pdomain(loop)%index_back(i,2),pdomain(loop)%index_back(i,3),pdomain(loop)%index_back(i,4),t)
      else if(pdomain(loop)%index_back(i,1) == isalt) then
        pdomain(loop)%old_ens(i,t) = salt_bg(pdomain(loop)%index_back(i,2),pdomain(loop)%index_back(i,3),pdomain(loop)%index_back(i,4),t)
      endif
    enddo
enddo

end subroutine get_background_new


