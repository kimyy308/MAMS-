!======================================================
! Save Analysis from Ensemble Kalman Filter
! Programmed by Y.H. KIM in Apri., 2006
! mailto:yhkim@ocean.snu.ac.kr
! Note : To prepare the Ensemble Kalman Filter
!======================================================

 subroutine copy_nc(infile,outfile)

 character(800) :: infile,outfile
 character(256) :: command

 command = 'cp -rf   '//trim(infile)//' '//trim(outfile)

 write(*,*) trim(infile)
 write(*,*) trim(outfile)
 write(*,*) trim(command)

 call system(trim('ls -l *.txt'))

 call system(trim(command))
 end subroutine copy_nc
