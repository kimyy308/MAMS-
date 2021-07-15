! Modified by Y-Y. Kim in JUNE., 2019

   program enkf

   use background
   use kalman
   use observation
   use netcdf
   
   implicit none   

        include 'mpif.h'
        integer :: ierr 
        integer, parameter :: LLOOF=600
!        integer, parameter :: IDobs=-31
        integer :: i, j, k, kk, ii, jj, kkki, iil, t 
        integer :: iens,IDobs,IDobs2,loof_num
        integer :: dxdomain,dydomain,dnx,dny,ddd,savenum,snum
        integer :: m_inversion_count, m_inversion_flag
        integer :: rstatus, Nval, decode_line, io_status, int_status  ! added by Y-Y. Kim
        
        TYPE(T_IO) :: param_all ! added by Y-Y. Kim

        real :: gasdev 
        real(kind=8) :: aa, bb, delt,distst_hPh,distst_Ph, std, Kgain_inov,HBHT     
        real(kind=8) :: mean2, Nensd ,sum ,inflref 
        real(kind=8), allocatable, dimension(:) :: ens_mean,errvec ,Dummy
        real(kind=8), allocatable, dimension(:,:) :: mft_cov_mft,Cov_measft,LHS,err_covar       
!        real(kind=8), allocatable, dimension(:,:) :: obs_p 
!        real(kind=8) :: avgrmserr,fctrmserr,anlrmserr, fctobserr,anlobserr
        
        character(20) :: text
        character (len=40) :: KeyWord ! added by Y-Y. Kim
        character(44) :: expname
        character(100) :: bg_file, outfile
!        real(kind=8) :: inflation, infl1, infl2,inflold,inflref
        character(100) :: initial_file,next_file, ini_file,zip_file, before_file , param_file, ttext, ntext,command1
        character (len=256), dimension(200) :: Cval
        character (len=256) :: line
        integer :: lwork4,rcode
        real(kind=8), allocatable, dimension(:)  ::  work4
        integer,allocatable,dimension(:) :: iloof 

        real(kind=8), allocatable, dimension(:) :: RHS, borig, diag, x,check,Mbdata
        real(kind=8), allocatable, dimension(:) :: diff
        real, allocatable, dimension(:) :: gauss_rand
        real(kind=8), allocatable, dimension(:,:) :: aorig, sol 
!        real(kind=8), parameter :: eps = 0.001d0 
!        real(kind=8), parameter :: cinf2=2*cinf
!        real(kind=8), parameter :: hinf2=2*hinf
!        real(kind=8), parameter :: alpha=1.0
        real(kind=8), dimension(100) :: Rval ! added by Y-Y. Kim

        ! save res_file before assimilation
!        call save_before_anal

!!!!!!! For observation error!!!!!!!!
!        integer, parameter :: ori_wN=5, new_wN=1
!        real, allocatable, dimension(:) :: coef, sdepth, stt, sdepth_new, stt_new
!        real, allocatable, dimension(:) :: wcoef, ori_wx, ori_wy, new_wx, new_wy
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!--------------------------------
!
! Ready analysis file
!
!--------------------------------
!    write(*,*) 'Copy nc files'
!	do t=1,Nens
!	 write(text,'(I2.2)') t
!	 bg_file = 'ocean_rst_ens'
!     zip_file = 'before_ens'
!	 bg_file = trim(bg_file)//trim(text)//'_out.nc'
!	 outfile='hisfile/ocean_rst_ens'
!     next_file = trim(zip_file)//trim(ttext)//'_step'//trim(ntext)//'_ini.nc'
!	 outfile=trim(outfile)//trim(text)//'_in.nc'
!	 call copy_nc(bg_file,outfile)
!	enddo
!   open(11,file='kalman.par',status='old')
!   read(11,*)
!   read(11,'(15X,I3)')istep
!   close(11) 
!   ini_file = 'ocean_rst_ens'
!   zip_file = 'before_ens'
!   write(ntext,'(I3.3)') istep
!   do t=1,Nens
!   write(ttext,'(I2.2)') t
!   initial_file = trim(ini_file)//trim(ttext)//'_out.nc'
!   next_file = trim(zip_file)//trim(ttext)//'_step'//trim(ntext)//'_ini.nc'
!   call copy_nc(initial_file, next_file)
!   enddo

