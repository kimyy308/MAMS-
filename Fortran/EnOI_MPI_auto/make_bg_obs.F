! modified and cleaned up on 2013 Oct. 03 by bjchoi
! 1. find 4 nearest grid points from the obs. point on tilted grid
! 
subroutine make_bg_obs(param_all)

use observation, only : Nobs,lon_obs,lat_obs,depth_obs,obsdata,obserr,Nloc,ind_obs,ind_idx
use background, only : bdata_obs,temp_bg,salt_bg,zeta_bg,u_bg,v_bg,mask_rho,izeta,itemp,isalt,iu,iv,len_xi_u,len_eta_u,len_s_rho,len_xi_v,len_eta_v,len_xi_rho,len_eta_rho, lon_rho,lat_rho,hdepth,cs_r,hc, s_rho
use kalman, only : pdomain,cwrank,T_IO

implicit none

integer             :: n,t,i,j

!============================================================
! Define variable for Interpolation routine
!------------------------------------------------------------

real(kind=8)        :: interp
integer             :: len_x, len_y, len_z
real(kind=8)        :: aa, t1, t2, t3_11, t3_12, t3_21, t3_22
real(kind=8)        :: sigma, h11, h12, h21, h22, z11, z12, z21, z22
integer             :: lat_1, lat_2, lon_1, lon_2, s_11u, s_12u
integer             :: s_21u, s_22u, s_11d, s_12d, s_21d, s_22d
integer             :: mask11,mask12,mask21,mask22
integer             :: i_min, j_min
real                :: ddist,ddist_min, dx,dy
real(kind=8)        :: s11,s12,s21,s22,d11u,d11d,d12u,d12d,d21u,d21d,d22u,d22d
real(8)             :: x1,x2,y1,y2,xx11,xx12,xx21,xx22,yy11,yy12,yy21,yy22
real(8)             :: aa1,aa2,aa3,aa4,bb1,bb2,bb3,bb4
real(8)             :: minx,maxx,miny,maxy

real(8),allocatable,dimension(:,:) :: bdata_obst, weight
real(8),allocatable,dimension(:)   :: lon_obst,lat_obst,depth_obst,obsdatat,np_dist
integer,allocatable,dimension(:)   :: ind_obst,ind_idxt,obserrt,np_lat,np_lon 
integer                            :: bd_index

TYPE(T_IO), intent(inout) :: param_all ! added by Y-Y. Kim

!============================================================


!====================================================
! Allocation the state vector at observation position
!----------------------------------------------------
    if(allocated(bdata_obs)) then
      deallocate(bdata_obs)
    endif
    allocate(bdata_obs(Nobs,param_all%Nens))
    if(allocated(lon_obst)) then
      deallocate(lon_obst,lat_obst,depth_obst,obsdatat,ind_obst,ind_idxt)
    endif
    if(allocated(ind_idx)) then
      deallocate(ind_idx)
    endif
    allocate(lon_obst(Nobs),lat_obst(Nobs),depth_obst(Nobs),&
               obsdatat(Nobs),ind_obst(Nobs),ind_idx(Nobs),&
               ind_idxt(Nobs),bdata_obst(Nobs,param_all%Nens))
    if(allocated(np_dist)) then
      deallocate(np_dist,np_lon,np_lat,weight)
    endif
    allocate(np_dist(8),np_lon(8),np_lat(8),weight(2,2))

    ind_idx=0       ! -1 for obs. data near the boundary, 1 for the interior
    bdata_obs=0     ! H Xb; interpolated model(background) data on obs. point  
