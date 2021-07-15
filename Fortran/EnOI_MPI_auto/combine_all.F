   Subroutine combine_all(nx,ny,dxdomain,dydomain,t,param_all)
   
   ! Modified by Y-Y. Kim in JUNE., 2019
  
    use kalman, only : T_IO
    use background, only : len_xi_rho,len_eta_rho,len_xi_u,len_eta_u &
                          ,len_xi_v,len_eta_v,len_s_rho,len_s_w
    use netcdf
    
    IMPLICIT NONE
 
    integer,intent(in) :: dxdomain,dydomain,nx,ny,t
    integer            :: i,j
    integer            :: w,e,s,n,eu,ep,nv,np
    integer            :: status,ncin,ncout
    integer            :: vh,vf,vpm,vpn,vlonr,vlatr,vlonu,vlatu
    integer            :: vlonv,vlatv,vlonp,vlatp,va,vmr,vmu,vmv,vmp
    integer            :: vo,vzeta,vubar,vvbar,vu,vv,vtemp,vsalt,vrho
    integer            :: vAKv,vAKt,vAKs
    character(800)      :: aname,bname,cname,sname
    real(8),allocatable,dimension(:,:) :: hi,fi,pmi,pni,lonri,latri
    real(8),allocatable,dimension(:,:) :: lonui,latui,lonvi,latvi,lonpi,latpi
    real(8),allocatable,dimension(:,:) :: ai,mri,mui,mvi,mpi
    real(8),allocatable,dimension(:,:,:) :: rhoi,AKvi,AKti,AKsi
    real(8),allocatable,dimension(:,:) :: zetai,ubari,vbari
    real(8),allocatable,dimension(:,:,:) :: tempi,salti,ui,vi
    real(8)                              :: oi
    
    TYPE(T_IO), intent(inout) :: param_all ! added by Y-Y. Kim

  !  do t=1,Nens
      ! Create combined nc files (using copy)
!      write(aname,'(A,I2.2,A)') 'ocean_rst_ens',t,'_in.nc' 
!      write(bname,'(A,I2.2,A)') 'ncout/ocean_rst_ens',t,'_out.nc'
!      write(cname,'(A,I2.2,A)') 'ocean_rst_ens',t,'_out.nc'
!      write(aname,'(A)') '/HDD1/kimyy/reanalysis_data/output/exp01/ocean_rst_in.nc' 
!      write(bname,'(A)') '/HDD1/kimyy/reanalysis_data/output/exp01/ncout/ocean_rst_out.nc'
aname=trim(param_all%inname)
bname=trim(param_all%outname)
print *, 'start combine all'

!      write(cname,'(A)') '/HDD1/kimyy/reanalysis_data/output/exp01/ocean_rst_out.nc'