!  before_file ='ini_bg'
!   before_file = trim(before_file)//trim(ntext)//'step.tar.gz'
!   command1='tar zcvf '//trim(before_file)//' *_ini.nc'
!   call system(command1)
!
!--------------------------------  
        ! */ Y-Y. Kim corrected
        call getarg(1, param_file)
        rstatus=1
        OPEN (1111, file=param_file, iostat=io_status, status='old')
        DO WHILE (rstatus)

          READ (1111,'(a)', END=999) line
          rstatus=decode_line(line, KeyWord, Nval, Cval, Rval)
          IF (rstatus.gt.0) THEN
            SELECT CASE (TRIM(KeyWord))
              CASE ('GRDNAME')
                param_all%grdname=TRIM(Cval(Nval))
                print *, 'GRDNAME = ', param_all%grdname 
              CASE ('ENSPATH')
                param_all%enspath=TRIM(Cval(Nval))
                print *, 'ENSPATH = ', param_all%enspath 
              CASE ('OBSNAME')
                param_all%obsname=TRIM(Cval(Nval))
                print *, 'OBSNAME = ', param_all%obsname
              CASE ('INNAME')
                param_all%inname=TRIM(Cval(Nval))
                print *, 'INNAME = ', param_all%inname
              CASE ('OUTNAME')
                param_all%outname=TRIM(Cval(Nval))
                print *, 'OUTNAME = ', param_all%outname
              CASE ('INNAME_PIECE_PATH')
                param_all%inname_piece_path=TRIM(Cval(Nval))
                print *, 'INNAME_PIECE_PATH = ', param_all%inname_piece_path
              CASE ('LOGNAME')
                param_all%logname=TRIM(Cval(Nval))
                print *, 'LOGNAME = ', param_all%logname
              CASE ('NENS')
                param_all%Nens=INT(Rval(Nval))
                param_all%ss_dim=INT(Rval(Nval))
                print *, 'NENS = ', param_all%Nens
              CASE ('DXDOMAIN')
                param_all%dxdomain=INT(Rval(Nval))
                print *, 'DXDOMAIN = ', param_all%dxdomain
              CASE ('DYDOMAIN')
                param_all%dydomain=INT(Rval(Nval))
                print *, 'DYDOMAIN = ', param_all%dydomain
              CASE ('CINF')
                param_all%cinf=Rval(Nval)
                param_all%cinf2=Rval(Nval)*2.0
                print *, 'CINF = ', param_all%cinf
              CASE ('HINF')
                param_all%hinf=Rval(Nval)
                param_all%hinf2=Rval(Nval)*2.0
                print *, 'HINF = ', param_all%hinf
              CASE ('EPS')
                param_all%eps=Rval(Nval)
                print *, 'EPS = ', param_all%eps
              CASE ('ALPHA')
                param_all%alpha=Rval(Nval)
                print *, 'ALPHA = ', param_all%alpha
            END SELECT
          ELSE
            rstatus=-1
          END IF 
        END DO