!====================================================

     do t=1,param_all%Nens
       do n=1,Nobs
        if (ind_obs(n) == iu) then
           len_x = len_xi_u
           len_y = len_eta_u
           len_z = len_s_rho
        elseif (ind_obs(n) == iv) then
           len_x = len_xi_v
           len_y = len_eta_v
           len_z = len_s_rho
        else
           len_x = len_xi_rho
           len_y = len_eta_rho
           len_z = len_s_rho
           if (ind_obs(n) == izeta) len_z = 0
        endif

        ! find the nearest model grid point from an obs. point           
        ddist_min= 9999999.9
        do i =1,len_x
          do j = 1, len_y
           dx = (lon_rho(i,j)-lon_obs(n))*cos(lat_rho(i,j))
           dy = (lat_rho(i,j)-lat_obs(n))
           ddist = sqrt(dx**2 +dy**2)
           if ((ddist < ddist_min).and. abs(temp_bg(i,j,len_s_rho,t))< 999.9) then
             i_min = i
             j_min = j
             ddist_min = ddist
           endif
          enddo
        enddo

        ! estimate distance to the nearest 8 points, np_dist = nearest point_distance         
           dx = (lon_rho(i_min,j_min+1)-lon_obs(n))*cos(lat_rho(i_min,j_min))
           dy = (lat_rho(i_min,j_min+1)-lat_obs(n))
           np_dist(1) = sqrt(dx**2 +dy**2)
	     np_lon(1) = i_min
	     np_lat(1) = j_min+1
	
           dx = (lon_rho(i_min,j_min-1)-lon_obs(n))*cos(lat_rho(i_min,j_min))
           dy = (lat_rho(i_min,j_min-1)-lat_obs(n))
           np_dist(2) = sqrt(dx**2 +dy**2)
	     np_lon(2)  = i_min
	     np_lat(2)  = j_min-1

           dx = (lon_rho(i_min+1,j_min)-lon_obs(n))*cos(lat_rho(i_min,j_min))
           dy = (lat_rho(i_min+1,j_min)-lat_obs(n))
           np_dist(3) = sqrt(dx**2 +dy**2)
	     np_lon(3)  = i_min+1
	     np_lat(3)  = j_min
	
           dx = (lon_rho(i_min+1,j_min+1)-lon_obs(n))*cos(lat_rho(i_min,j_min))
           dy = (lat_rho(i_min+1,j_min+1)-lat_obs(n))
           np_dist(4) = sqrt(dx**2 +dy**2)
	     np_lon(4)  = i_min+1
	     np_lat(4)  = j_min+1
	
           dx = (lon_rho(i_min+1,j_min-1)-lon_obs(n))*cos(lat_rho(i_min,j_min))
           dy = (lat_rho(i_min+1,j_min-1)-lat_obs(n))
           np_dist(5) = sqrt(dx**2 +dy**2)
	     np_lon(5)  = i_min+1
	     np_lat(5)  = j_min-1

           dx = (lon_rho(i_min-1,j_min)-lon_obs(n))*cos(lat_rho(i_min,j_min))
           dy = (lat_rho(i_min-1,j_min)-lat_obs(n))
           np_dist(6) = sqrt(dx**2 +dy**2)
	     np_lon(6)  = i_min-1
	     np_lat(6)  = j_min
	
           dx = (lon_rho(i_min-1,j_min+1)-lon_obs(n))*cos(lat_rho(i_min,j_min))
           dy = (lat_rho(i_min-1,j_min+1)-lat_obs(n))
           np_dist(7) = sqrt(dx**2 +dy**2)
	     np_lon(7)  = i_min-1
	     np_lat(7)  = j_min+1
	
           dx = (lon_rho(i_min-1,j_min-1)-lon_obs(n))*cos(lat_rho(i_min,j_min))
           dy = (lat_rho(i_min-1,j_min-1)-lat_obs(n))
           np_dist(8) = sqrt(dx**2 +dy**2)
	     np_lon(8)  = i_min-1
	     np_lat(8)  = j_min-1
           ! find nearest 3 points = sorting problem. good!
           do i = 1, 3
            do j = i+1, 8
             if ( np_dist(j) < np_dist(i) ) then
	          ddist = np_dist(i)       ! temporary 
			  lon_1 = np_lon(i) 
			  lat_1 = np_lat(i)
		      np_dist(i) = np_dist(j)  ! update
	          np_lon(i)  = np_lon(j)
	          np_lat(i)  = np_lat(j)
			  np_dist(j) = ddist       ! replace
			  np_lon(j)  = lon_1
                np_lat(j)  = lat_1 
             endif
            enddo
		 enddo	      
           ! assign grid points encompassing an obs. point
	     lon_1 = min( i_min, np_lon(1), np_lon(2), np_lon(3) )
	     lon_2 = max( i_min, np_lon(1), np_lon(2), np_lon(3) )
	     lat_1 = min( j_min, np_lat(1), np_lat(2), np_lat(3) )
	     lat_2 = max( j_min, np_lat(1), np_lat(2), np_lat(3) )
           if ( (lon_2 - lon_1) .ne. 1 .or. (lat_2 - lat_1) .ne. 1 ) then             
		   if( lon_rho(i_min,j_min) .gt. lon_obs(n) ) then
		     lon_1 = i_min - 1
			 lon_2 = i_min
		   else
		     lon_1 = i_min
			 lon_2 = i_min + 1
		   endif	   
             if ( lat_rho(i_min,j_min) .gt. lat_obs(n) ) then
               lat_2 = j_min
	         lat_1 = j_min - 1
	       else
               lat_2 = j_min + 1
			 lat_1 = j_min 
	       endif
		   !write(*,*) ' error in finding nearest grid points from an observation point '
		   !write(*,*) 'ensemble number =  ', t, ' observation number  = ', n
	       !ind_idx(n)=-1
	     endif
		  
        ! obsvation data should be away from land or open boundary
	  ! <are the following lines correct ? bjchoi  
        !if ((temp_bg(lon_1,lat_1,len_s_rho,t)+temp_bg(lon_2,lat_2,len_s_rho,t)+temp_bg(lon_1,lat_2,len_s_rho,t)+temp_bg(lon_2,lat_1,len_s_rho,t))>999.9) then
        !   ind_idx(n)=1
	  !else
        !   ind_idx(n)=-1 
        !endif

	  dx = (lon_rho(lon_1,lat_1)-lon_obs(n))*cos(lat_rho(lon_1,lat_1))
        dy = (lat_rho(lon_1,lat_1)-lat_obs(n))
        np_dist(1) = sqrt(dx**2 +dy**2)
	  dx = (lon_rho(lon_1,lat_2)-lon_obs(n))*cos(lat_rho(lon_1,lat_2))
        dy = (lat_rho(lon_1,lat_2)-lat_obs(n))
        np_dist(2) = sqrt(dx**2 +dy**2)
	  dx = (lon_rho(lon_2,lat_1)-lon_obs(n))*cos(lat_rho(lon_2,lat_1))
        dy = (lat_rho(lon_2,lat_1)-lat_obs(n))
        np_dist(3) = sqrt(dx**2 +dy**2)
	  dx = (lon_rho(lon_2,lat_2)-lon_obs(n))*cos(lat_rho(lon_2,lat_2))
        dy = (lat_rho(lon_2,lat_2)-lat_obs(n))
        np_dist(4) = sqrt(dx**2 +dy**2)	  
        t1 = np_dist(1) +  np_dist(2) +  np_dist(3) + np_dist(4)   ! sum of distance
        t2 = 1.0/t1 
	  weight(1,1) = np_dist(1) * t2
	  weight(1,2) = np_dist(2) * t2
	  weight(2,1) = np_dist(3) * t2
	  weight(2,2) = np_dist(4) * t2

