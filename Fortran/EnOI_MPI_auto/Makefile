#
F90	= /usr/local/pgi/linux86-64/19.4/mpi/openmpi-3.1.3/bin/mpif90 # mepl2
#F90	= /scratch/software/iREMB-U/PGI/PGI_16.10/linux86-64/16.10/bin/pgf90
#F90	= /scratch/software/iREMB-U/PGI/PGI_16.10/linux86-64/16.10/mpi/openmpi-1.10.2/bin/mpif90
#F90	= /opt/pgi_904/linux86-64/9.0/mpi/mpich/bin/mpif90
#F90	= /scratch/software/iREMB-U/PGI/PGI_16.10_Tools/MVAPICH2/2.2/bin/mpif90
#F90	= /scratch/software/iREMB-U/PGI/PGI_16.10_Tools/OPENMPI/1.8.5/bin/mpif90
#F90	= /scratch/software/iREMB-U/PGI/PGI_16.10_Tools/MPICH/3.3a2/bin/mpif90
# for Sparc and Ultrasparc
DBG =  -fast -tp p7-64 
#DBG =  -O
#DBG	= -q32 -O3 -qarch=pwr5 -qtune=pwr5 -qstrict -bmaxdata:0x80000000#
LDFLAGS = ${DBG}
CFLAGS = ${DBG} -I/usr/local/netcdf/pg_netcdf_4_1_3/include
#CFLAGS = -I/scratch/software/iREMB-U/PGI/PGI_16.10_Tools/NETCDF4_FORTRAN_MP_3.3a2/4.4.2/include
#CFLAGS = -I/scratch/software/iREMB-U/PGI/PGI_16.10_Tools/NETCDF4_FORTRAN_OP_1.8.5/4.4.2/include
#CFLAGS = -I/scratch/software/iREMB-U/PGI/PGI_16.10_Tools/NETCDF4_FORTRAN_MV2_2.2/4.4.2/include
#CFLAGS = -I/home/kosu02/install_folder/netcdf3/include
#
KLMOBJS   = mod_kinds.o decode_line.o copy_nc.o kalman.o read_bg.o read_grid.o get_background_p.o get_observation_all.o get_obs_info.o distance.o  save_anal.o main_all.o combine_all.o cubic_spline.o save_dummy.o make_bg_obs.o 
#
#IBM
#llibs=  -L/home/app/pgi/netcdf3/lib  -lnetcdf  # original of JNU
llibs=  -L/usr/local/netcdf/pg_netcdf_4_1_3/lib  -lnetcdf -lnetcdff
#llibs=  -L/scratch/software/iREMB-U/PGI/PGI_16.10_Tools/NETCDF4_FORTRAN_OP_1.8.5/4.4.2/lib -lnetcdff
#llibs=  -L/home/kosu02/install_folder/netcdf3/lib -lnetcdf -lnetcdff
#
.SUFFIXES: .o .f .F
#
.f.o: 
	${F90} -c ${CFLAGS} $*.f
#
.F.o:
	${F90} -Mfreeform ${CFLAGS} -c $<
#
main: ${KLMOBJS}
	${F90} ${LDFLAGS} -o auto01_enoi ${KLMOBJS} $(llibs) 
#
clean: 
	rm -f *.o *.mod *~