999     CONTINUE
        CLOSE(1111)
        ! /*

        call MPI_INIT(ierr)
        call MPI_COMM_RANK(MPI_COMM_WORLD, cwrank, ierr)
        call MPI_COMM_SIZE(MPI_COMM_WORLD, cwsize, ierr)
        call MPI_BARRIER(MPI_COMM_WORLD, ierr) 
        stdout=cwrank+300    
!        write(*,*) 'Nens=',Nens   
!        write(*,*) 'read domain_dxdy' 
!        open(11,file='domain_dxdy.txt',status='old')
!        read(11,*) dxdomain
!        read(11,*) dydomain
!        close(11)
!        write(*,*) 'dx and dy :', dxdomain, ', ', dydomain
!        open(*,file=trim(param_all%logname))
        ! */ Y-Y. Kim corrected
        ! /*
        
        ! */ Y-Y. Kim corrected
        write(*,*) 'Nens=',param_all%Nens   
        write(*,*) 'dx and dy :', param_all%dxdomain, ', ', param_all%dydomain

        ! /*


        lwork4=5*param_all%ss_dim
        Nensd = 1.0d0 / dfloat(param_all%Nens)

!        write(*,*) 'read kalman.par'
!        open(11,file='kalman.par',status='old')
!        read(11,*)
!        read(11,'(15X,I5)')istep
!        close(11)
!        write(*,*) 'Step :',istep
        

!        if (cwrank.eq.0) then   
!          call update_metafile    !!--> for debug, running on only one CPU
!          write(*,*) 'NEXTSTEP'
!        endif
        
        !allocate(iloof(LLOOF))
        !open(21,file='kalman_loof.par',status='old')
        !read(21,*)
        !do i=1,istep
        !read(21,'(i5)') iloof(i)
        !write(*,*) iloof(i)
        !enddo
        !loof_num= iloof(istep)
        !write(*,*)'Step loof : ', loof_num
        !close(21)
! save initial
!       call save_ini
       !write(*,*)'save initial'
       call MPI_BARRIER(MPI_COMM_WORLD, ierr) 
       write(*,*) 'read_grid'
       call read_grid(loof_num,param_all)
       write(*,*) 'loof_num=',loof_num
       call read_bg(param_all) ! read whole zeta, temp, salt, u, v (kimyy)
       write(*,*) 'read_bg'
       IDobs=-31.00
!       If (istep .eq. 1) then
!            IDobs=-31.00
!            open(78,file='IDobs.dat')
!            write(78,*) IDobs
!            close(78)
!          else
!            open (78, file='IDobs.dat')
!            read(78, *) IDobs
            !print *, 'IDobs= ', IDobs
!            close(78)
!            IDobs=-31.00
!          endif   
     print *, 'IDobs :', IDobs 
      call get_obs_info(IDobs,param_all)
     print *, 'IDobs :', IDobs 
!      open(78,file='IDobs.dat')
      !write(78,*) IDobs
!      close(78)

      do iil = 1,loof_num
        write(*,*) 'iil=',iil
        call mpi_barrier(MPI_COMM_WORLD,ierr)
        idomain = (iil-1)*cwsize+cwrank
        if (cwrank.eq.0) then
          idomain=idomain+cwsize
          print *, '?'
        endif
        if (idomain <= num_domain) then
           write(*,*)'get background'
           call get_background_new(iil,cwrank,param_all)
           if (pdomain(iil)%Nsta.gt.0) then
             write(*,*)'get observation'
             call get_observation(iil,param_all)
             write(*,*) 'Make background at Obs. points' 
             call make_bg_obs(param_all)
           endif
        endif

        if (Nobs>0) then
         allocate(LHS(Nobs,Nobs),err_covar(Nobs,Nobs),mft_cov_mft(Nobs,Nobs),aorig(Nobs,Nobs))
         allocate(Cov_measft(pdomain(iil)%Nsta,Nobs),sol(param_all%Nens,Nobs),Mbdata(Nobs))
         allocate(RHS(Nobs),borig(Nobs),diag(Nobs),x(Nobs),check(Nobs),diff(Nobs),gauss_rand(Nobs),Dummy(Nobs))
         allocate(errvec(pdomain(iil)%Nsta),ens_mean(pdomain(iil)%Nsta))
         allocate(work4(lwork4))

         expname='./out' 
         inflref = 1.

!       open(401,file='EnSp.dat')
	!       open(402,file='Lambda.dat')
	!       open(403,file='ErrOut.dat')
	!       open(411,file='IDobs.dat')
!!!!!!!!!!!!!!!!Calculate the Ensemble Mean !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!      
!        Nsta: the length of state vector             (ista)             !
!        Nens: the number of ensemble member          (iens)             !  
!        old_ens(ista,iens): state vector                                !
!        ens_mean(ista)    : mean of ensemble member old_ens(ista,iens)  !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            do i=1,pdomain(iil)%Nsta
             aa=0.0d0
               do K=1,param_all%Nens            
                aa=aa+pdomain(iil)%old_ens(i,K)
               enddo
             ens_mean(i)=aa*Nensd
            enddo
            write(*,*) 'calulate ensemble mean cwrank = ', cwrank
!!!!!!!!!!!!!! Calculate obs_p(1:Nobs,1:Nens) !!!!!!!!!!!!!!!!!!!!!!!!!!
!             obs_p=Nobs*Nens                                          !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            do i=1,Nobs
               aa = 0.0d0
               do k=1,param_all%Nens
                aa = aa + bdata_obs(i,k)
               enddo
               Mbdata(i) = aa/real(param_all%Nens)
            enddo
            ! obs_p(:,:)=bdata_obs(:,:) 
        endif !if (Nobs>0)
        write(*,*) 'calulated obs mean cwrank = ', cwrank
call mpi_barrier(MPI_COMM_WORLD,ierr)
if(idomain <=num_domain .and. Nobs>0 .and. pdomain(iil)%Nsta>0) then
!write(*,*) ' obs_point =',  bdata_obs         
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! compute CH' and save it as Cov_measft                                !
!                           [ Nsta x Nobs ]                            !
!         C is the corvariance matrix (cov)                            !
!         H is measurement function   (measft)                         !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          do ii=1,Nobs
            do  jj=1,pdomain(iil)%Nsta 
               sum=0.d0
                do iens =1,param_all%Nens 
                   sum = sum + bdata_obs(ii,iens)*pdomain(iil)%old_ens(jj,iens)
                enddo
                mean2=Mbdata(ii)*ens_mean(jj)
                Cov_measft(jj,ii) = sum*Nensd - mean2
             enddo
           enddo
           write(*,*) 'calculated PH   cwrank = ', cwrank
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!     Correct the Covariance Function; get rid of
!     false correlation at long distance
!     Bk=Bk*HBHT;
!     See Houtekamer and Mitchell, MWR 2001, P123
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!           print *, param_all%cinf, param_all%cinf2, param_all%alpha
           do i=1,Nobs
             do k=1,pdomain(iil)%Nsta
!                print *, 'here?'
                delt=distst_Ph(i,k,iil,param_all)
!                print *, 'here'
                if(delt .gt. param_all%cinf2) then
                     HBHT = 0.
                elseif(delt .gt. param_all%cinf) then
                     HBHT = 1./12.*(delt/param_all%cinf)**5 &
                            -1./2.*(delt/param_all%cinf)**4 &
                            +5./8.*(delt/param_all%cinf)**3 &
                            +5./3.*(delt/param_all%cinf)**2 &
                            -5.*(delt/param_all%cinf) &
                            +4. -2./3.*(param_all%cinf/delt)
                else
                     HBHT = -1./4.*(delt/param_all%cinf)**5 &
                            +1./2.*(delt/param_all%cinf)**4 &
                            +5./8.*(delt/param_all%cinf)**3 &
                            -5./3.*(delt/param_all%cinf)**2 &
                            +1
                endif
                Cov_measft(k,i)=param_all%alpha*(Cov_measft(k,i)*HBHT) ! make it EnKF
!               Cov_measft(k,i)=1.0*HBHT ! make it OI
                !if(abs(HBHT).gt.1.0)then
                !  write(*,*) k,i, HBHT,Cov_measft(k,i)
                !endif
             enddo
           enddo
!           print *, param_all%cinf2, param_all%cinf
           write(*,*) 'finished CH`'
           write(*,*) 'calulated rho*PH`   cwrank = ', cwrank
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
! compute HCH'                                                         !  
! (Nobs x Nobs matrix)                                                 !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
           do ii=1,Nobs
             do jj=1,Nobs
               sum=0.d0 
               do iens=1,param_all%Nens 
                 sum=sum+bdata_obs(ii,iens)*bdata_obs(jj,iens)
               enddo 
               mean2=Mbdata(ii)*Mbdata(jj) 
               mft_cov_mft(ii,jj)=sum*Nensd - mean2 
               delt=distst_hPh(ii,jj,param_all)
        
               if(delt .gt. param_all%cinf2) then
                  HBHT = 0.
               elseif(delt .gt. param_all%cinf) then
                  HBHT = 1./12.*(delt/param_all%cinf)**5 &
                        -1./2.*(delt/param_all%cinf)**4 &
                        +5./8.*(delt/param_all%cinf)**3 &
                        +5./3.*(delt/param_all%cinf)**2 &
                        -5.*(delt/param_all%cinf) &
                        +4. -2./3.*(param_all%cinf/delt)
               else
                  HBHT = -1./4.*(delt/param_all%cinf)**5 &
                        +1./2.*(delt/param_all%cinf)**4 &
                        +5./8.*(delt/param_all%cinf)**3 &
                        -5./3.*(delt/param_all%cinf)**2 &
                        +1
               endif
               mft_cov_mft(ii,jj)=param_all%alpha*(mft_cov_mft(ii,jj)*HBHT) ! make it EnKF
               !mft_cov_mft(ii,jj)=1.0*HBHT ! make it OI
             enddo
           enddo
           write(*,*) 'finished rho*HCH`'
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!  Get the Observation error Covariance Matrix:                        !
!                         err_covar [ Nobs * Nobs ]                    !   
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
           err_covar=0.0 

           do ii=1,Nobs 
             err_covar(ii,ii)=obserr(ii)*obserr(ii)
           enddo 
           write(*,*) 'calculated Obs Error Cov. matrix R '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!                 LHS= mft_cov_mft+ err_covar                      !
!                    =HCH'+R                                        !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
         m_inversion_flag = 0
         m_inversion_count= 1

         do while (m_inversion_flag .eq. 0 .and. m_inversion_count .lt. 10) 

           write(*,*) ' matrix inversion count = ', m_inversion_count

           do i=1,Nobs
             do j=1,Nobs
               LHS(i,j)=mft_cov_mft(i,j)+err_covar(i,j)
             enddo
           enddo
           write(*,*) 'Got HPH`+R and ready to inverse it    cwrank = ', cwrank
     
           do ii=1,Nobs 
             do jj=1,Nobs 
               aorig(ii,jj)=LHS(ii,jj)
             enddo 
           enddo 

           do i=1,Nobs
             Dummy(i)=0.0d0
           enddo

           call gaussj(LHS,Nobs,Nobs,Dummy,1,1)
           ! check if the matrix inversion is all right
           m_inversion_flag = 1
           do ii=1,Nobs
             do jj=1,Nobs
               aa=0.0d0
               do  kk=1,Nobs
                 aa=aa+aorig(ii,kk)*LHS(kk,jj)
               enddo
               if((ii .eq. jj .and. (aa .gt. 1.1 .or. aa .lt.  0.9)) .OR. &
                  (ii .ne. jj .and. (aa .gt. 0.1 .or. aa .lt. -0.1))) then
                  m_inversion_flag = 0
                  !write(*,*) ' ii, jj, aa = ', ii, jj, aa
               endif   
             enddo
           enddo
           ! if the matrix inversion is not correct, increase obs error
           ! covariance in order to make the matrix invertable
           if ( m_inversion_flag .eq. 0 ) then
             do ii=1,Nobs
             do jj=1,Nobs
              err_covar(ii,jj) = err_covar(ii,jj) * 2.0d0
             enddo
             enddo
             write(*,*)'matrix inversion was not successful '
             write(*,*)'number of matrix inversion count = ', m_inversion_count
             m_inversion_count = m_inversion_count + 1
           endif

         enddo ! while

         if(m_inversion_count.lt.10) then
          write(*,*)'Now, inversion of matrix HPH` + R is SUCCESSFUL.'
          write(*,*)'number of matrix inversion count = ', m_inversion_count
       !  else
       !   write(*,*)' HPH and observation err_covar(ii,ii) = '
       !   do ii=1,Nobs
       !      write(*,*) mft_cov_mft(ii,ii),  err_covar(ii,ii)
       !   enddo
         endif
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!     subroutine gaussj will output inverse matrix of LHS          !
!     provide a seed number to a random number generator           !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!           If (istep .eq. 1) then
!		     IDobs=-31.00
!	       else
!		     open (78, file='IDobstmp.dat')
!		     read(78, *) IDobs
!		     !print *, 'IDobs= ', IDobs
!		     close(78)
!	       endif   
!		   write(411,*) IDobs 

        if( m_inversion_flag .eq. 1) then 

         !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
         !     starting  do loop 100                              !
         !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!            
!        do 100 iens=1, Nens
!         iens=35 
          iens = param_all%Nens
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!     generate random numbers with Gaussian distribution           !
!     See get_obs_info subroutine (G.D. Pak)                       ! 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            !do ii = 1, Nobs 
            !  gauss_rand(ii) = gasdev(IDobs)
            !enddo
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! set RHS = observation data + gauss_rand  - measurement            !
!      i.e. this the invovation vector                              ! 
!      observation: really observed data from real ocean            !
!      measurement: calculated values from numberical model         !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!     ( HCH' + R )^{-1} *( y   -  y   )  =  unknown                !  
!                           0      f                               !
!                                                                  !
!         LHS^{-1}      *   RHS         =   X                      !
!                                                                  !
!         LHS X = RHS                                              !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
           do ii = 1, Nobs 
             std = dsqrt( err_covar(ii,ii) ) 
!            RHS(ii) = obsdata(ii) + std*ornds(rndidx(ii),iens) - bdata_obs(ii,iens)
             RHS(ii) = obsdata(ii) + std*ornds(rndidx(ii),iens) - bdata_obs(ii,iens)
           ! RHS(ii) = obsdata(ii) + std - bdata_obst(ii,iens) 
           enddo 
 
           do ii=1,Nobs 
             borig(ii)=RHS(ii) 
           enddo 

           do j=1,Nobs
             aa=0.0d0
             do k=1,Nobs
               aa=aa+LHS(j,k)*RHS(k)
             enddo
!            sol(iens,j)=aa
             sol(1,j)=aa
           enddo
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Save the solution X: sol(iens,:)=X(:)                        !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!            A   * X = B
!          aorig * x = borig
!          LHS   * x = RHS 
           do ii=1,Nobs
!            x(ii)=  sol(iens,ii)
             x(ii)=  sol(1,ii)
           enddo      
       
           do ii=1,Nobs 
             aa = 0.0d0 
             do jj=1,Nobs 
               aa = aa + aorig(ii,jj)*x(jj) 
             enddo 
             check(ii) = aa 
             diff(ii)  = dabs(check(ii) - borig(ii)) 
           enddo 
 
           do ii=1,Nobs 
             if ( diff(ii) .gt. param_all%eps ) then 
               write(*,*) 'Here, Error in matrix inversion '
               write(*,*) 'check accuracy at obs # ',ii,'iens=',iens,' diff= ',diff(ii) 
             endif 
           enddo 
!    100 enddo
     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     !! end do loop 100                                           !
     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!        do iens=1,Nens
!         iens = 35
          iens = param_all%Nens
          do ii=1,pdomain(iil)%Nsta 
           Kgain_inov = 0.0d0
           do jj = 1, Nobs 
!           Kgain_inov =Kgain_inov+Cov_measft(ii,jj)*sol(iens,jj) 
            Kgain_inov =Kgain_inov+Cov_measft(ii,jj)*sol(1,jj) 
           enddo
!          pdomain(iil)%old_ens(ii,iens) = pdomain(iil)%old_ens(ii,iens) + Kgain_inov 
           pdomain(iil)%old_ens(ii,iens) = pdomain(iil)%old_ens(ii,iens) + Kgain_inov 
          enddo
!        enddo
         write(*,*) 'finish new ensemble' 
         write(*,*) 'new ensemble is updated! '

     endif ! m_inversion_flag

endif !if(idomain <=num_domain .and. Nobs>0 .and. pdomain(iil)%Nsta>0)
print *, 'before save_anal, idomain : ', idomain
print *, 'before save_anal, num_domain : ', num_domain
call mpi_barrier(MPI_COMM_WORLD,ierr)
     if (idomain<=num_domain) then
        call save_anal(iil,param_all)
     endif
     call mpi_barrier(MPI_COMM_WORLD,ierr)
!     endif !if(idomain <=num_domain .and. Nobs>0 .and. pdomain(iil)%Nsta>0)
        if (Nobs>0) then       !kimyy
         deallocate(LHS,err_covar,mft_cov_mft,aorig)
         deallocate(Cov_measft,sol,Mbdata)
         deallocate(RHS,borig,diag,x,check,diff,gauss_rand,Dummy)
         deallocate(errvec,ens_mean)
         deallocate(work4)
        endif

    enddo !do iil = 1,loof_num
    write(*,*) 'End of iil'
!    deallocate(Cov_measft)
!    deallocate(LHS,err_covar,mft_cov_mft,aorig,sol,Mbdata) 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!  save_bg   will read his_ens(iens)_out.nc and save them onto bg_(istep)step.nc !
!  save_anal will save new_ens(ista,iens) onto ocean_rst_ens_step(istep).nc      !
!                                          and his_ens(iens)_in.nc               !
!  save_bg1  will tar and zip ocean_rst_ens_step(istep).nc                       !  
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   
!          write(*,*)"1"
!          call save_bg
!          write(*,*)"2"
!          call save_anal
!          write(*,*)"3"
!observation deallocate
!    deallocate(lon_obs,lat_obs,depth_obs,obsdata,obserr,ind_obs)
!background deallocate
!    deallocate(cs_r,cs_w,s_rho,lon_rho,lat_rho,lon_u,lat_u,lon_v,lat_v,hdepth,zeta_r)
!    deallocate(index_back,old_ens,bdata_obs)
!main deallocate
!    deallocate(RHS,borig,diag,x,check,diff,gauss_rand,Dummy)
!    deallocate(errvec,ens_mean,work4)
!    deallocate(Cov_measft)
!    deallocate(LHS,err_covar,mft_cov_mft,aorig,sol,Mbdata)
!	else
!deallocate(lon_obs,lat_obs,depth_obs,obsdata,ind_obs)
!	endif 
!write(*,*) '--------------- > Go go next loof < ----------------------'

   dnx=len_xi_rho/param_all%dxdomain
   ddd=len_xi_rho-dnx*param_all%dxdomain
   if (ddd.gt.0) then
     dnx=dnx+1
   endif

   dny=len_eta_rho/param_all%dydomain
   ddd=len_eta_rho-dny*param_all%dydomain
   if (ddd.gt.0) then
     dny=dny+1
   endif 

   savenum=param_all%Nens/cwsize
   ddd=param_all%Nens-savenum*cwsize
   if (ddd.gt.0) then
      savenum=savenum+1
   endif

   
!  do snum=1,savenum
!    snum = 11
      print *,'finstart?????'
      call mpi_barrier(MPI_COMM_WORLD,ierr)
      print *,'finstart?????, 649'
      if ((snum-1)*cwsize+cwrank+1.le.param_all%Nens) then
!       call combine_all(dnx,dny,dxdomain,dydomain,(snum-1)*cwsize+cwrank+1)
        print *, snum, cwsize, cwrank
        if (cwrank.eq.0) then 
          print *, 'final?'
        call combine_all(dnx,dny,param_all%dxdomain,param_all%dydomain,snum,param_all)
        endif
      endif
      call mpi_barrier(MPI_COMM_WORLD,ierr)
        if (cwrank.eq.0) then 
      write(*,*) 'Combine done for ens number', (snum-1)*cwsize+cwrank+1
        endif
      call mpi_barrier(MPI_COMM_WORLD,ierr)
!  enddo
!deallocate(iloof)
!call mpi_barrier(MPI_COMM_WORLD,ierr)
!call MPI_Finalize(ierr)
!          call save_ens
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  
!                 Calculate the Ensemble Mean                  !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!            do I=1,Nsta
!              aa=0.0d0
!              do K=1,Nens
!                aa=aa+old_ens(I,K)
!              enddo           
!              ens_mean(I)=aa*Nensd
!              do K=1,Nens
!                old_ens(I,K)=old_ens(I,K)-ens_mean(I)
!              enddo
!            enddo
            
!            Calculate the Spread among ensembles             !
!            bb=0.0d0
!            do  I=1,Nsta
!              aa=0.0d0
!              do K=1, Nens
!                 aa=aa+old_ens(I,K)**2.0
!              enddo
!              ens_mean(I)=aa/real(Nens-1)
!              bb=bb+ens_mean(I)
!            enddo
!
!            aa=sqrt(bb/real(Nsta))
            
!            write(401,'(i20,5d16.7)') aa,infl1,infl2,inflold,inflation
!            write(403,'(i10,6d12.4)') fctobserr,fctrmserr,anlobserr, &
!              anlrmserr,avgrmserr,anlrmserr/avgrmserr
     

!            open(98, file='IDobstmp.dat')
!            write(98, *) IDobs
!            close(98)
        !    print *, 'IDobs= ', IDobs
        !  close(401)

!        write(*,*) 'why'
!        open(11,file='kalman.par',status='unknown')
!        write(11,'(A)') '------Ensemble Kalman Filter Parameters-----'
!        write(11,'(A15,I5)') ' time step :   ', istep+7
        !write(11,'(A15,I3)') ' loof_num  :   ', iloof
!        close(11)

!!!!!!!!!!!!!!!!!!!!!!! NTIME UPDATA !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  
!            NTIMES = NTIME+NHIS                                  !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        if (cwrank.eq.0) then 
!          call update_metafile
!         call update_model_error
          write(*,*) 'NEXTSTEP'
        endif

!        call system('rm -f *_out.nc')
!        call system('rm -f after*')
        call system('rm -f before*')
!    close(*)
call mpi_barrier(MPI_COMM_WORLD,ierr)
call MPI_Finalize(ierr)
    
    end program enkf

!================   subrutine   =============================================c

!================   subrutine   =============================================cc
!================   subrutine   =============================================cc

      real(kind=8) function distst_Ph(iobs,iback,iil,param_all)

      use kalman, only      : T_IO 
      use background, only  : hdepth,cs_r,zeta_bg,lon_rho,lat_rho, &
                              lon_u,lat_u,lon_v,lat_v,iu,iv,itemp,isalt,izeta,s_rho,hc
      use observation, only : lon_obs,lat_obs,depth_obs
      use kalman, only      : pdomain

      implicit none

      integer, intent(in) :: iobs,iback,iil
      real(kind=8) :: angle,sigma,rdepth,hdiff,lon_back,lat_back
      integer      :: i
      TYPE(T_IO), intent(inout) :: param_all ! added by Y-Y. Kim
      if(pdomain(iil)%index_back(iback,1) == iu) then
        lon_back = lon_u(pdomain(iil)%index_back(iback,2),pdomain(iil)%index_back(iback,3))
        lat_back = lat_u(pdomain(iil)%index_back(iback,2),pdomain(iil)%index_back(iback,3))
      else if(pdomain(iil)%index_back(iback,1) == iv) then
        lon_back = lon_v(pdomain(iil)%index_back(iback,2),pdomain(iil)%index_back(iback,3))
        lat_back = lat_v(pdomain(iil)%index_back(iback,2),pdomain(iil)%index_back(iback,3))
      else
        lon_back = lon_rho(pdomain(iil)%index_back(iback,2),pdomain(iil)%index_back(iback,3))
        lat_back = lat_rho(pdomain(iil)%index_back(iback,2),pdomain(iil)%index_back(iback,3))
      endif

      call distance(distst_Ph,angle,lat_obs(iobs),lon_obs(iobs)&
              ,lat_back,lon_back)
      if (lat_obs(iobs).eq.lat_back .and. lon_obs(iobs).eq.lon_back)then
      distst_Ph=0.0
      endif
      sigma = - cs_r(pdomain(iil)%index_back(iback,4))
      rdepth = 0.0
      do i=1,param_all%Nens
         rdepth = rdepth + zeta_bg(pdomain(iil)%index_back(iback,2),pdomain(iil)%index_back(iback,3),i)
      enddo
      rdepth = rdepth/param_all%Nens
      rdepth = rdepth*(1+s_rho(pdomain(iil)%index_back(iback,4))&
              - hc*s_rho(pdomain(iil)%index_back(iback,4)) - hdepth(pdomain(iil)%index_back(iback,2),pdomain(iil)%index_back(iback,3))-hc)*cs_r(pdomain(iil)%index_back(iback,4)) 
      hdiff = abs(depth_obs(iobs)-rdepth)
      distst_Ph = sqrt(distst_Ph**2+(hdiff*param_all%cinf/param_all%hinf)**2)
      return
      end function distst_Ph
!=======================================================cc
       real(kind=8) function distst_hPh(iobs,jobs,param_all)

      use kalman, only      : T_IO
      use observation, only : lon_obs,lat_obs,depth_obs
      
      implicit none

      integer, intent(in) :: iobs,jobs
      real(kind=8) :: angle,sigma,rdepth,hdiff
      TYPE(T_IO), intent(inout) :: param_all ! added by Y-Y. Kim

      call distance(distst_hPh,angle,lat_obs(iobs),lon_obs(iobs)&
              ,lat_obs(jobs),lon_obs(jobs))
     
     if (lat_obs(iobs).eq.lat_obs(jobs) .and. lon_obs(iobs).eq.lon_obs(jobs))then
     distst_hPh=0.0
     endif

     hdiff = abs(depth_obs(iobs)-depth_obs(jobs))
     distst_hPh = sqrt(distst_hPh**2+(hdiff*param_all%cinf/param_all%hinf)**2)
     return
      end function distst_hPh


!==================================================================
       subroutine gaussj(a,n,np,b,m,mp)
       implicit none
       integer :: m,mp,n,np
       real(kind = 8) :: a(np,np),b(np,mp)
       !integer, parameter :: NMAX=900
       !integer :: i,icol,irow,j,k,l,ll,indxc(NMAX),indxr(NMAX),ipiv(NMAX)
       integer :: i,icol,irow,j,k,l,ll,indxc(n),indxr(n),ipiv(n)
       real(kind=8) :: big,dum,pivinv

       !if(n.gt.NMAX) write(*,*)'WARNING: increase NMAX in gaussj larger than ', n
    
       do j=1,n
         ipiv(j)=0
       enddo
       
       do i=1,n
         big=0.
         do j=1,n
          if(ipiv(j).ne.1)then
            do k=1,n
              if (ipiv(k).eq.0) then
                if (abs(a(j,k)).ge.big)then
                  big=abs(a(j,k))
                  irow=j
                  icol=k
                endif

              else if (ipiv(k).gt.1) then
              write(*,*)'AAA', ipiv(k) ,k
	      pause 'singular matrix in gaussj'
              endif
            enddo
          endif
         enddo
        ipiv(icol)=ipiv(icol)+1
        if (irow.ne.icol) then
          do l=1,n
            dum=a(irow,l)
            a(irow,l)=a(icol,l)
            a(icol,l)=dum
          enddo
          do l=1,m
            dum=b(irow,l)
            b(irow,l)=b(icol,l)
            b(icol,l)=dum
          enddo
        endif
        indxr(i)=irow
        indxc(i)=icol
        
	if (a(icol,icol).eq.0.) then
	write(*,*) 'BBB' ,icol,a(icol,icol) 
	pause 'singular matrix in gaussj'
        endif
	
        pivinv=1./a(icol,icol)
        a(icol,icol)=1.
        do l=1,n
          a(icol,l)=a(icol,l)*pivinv
        enddo
        do l=1,m
          b(icol,l)=b(icol,l)*pivinv
        enddo
        do ll=1,n
          if(ll.ne.icol)then
            dum=a(ll,icol)
            a(ll,icol)=0.
            do l=1,n
              a(ll,l)=a(ll,l)-a(icol,l)*dum
            enddo
            do l=1,m
              b(ll,l)=b(ll,l)-b(icol,l)*dum
            enddo
          endif
         enddo
        enddo
      do l=n,1,-1
        if(indxr(l).ne.indxc(l))then
          do k=1,n
            dum=a(k,indxr(l))
            a(k,indxr(l))=a(k,indxc(l))
            a(k,indxc(l))=dum
          enddo
        endif
      enddo
      return
      end subroutine gaussj

!-------------------------------------------------------------------
    
      real function gasdev(idum)
      implicit none
      integer, intent(in) :: idum
      integer,save :: iset
      real, save :: gset
      real :: fac,rsq,v1,v2,ran2
      DATA iset/0/
      if (iset.eq.0) then

       ! do
       !   v1=2.*ran2(idum)-1.
       !   v2=2.*ran2(idum)-1.
       !   rsq=v1**2+v2**2
       !   if(rsq<1. .and. rsq /=0.) exit
       ! enddo
1        v1=2.*ran2(idum)-1.
        v2=2.*ran2(idum)-1.
        rsq=v1**2+v2**2
        if(rsq.ge.1. .or. rsq.eq.0.)goto 1

        fac=sqrt(-2.*log(rsq)/rsq)
        gset=v1*fac
        gasdev=v2*fac
        iset=1
      else
        gasdev=gset
        iset=0
      endif
      return
      end function gasdev

      real function ran2(idum)
      implicit none
      integer, intent(inout)  :: idum
      integer, parameter :: IM1=2147483563,IM2=2147483399, IMM1=IM1-1, &
         IA1=40014,IA2=40692,IQ1=53668,IQ2=52774,IR1=12211,IR2=3791, &
         NTAB=32,NDIV=1+IMM1/NTAB
      real, parameter     :: AM=1./IM1, EPS=1.2e-7,RNMX=1.-EPS
      integer, save :: iv(NTAB), iy, idum2
      integer           :: j,k
      data idum2/123456789/, iv/NTAB*0/, iy/0/
      if (idum.le.0) then
        idum=max(-idum,1)
        idum2=idum
        do j=NTAB+8,1,-1
          k=idum/IQ1
          idum=IA1*(idum-k*IQ1)-k*IR1
          if (idum.lt.0) idum=idum+IM1
          if (j.le.NTAB) iv(j)=idum
         enddo
        iy=iv(1)
      endif
      k=idum/IQ1
      idum=IA1*(idum-k*IQ1)-k*IR1
      if (idum.lt.0) idum=idum+IM1
      k=idum2/IQ2
      idum2=IA2*(idum2-k*IQ2)-k*IR2
      if (idum2.lt.0) idum2=idum2+IM2
      j=1+iy/NDIV
      iy=iv(j)-idum2
      iv(j)=idum
      if(iy.lt.1)iy=iy+IMM1
      ran2=min(AM*iy,RNMX)
      return
      end function ran2

!***********************************************************
! this subroutine accesses the TRUTH run, generally shouldn't
! be available during an experiment (without cheating)
!      subroutine readref2(index,stin)
!      subroutine readref2(index)

!      use netcdf

!      implicit none

!      integer :: index,i,j,rcode
!      real(kind=8) :: stin(Nsta),q2gr(0:nx,0:ny),wrk(L,M)
!      integer :: start(3),count(3)
!      integer :: status,ncrefid2,varrefid2
!      character(48) :: fnam

!      fnam ='ref2.cdf'

!      status=nf_open(fnam,NF_NOWRITE,ncrefid2)
!      status=nf_inq_varid(ncrefid2,'q1',varrefid2)

!      start(1)=1
!      count(1)=L
!      start(2)=1
!      count(2)=M
!      start(3)=index
!      count(3)=1
!      rcode=nf_get_vara_double(ncrefid2,varrefid2, &
!                             start,count,wrk)
!      do j=0,ny
!        do i=0,nx
!          q2gr(i,j)=wrk(i+1,j+1)
!        enddo
!      enddo
!      call gr2st(q2gr,stin)
!      rcode=nf_close(ncrefid)


!      return
!      end subroutine readref2

!***********************************************************

!      subroutine plotstate_cdf(filename,stin)
!      subroutine plotstate_cdf(filename)

!      use netcdf

!      implicit none

!      integer :: i,ii,rcode,start(3),count(3),dims(3)
!      character(80) :: filename
!      real(kind=8) :: stin(Nsta),q2gr(0:nx,0:ny)
!
! Output state in cdf file
!
!      call st2gr(stin,q2gr)
!      start(1)=1
!      start(2)=1
!      count(1)= nx+1
!      count(2)= ny+1
!      ii =  nccre(filename,NCCLOB,rcode)
!      dims(1) = ncddef(ii,'x',nx+1,rcode)
!      dims(2) = ncddef(ii,'y',ny+1,rcode)
!      i = ncvdef(ii,'q1',NCDOUBLE,2,dims,rcode)
!      CALL ncendf(ii,rcode)
!      CALL ncvpt(ii,i, start, count, q2gr, rcode)
!      CALL ncclos(ii,rcode)

!      return
!      end subroutine plotstate_cdf



!***********************************************************

      subroutine print_err(errvec,ndim,text,err2)

      implicit none
      integer :: ndim,k
      real(kind=8) :: err1,err2,err3,errvec(ndim)
      character(20) :: text

      err1 = 0.0
      err2 = 0.0
      err3 = 0.0
      do k = 1, ndim
        if (abs(errvec(k)) .gt. err1) then
          err1 = abs(errvec(k))
        endif
        err2 = err2 + errvec(k) * errvec(k)
        err3 = err3 + abs(errvec(k))
      enddo
      err2 = sqrt(err2/ndim)
      err3 = err3 / ndim
      write (6,*) text,' max error=', err1, ' rms error=', &
                  err2,' mean error=', err3

      return
      end subroutine print_err

! *******************************************************************

!      subroutine subst(st_in1,st_in2,st_out)
 
!      use background, only : Nsta
!      implicit none

!      integer :: iil
!      real(kind=8), allocatable, dimension(:) :: st_in1,st_in2,st_out
!      integer :: i

!      if(.not.allocated(st_in1)) &
!        allocate(st_in1(Nsta),st_in2(Nsta),st_out(Nsta))
!      do i=1,pdomain(iil)%Nsta
!          st_out(i)=st_in1(i)-st_in2(i)
!      enddo

!      return
!      end subroutine subst