!------------------------------- initial -------------------------------      
         z11 = zeta_bg(lon_1,lat_1,t)   ! zeta
         z12 = zeta_bg(lon_1,lat_2,t)
         z21 = zeta_bg(lon_2,lat_1,t)
         z22 = zeta_bg(lon_2,lat_2,t)
         h11 = hdepth(lon_1,lat_1)      ! bottom topo
         h12 = hdepth(lon_1,lat_2)
         h21 = hdepth(lon_2,lat_1)
         h22 = hdepth(lon_2,lat_2)
         i=1
         d11u = -cs_r(i+1)*(h11-hc) -s_rho(i+1)*hc +z11*(1+s_rho(i+1))
         d11d = -cs_r(i)*(h11-hc) -s_rho(i)*hc +z11*(1+s_rho(i))
         d12u = -cs_r(i+1)*(h12-hc) -s_rho(i+1)*hc +z12*(1+s_rho(i+1))
         d12d = -cs_r(i)*(h12-hc) -s_rho(i)*hc +z12*(1+s_rho(i))
         d21u = -cs_r(i+1)*(h21-hc) -s_rho(i+1)*hc +z21*(1+s_rho(i+1))
         d21d = -cs_r(i)*(h21-hc) -s_rho(i)*hc +z21*(1+s_rho(i))
         d22u = -cs_r(i+1)*(h22-hc) -s_rho(i+1)*hc +z22*(1+s_rho(i+1))
         d22d = -cs_r(i)*(h22-hc) -s_rho(i)*hc +z22*(1+s_rho(i))

         s_11u = i+1
         s_11d = i
         t3_11 = (depth_obs(n) - d11u) / (d11d - d11u)
         s_12u = i+1
         s_12d = i
         t3_12 = (depth_obs(n) - d12u) / (d12d - d12u)
         s_21u = i+1
         s_21d = i
         t3_21 = (depth_obs(n) - d21u) / (d21d - d21u)
         s_22u = i+1
         s_22d = i
         t3_22 = (depth_obs(n) - d22u) / (d22d - d22u)