!test!!
!      call system("cp -f " //trim(cname)//' '//trim(bname))      

call copy_nc(bname,aname) !!!!real

      do i=1,nx
        do j=1,ny
!          write(sname,'(A,I2.2,A,I4.4)') 'result/ocean_rst_ens',t,'_in.nc.',(i-1)*ny+j-1
!          write(sname,'(A,I4.4)') '/scratch/kosu02/roms_output/EnOI_MPI/result/ocean_rst_in.nc.',(i-1)*ny+j-1
!           write(sname,'(A,I4.4,A)') '/HDD1/kimyy/reanalysis_data/output/exp01/result/ocean_rst_in_',(i-1)*ny+j-1,'.nc'
           write(sname,'(A,A,I4.4,A)') trim(param_all%inname_piece_path),'/ocean_rst_in_',(i-1)*ny+j-1,'.nc'
           sname=trim(sname)
           print *, sname
!          write(sname,'(A,I4.4,A)') '/scratch/kosu02/roms_output/EnOI_MPI/result/ocean_rst_in_',t,'.nc'
           write(*,*) trim(sname),' ----> ',trim(aname)
           w=(i-1)*dxdomain+1
           s=(j-1)*dxdomain+1
           e=min(i*dxdomain,len_xi_rho)
           n=min(j*dxdomain,len_eta_rho)
           eu=e
           nv=n
           ep=eu
           np=nv
           if (eu.eq.len_xi_rho) then
             eu=eu-1
             ep=ep-1
           endif
           if (nv.eq.len_eta_rho) then
             nv=nv-1
             np=np-1
           endif
           ! allocate
           allocate(hi(e-w+1,n-s+1),fi(e-w+1,n-s+1))
           allocate(pmi(e-w+1,n-s+1),pni(e-w+1,n-s+1))
           allocate(lonri(e-w+1,n-s+1),latri(e-w+1,n-s+1))
           allocate(lonui(eu-w+1,n-s+1),latui(eu-w+1,n-s+1))
           allocate(lonvi(e-w+1,nv-s+1),latvi(e-w+1,nv-s+1))
           allocate(lonpi(ep-w+1,np-s+1),latpi(ep-w+1,np-s+1))
           allocate(ai(e-w+1,n-s+1))
           allocate(mri(e-w+1,n-s+1),mui(eu-w+1,n-s+1))
           allocate(mvi(e-w+1,nv-s+1),mpi(ep-w+1,np-s+1))
           allocate(rhoi(e-w+1,n-s+1,len_s_rho))
           allocate(AKvi(e-w+1,n-s+1,len_s_w))
           allocate(AKti(e-w+1,n-s+1,len_s_w))
           allocate(AKsi(e-w+1,n-s+1,len_s_w))
           allocate(zetai(e-w+1,n-s+1),ubari(eu-w+1,n-s+1))
           allocate(vbari(e-w+1,nv-s+1),ui(eu-w+1,n-s+1,len_s_rho))
           allocate(vi(e-w+1,nv-s+1,len_s_rho),tempi(e-w+1,n-s+1,len_s_rho))
           allocate(salti(e-w+1,n-s+1,len_s_rho)) 
 
           ! Read nc file piece
           status = NF90_OPEN(sname,NF90_NOWRITE,ncin)
           call handle_err(status,70000)
           
           status = NF90_INQ_VARID(ncin,"h",vh)
           call handle_err(status,70001)
           status = NF90_INQ_VARID(ncin,"f",vf)
           call handle_err(status,70002)
           status = NF90_INQ_VARID(ncin,"pm",vpm)
           call handle_err(status,70003)
           status = NF90_INQ_VARID(ncin,"pn",vpn)
           call handle_err(status,70004)
           status = NF90_INQ_VARID(ncin,"lon_rho",vlonr)
           call handle_err(status,70005)
           status = NF90_INQ_VARID(ncin,"lat_rho",vlatr)
           call handle_err(status,70006)
           status = NF90_INQ_VARID(ncin,"lon_u",vlonu)
           call handle_err(status,70007)
           status = NF90_INQ_VARID(ncin,"lat_u",vlatu)
           call handle_err(status,70008)
           status = NF90_INQ_VARID(ncin,"lon_v",vlonv)
           call handle_err(status,70009)
           status = NF90_INQ_VARID(ncin,"lat_v",vlatv)
           call handle_err(status,70010)
           status = NF90_INQ_VARID(ncin,"lon_psi",vlonp)
           call handle_err(status,70011)
           status = NF90_INQ_VARID(ncin,"lat_psi",vlatp)
           call handle_err(status,70012)
           status = NF90_INQ_VARID(ncin,"angle",va)
           call handle_err(status,70013)
           status = NF90_INQ_VARID(ncin,"mask_rho",vmr)
           call handle_err(status,70014)
           status = NF90_INQ_VARID(ncin,"mask_u",vmu)
           call handle_err(status,70015)
           status = NF90_INQ_VARID(ncin,"mask_v",vmv)
           call handle_err(status,70016)
           status = NF90_INQ_VARID(ncin,"mask_psi",vmp)
           call handle_err(status,70017)
           status = NF90_INQ_VARID(ncin,"ocean_time",vo)
           call handle_err(status,70018)
           status = NF90_INQ_VARID(ncin,"zeta",vzeta)
           call handle_err(status,70019)
           status = NF90_INQ_VARID(ncin,"ubar",vubar)
           call handle_err(status,70020)
           status = NF90_INQ_VARID(ncin,"vbar",vvbar)
           call handle_err(status,70021)
           status = NF90_INQ_VARID(ncin,"u",vu)
           call handle_err(status,70022)
           status = NF90_INQ_VARID(ncin,"v",vv)
           call handle_err(status,70023)
           status = NF90_INQ_VARID(ncin,"temp",vtemp)
           call handle_err(status,70024)
           status = NF90_INQ_VARID(ncin,"salt",vsalt)
           call handle_err(status,70025)
!           status = NF90_INQ_VARID(ncin,"rho",vrho)
!           call handle_err(status,70026)
!           status = NF90_INQ_VARID(ncin,"AKv",vAKv)
!           call handle_err(status,70027)
!           status = NF90_INQ_VARID(ncin,"AKt",vAKt)
!           call handle_err(status,70028)
!           status = NF90_INQ_VARID(ncin,"AKs",vAKs)
!           call handle_err(status,70029)

           status = NF90_GET_VAR(ncin,vh,hi)
           call handle_err(status,70101)
           status = NF90_GET_VAR(ncin,vf,fi)
           call handle_err(status,70102)
           status = NF90_GET_VAR(ncin,vpm,pmi)
           call handle_err(status,70103)
           status = NF90_GET_VAR(ncin,vpn,pni)
           call handle_err(status,70104)
           status = NF90_GET_VAR(ncin,vlonr,lonri)
           call handle_err(status,70105)
           status = NF90_GET_VAR(ncin,vlatr,latri)
           call handle_err(status,70106)
           status = NF90_GET_VAR(ncin,vlonu,lonui)
           call handle_err(status,70107)
           status = NF90_GET_VAR(ncin,vlatu,latui)
           call handle_err(status,70108)
           status = NF90_GET_VAR(ncin,vlonv,lonvi)
           call handle_err(status,70109)
           status = NF90_GET_VAR(ncin,vlatv,latvi)
           call handle_err(status,70110)
           status = NF90_GET_VAR(ncin,vlonp,lonpi)
           call handle_err(status,70111)
           status = NF90_GET_VAR(ncin,vlatp,latpi)
           call handle_err(status,70112)
           status = NF90_GET_VAR(ncin,va,ai)
           call handle_err(status,70113)
           status = NF90_GET_VAR(ncin,vmr,mri)
           call handle_err(status,70114)
           status = NF90_GET_VAR(ncin,vmu,mui)
           call handle_err(status,70115)
           status = NF90_GET_VAR(ncin,vmv,mvi)
           call handle_err(status,70116)
           status = NF90_GET_VAR(ncin,vmp,mpi)
           call handle_err(status,70117)
           status = NF90_GET_VAR(ncin,vo,oi)
           call handle_err(status,70118)
           status = NF90_GET_VAR(ncin,vzeta,zetai)
           call handle_err(status,70119)
           status = NF90_GET_VAR(ncin,vubar,ubari)
           call handle_err(status,70120)
           status = NF90_GET_VAR(ncin,vvbar,vbari)
           call handle_err(status,70121)
           status = NF90_GET_VAR(ncin,vu,ui)
           call handle_err(status,70122)
           status = NF90_GET_VAR(ncin,vv,vi)
           call handle_err(status,70123)
           status = NF90_GET_VAR(ncin,vtemp,tempi)
           call handle_err(status,70124)
           status = NF90_GET_VAR(ncin,vsalt,salti)
           call handle_err(status,70125)
!           status = NF90_GET_VAR(ncin,vrho,rhoi)
!           call handle_err(status,70126)
!           status = NF90_GET_VAR(ncin,vAKv,AKvi)
!           call handle_err(status,70127) 
!           status = NF90_GET_VAR(ncin,vAKt,AKti)
!           call handle_err(status,70128)
!           status = NF90_GET_VAR(ncin,vAKs,AKsi)
!           call handle_err(status,70129)

           status = NF90_CLOSE(ncin)
           call handle_err(status,70999)

           ! Open for combined file
           status = NF90_OPEN(aname,NF90_WRITE,ncout)
           call handle_err(status,71000)
           
           status = NF90_INQ_VARID(ncout,"h",vh)
           call handle_err(status,71001)
           status = NF90_INQ_VARID(ncout,"f",vf)
           call handle_err(status,71002)
           status = NF90_INQ_VARID(ncout,"pm",vpm)
           call handle_err(status,71003)
           status = NF90_INQ_VARID(ncout,"pn",vpn)
           call handle_err(status,71004)
           status = NF90_INQ_VARID(ncout,"lon_rho",vlonr)
           call handle_err(status,71005)
           status = NF90_INQ_VARID(ncout,"lat_rho",vlatr)
           call handle_err(status,71006)
           status = NF90_INQ_VARID(ncout,"lon_u",vlonu)
           call handle_err(status,71007)
           status = NF90_INQ_VARID(ncout,"lat_u",vlatu)
           call handle_err(status,71008)
           status = NF90_INQ_VARID(ncout,"lon_v",vlonv)
           call handle_err(status,71009)
           status = NF90_INQ_VARID(ncout,"lat_v",vlatv)
           call handle_err(status,71010)
           status = NF90_INQ_VARID(ncout,"lon_psi",vlonp)
           call handle_err(status,71011)
           status = NF90_INQ_VARID(ncout,"lat_psi",vlatp)
           call handle_err(status,71012)
           status = NF90_INQ_VARID(ncout,"angle",va)
           call handle_err(status,71013)
           status = NF90_INQ_VARID(ncout,"mask_rho",vmr)
           call handle_err(status,71014)
           status = NF90_INQ_VARID(ncout,"mask_u",vmu)
           call handle_err(status,71015)
           status = NF90_INQ_VARID(ncout,"mask_v",vmv)
           call handle_err(status,71016)
           status = NF90_INQ_VARID(ncout,"mask_psi",vmp)
           call handle_err(status,71017)
           status = NF90_INQ_VARID(ncout,"ocean_time",vo)
           call handle_err(status,71018)
           status = NF90_INQ_VARID(ncout,"zeta",vzeta)
           call handle_err(status,71019)
           status = NF90_INQ_VARID(ncout,"ubar",vubar)
           call handle_err(status,71020)
           status = NF90_INQ_VARID(ncout,"vbar",vvbar)
           call handle_err(status,71021)
           status = NF90_INQ_VARID(ncout,"u",vu)
           call handle_err(status,71022)
           status = NF90_INQ_VARID(ncout,"v",vv)
           call handle_err(status,71023)
           status = NF90_INQ_VARID(ncout,"temp",vtemp)
           call handle_err(status,71024)
           status = NF90_INQ_VARID(ncout,"salt",vsalt)
           call handle_err(status,71025)
!           status = NF90_INQ_VARID(ncout,"rho",vrho)
!           call handle_err(status,71026)
!           status = NF90_INQ_VARID(ncout,"AKv",vAKv)
!           call handle_err(status,71027)
!           status = NF90_INQ_VARID(ncout,"AKt",vAKt)
!           call handle_err(status,71028)
!           status = NF90_INQ_VARID(ncout,"AKs",vAKs)
!           call handle_err(status,71029)
       
           status = NF90_PUT_VAR(ncout,vh,hi,(/w,s/),(/e-w+1,n-s+1/))
           call handle_err(status,71101)
           status = NF90_PUT_VAR(ncout,vf,fi,(/w,s/),(/e-w+1,n-s+1/))
           call handle_err(status,71102)
           status = NF90_PUT_VAR(ncout,vpm,pmi,(/w,s/),(/e-w+1,n-s+1/))
           call handle_err(status,71103)
           status = NF90_PUT_VAR(ncout,vpn,pni,(/w,s/),(/e-w+1,n-s+1/))
           call handle_err(status,71104)
           status = NF90_PUT_VAR(ncout,vlonr,lonri,(/w,s/),(/e-w+1,n-s+1/))
           call handle_err(status,71105)
           status = NF90_PUT_VAR(ncout,vlatr,latri,(/w,s/),(/e-w+1,n-s+1/))
           call handle_err(status,71106)
           status = NF90_PUT_VAR(ncout,vlonu,lonui,(/w,s/),(/eu-w+1,n-s+1/))
           call handle_err(status,71107)
           status = NF90_PUT_VAR(ncout,vlatu,latui,(/w,s/),(/eu-w+1,n-s+1/))
           call handle_err(status,71108)
           status = NF90_PUT_VAR(ncout,vlonv,lonvi,(/w,s/),(/e-w+1,nv-s+1/))
           call handle_err(status,71109)
           status = NF90_PUT_VAR(ncout,vlatv,latvi,(/w,s/),(/e-w+1,nv-s+1/))
           call handle_err(status,71110)
           status = NF90_PUT_VAR(ncout,vlonp,lonpi,(/w,s/),(/ep-w+1,np-s+1/))
           call handle_err(status,71111)
           status = NF90_PUT_VAR(ncout,vlatp,latpi,(/w,s/),(/ep-w+1,np-s+1/))
           call handle_err(status,71112)
           status = NF90_PUT_VAR(ncout,va,ai,(/w,s/),(/e-w+1,n-s+1/))
           call handle_err(status,71113)
           status = NF90_PUT_VAR(ncout,vmr,mri,(/w,s/),(/e-w+1,n-s+1/))
           call handle_err(status,71114)
           status = NF90_PUT_VAR(ncout,vmu,mui,(/w,s/),(/eu-w+1,n-s+1/))
           call handle_err(status,71115)
           status = NF90_PUT_VAR(ncout,vmv,mvi,(/w,s/),(/e-w+1,nv-s+1/))
           call handle_err(status,71116)
           status = NF90_PUT_VAR(ncout,vmp,mpi,(/w,s/),(/ep-w+1,np-s+1/))
           call handle_err(status,71117)
           status = NF90_PUT_VAR(ncout,vo,oi)
           call handle_err(status,71118)
           status = NF90_PUT_VAR(ncout,vzeta,zetai,(/w,s/),(/e-w+1,n-s+1/))
           call handle_err(status,71119)
           status = NF90_PUT_VAR(ncout,vubar,ubari,(/w,s/),(/eu-w+1,n-s+1/))
           call handle_err(status,71120)
           status = NF90_PUT_VAR(ncout,vvbar,vbari,(/w,s/),(/e-w+1,nv-s+1/))
           call handle_err(status,71121)
           status = NF90_PUT_VAR(ncout,vu,ui,(/w,s,1/),(/eu-w+1,n-s+1,len_s_rho/))
           call handle_err(status,71122)
           status = NF90_PUT_VAR(ncout,vv,vi,(/w,s,1/),(/e-w+1,nv-s+1,len_s_rho/))
           call handle_err(status,71123)
           status = NF90_PUT_VAR(ncout,vtemp,tempi,(/w,s,1/),(/e-w+1,n-s+1,len_s_rho/))
           call handle_err(status,71124)
           status = NF90_PUT_VAR(ncout,vsalt,salti,(/w,s,1/),(/e-w+1,n-s+1,len_s_rho/))
           call handle_err(status,71125)
!           status = NF90_PUT_VAR(ncout,vrho,rhoi,(/w,s,1/),(/e-w+1,n-s+1,len_s_rho/))
!           call handle_err(status,71126)
!           status = NF90_PUT_VAR(ncout,vAKv,AKvi,(/w,s,1/),(/e-w+1,n-s+1,len_s_w/))
!           call handle_err(status,71127)
!           status = NF90_PUT_VAR(ncout,vAKt,AKti,(/w,s,1/),(/e-w+1,n-s+1,len_s_w/))
!           call handle_err(status,71128)
!           status = NF90_PUT_VAR(ncout,vAKs,AKsi,(/w,s,1/),(/e-w+1,n-s+1,len_s_w/))
!           call handle_err(status,71129)
  
           status = NF90_CLOSE(ncout)
           call handle_err(status,71999)

           ! deallocate     
           deallocate(hi,fi,pmi,pni,lonri,latri,lonui,latui,lonvi,latvi,lonpi,latpi)
           deallocate(ai,mri,mui,mvi,mpi,rhoi,AKvi,AKti,AKsi)
           deallocate(zetai,ubari,vbari,ui,vi,tempi,salti)
        enddo
      enddo
      
!call copy_nc(bname,aname)
  !  enddo !n=1,Nens

   End Subroutine combine_all