!------  Calculate weight and interpolate the variable --------------------
!--------using nearest 4 points -------------------------------------------
         if (ind_obs(n) == izeta) then
           t1 = (lon_obs(n) - lon_rho(lon_1,1)) / (lon_rho(lon_2,1) - lon_rho(lon_1,1))
           t2 = (lat_obs(n) - lat_rho(1,lat_1)) / (lat_rho(1,lat_2) - lat_rho(1,lat_1))
           interp =  weight(1,1)*zeta_bg(lon_1,lat_1,t) &
                   + weight(2,1)*zeta_bg(lon_2,lat_1,t) &
                   + weight(2,2)*zeta_bg(lon_2,lat_2,t) &
                   + weight(1,2)*zeta_bg(lon_1,lat_2,t)
         elseif (ind_obs(n) == itemp) then
           do i=1,len_z-1
             d11u = -cs_r(i+1)*(h11-hc) -s_rho(i+1)*hc +z11*(1+s_rho(i+1))
             d11d = -cs_r(i)*(h11-hc) -s_rho(i)*hc +z11*(1+s_rho(i))
             d12u = -cs_r(i+1)*(h12-hc) -s_rho(i+1)*hc +z12*(1+s_rho(i+1))
             d12d = -cs_r(i)*(h12-hc) -s_rho(i)*hc +z12*(1+s_rho(i))
             d21u = -cs_r(i+1)*(h21-hc) -s_rho(i+1)*hc +z21*(1+s_rho(i+1))
             d21d = -cs_r(i)*(h21-hc) -s_rho(i)*hc +z21*(1+s_rho(i))
             d22u = -cs_r(i+1)*(h22-hc) -s_rho(i+1)*hc +z22*(1+s_rho(i+1))
             d22d = -cs_r(i)*(h22-hc) -s_rho(i)*hc +z22*(1+s_rho(i))
             if (d11d >= depth_obs(n)) then
               s_11u = i+1
               s_11d = i
               t3_11 = (depth_obs(n) - d11u) / (d11d - d11u)
             endif
             if (d12d >= depth_obs(n)) then
               s_12u = i+1
               s_12d = i
               t3_12 = (depth_obs(n) - d12u) / (d12d - d12u) 
             endif
             if (d21d >= depth_obs(n)) then
               s_21u = i+1
               s_21d = i
               t3_21 = (depth_obs(n) - d21u) / (d21d - d21u)
             endif
             if (d22d >= depth_obs(n)) then
               s_22u = i+1
               s_22d = i
               t3_22 = (depth_obs(n) - d22u) / (d22d - d22u) 
             endif
           enddo
           if (depth_obs(n) == 0) then
             s11 = temp_bg(lon_1,lat_1,len_z,t)
             s12 = temp_bg(lon_1,lat_2,len_z,t)
             s21 = temp_bg(lon_2,lat_1,len_z,t)
             s22 = temp_bg(lon_2,lat_2,len_z,t)
           else
           s11 = t3_11*temp_bg(lon_1,lat_1,s_11d,t)+(1-t3_11)*temp_bg(lon_1,lat_1,s_11u,t)
           s12 = t3_12*temp_bg(lon_1,lat_2,s_12d,t)+(1-t3_12)*temp_bg(lon_1,lat_2,s_12u,t)
           s21 = t3_21*temp_bg(lon_2,lat_1,s_21d,t)+(1-t3_21)*temp_bg(lon_2,lat_1,s_21u,t)
           s22 = t3_22*temp_bg(lon_2,lat_2,s_22d,t)+(1-t3_22)*temp_bg(lon_2,lat_2,s_22u,t)
           endif
           interp = weight(1,1)*s11 + weight(2,1)*s21 + weight(2,2)*s22 + weight(1,2)*s12
         elseif (ind_obs(n) == isalt) then
           do i=1,len_z-1
             d11u = -cs_r(i+1)*(h11-hc) -s_rho(i+1)*hc +z11*(1+s_rho(i+1))
             d11d = -cs_r(i)*(h11-hc) -s_rho(i)*hc +z11*(1+s_rho(i))
             d12u = -cs_r(i+1)*(h12-hc) -s_rho(i+1)*hc +z12*(1+s_rho(i+1))
             d12d = -cs_r(i)*(h12-hc) -s_rho(i)*hc +z12*(1+s_rho(i))
             d21u = -cs_r(i+1)*(h21-hc) -s_rho(i+1)*hc +z21*(1+s_rho(i+1))
             d21d = -cs_r(i)*(h21-hc) -s_rho(i)*hc +z21*(1+s_rho(i))
             d22u = -cs_r(i+1)*(h22-hc) -s_rho(i+1)*hc +z22*(1+s_rho(i+1))
             d22d = -cs_r(i)*(h22-hc) -s_rho(i)*hc +z22*(1+s_rho(i))
             if (d11d >= depth_obs(n)) then
               s_11u = i+1
               s_11d = i
               t3_11 = (depth_obs(n) - d11u) / (d11d - d11u)
             endif
             if (d12d >= depth_obs(n)) then
               s_12u = i+1
               s_12d = i
               t3_12 = (depth_obs(n) - d12u) / (d12d - d12u) 
             endif
             if (d21d >= depth_obs(n)) then
               s_21u = i+1
               s_21d = i
               t3_21 = (depth_obs(n) - d21u) / (d21d - d21u)
             endif
             if (d22d >= depth_obs(n)) then
               s_22u = i+1
               s_22d = i
               t3_22 = (depth_obs(n) - d22u) / (d22d - d22u) 
             endif
           enddo
           if (depth_obs(n) == 0) then
             s11 = salt_bg(lon_1,lat_1,len_z,t)
             s12 = salt_bg(lon_1,lat_2,len_z,t)
             s21 = salt_bg(lon_2,lat_1,len_z,t)
             s22 = salt_bg(lon_2,lat_2,len_z,t)
           else
           s11 = t3_11*salt_bg(lon_1,lat_1,s_11d,t)+(1-t3_11)*salt_bg(lon_1,lat_1,s_11u,t)
           s12 = t3_12*salt_bg(lon_1,lat_2,s_12d,t)+(1-t3_12)*salt_bg(lon_1,lat_2,s_12u,t)
           s21 = t3_21*salt_bg(lon_2,lat_1,s_21d,t)+(1-t3_21)*salt_bg(lon_2,lat_1,s_21u,t)
           s22 = t3_22*salt_bg(lon_2,lat_2,s_22d,t)+(1-t3_22)*salt_bg(lon_2,lat_2,s_22u,t)                   
           endif
           interp = weight(1,1)*s11 + weight(2,1)*s21 + weight(2,2)*s22 + weight(1,2)*s12
         endif
         ! obs. data next to the open boundary and land cells are excluded      
         if (lon_1==0 .or. lat_1==0 .or. lon_1==len_x .or. lat_1==len_y) then
            ind_idx(n)=-1
         elseif (mask_rho(lon_1,lat_1)*mask_rho(lon_1,lat_2) &
                *mask_rho(lon_2,lat_1)*mask_rho(lon_2,lat_2) == 0) then
            ind_idx(n)=-1
         elseif (interp.lt.-50.0 .or. interp .gt. 50.0) then
            ind_idx(n)=-1
         else
            if (ind_idx(n).ne.-1) then
              ind_idx(n)=1
              bdata_obs(n,t)=interp
            endif
         endif

       enddo ! end of n=1,Nobs
     enddo   ! end of t=1,Nens

     bd_index=0
     do n=1,Nobs
        if (ind_idx(n).lt.0) then
           bd_index=bd_index+1               ! increase the number of bad data index
        else
           lon_obst(n-bd_index)=lon_obs(n)
           lat_obst(n-bd_index)=lat_obs(n)
           depth_obst(n-bd_index)=depth_obs(n)
           obsdatat(n-bd_index)=obsdata(n)
           ind_obst(n-bd_index)=ind_obs(n)
           ind_idxt(n-bd_index)=ind_idx(n)
           bdata_obst(n-bd_index,:)=bdata_obs(n,:)
        endif
     enddo

     Nobs=Nobs-bd_index
     Nloc=Nloc-bd_index

     if (Nobs==0) then
       write(*,*) '  No obs. for CPU',cwrank
     elseif (Nobs .gt. 0) then
       lon_obs(1:Nobs)=lon_obst(1:Nobs)
       lat_obs(1:Nobs)=lat_obst(1:Nobs)
       depth_obs(1:Nobs)=depth_obst(1:Nobs)
       obsdata(1:Nobs)=obsdatat(1:Nobs)
       ind_obs(1:Nobs)=ind_obst(1:Nobs)
       ind_idx(1:Nobs)=ind_idxt(1:Nobs)
       bdata_obs(1:Nobs,:)=bdata_obst(1:Nobs,:)
       write(*,*) '  ',Nobs,' obs. for CPU',cwrank    
     endif 
     deallocate(lon_obst,lat_obst,depth_obst,obsdatat,ind_obst,ind_idxt,bdata_obst)

end subroutine make_bg_obs
