#!/bin/bash


MAMS=/home/auto/MAMS
AUTO=$MAMS/Source/Shell/Auto
cd ${AUTO}

fulldate=`date --date="2 days ago" +%Y%m%d`
year=`echo $fulldate | cut -c1-4`
month=`echo $fulldate | cut -c5-6`
day=`echo $fulldate | cut -c7-8`

logdir=$MAMS/Log/$year/$fulldate
mkdir -p $logdir 

## NWP 1/10

#/bin/sh -xv ${AUTO}/Step_001_01_get_NOMADS_for_SBC.sh $fulldate $MAMS > $logdir/Step_001_01_get_NOMADS_for_SBC.log 
#/bin/sh -xv ${AUTO}/Step_001_02_convert_NOMADS_for_SBC.sh $fulldate $MAMS > $logdir/Step_001_02_convert_NOMADS_for_SBC.log 2>&1
#/bin/sh -xv ${AUTO}/Step_001_03_figure_NOMADS_for_check.sh $fulldate $MAMS > $logdir/Step_001_03_figure_NOMADS_for_check.log 2>&1
#/bin/sh -xv ${AUTO}/Step_001_04_get_UM_global_for_SBC.sh $fulldate $MAMS > $logdir/Step_001_04_get_UM_global_for_SBC.log 
#/bin/sh -xv ${AUTO}/Step_001_05_convert_UM_for_SBC.sh $fulldate $MAMS > $logdir/Step_001_05_convert_UM_for_SBC.log 2>&1
#/bin/sh -xv ${AUTO}/Step_001_06_figure_UM_for_check.sh $fulldate $MAMS > $logdir/Step_001_06_figure_UM_for_check.log 2>&1
#/bin/sh -xv ${AUTO}/Step_002_01_get_MyOcean_for_OBC.sh $fulldate $MAMS > $logdir/Step_002_01_get_MyOcean_for_OBC.log 2>&1
#/bin/sh -xv ${AUTO}/Step_003_01_get_OISST_for_DA.sh $fulldate $MAMS > $logdir/Step_003_01_get_OISST_for_DA.log 2>&1
#/bin/sh -xv ${AUTO}/Step_003_02_figure_OISST_for_check.sh $fulldate $MAMS > $logdir/Step_003_02_figure_OISST_for_check.log 2>&1
### Get CJD --> hanging on crontab (every hour)
#/bin/sh -xv ${AUTO}/Step_004_01_make_SBC_for_NWP.sh $fulldate $MAMS > $logdir/Step_004_01_make_SBC_for_NWP.log 2>&1
#/bin/sh -xv ${AUTO}/Step_005_01_make_OBC_for_NWP.sh $fulldate $MAMS > $logdir/Step_005_01_make_OBC_for_NWP.log 2>&1
#/bin/sh -xv ${AUTO}/Step_006_01_make_river_for_NWP.sh $fulldate $MAMS > $logdir/Step_006_01_make_river_for_NWP.log 2>&1
##/bin/sh -xv ${AUTO}/Step_007_01_make_tides_for_NWP.sh $fulldate $MAMS > $logdir/Step_007_01_make_tides_for_NWP.log 2>&1
/bin/sh -xv ${AUTO}/Step_008_01_make_ens_set_for_NWP.sh $fulldate $MAMS > $logdir/Step_008_01_make_ens_set_for_NWP.log 2>&1
/bin/sh -xv ${AUTO}/Step_008_02_make_EnOI_obs_for_NWP.sh $fulldate $MAMS > $logdir/Step_008_02_make_EnOI_obs_for_NWP.log 2>&1
/bin/sh -xv ${AUTO}/Step_008_03_EnOI_for_NWP.sh $fulldate $MAMS > $logdir/Step_008_03_EnOI_for_NWP.log 2>&1
/bin/sh -xv ${AUTO}/Step_009_01_make_ctrlfile_for_NWP.sh $fulldate $MAMS > $logdir/Step_009_01_make_ctrlfile_for_NWP.log 2>&1
/bin/sh -xv ${AUTO}/Step_010_01_preprocessing_NWP.sh $fulldate $MAMS > $logdir/Step_010_01_preprocessing_NWP.log 2>&1
/bin/sh -xv ${AUTO}/Step_011_01_run_NWP.sh $fulldate $MAMS > $logdir/Step_011_01_run_NWP.log 2>&1
/bin/sh -xv ${AUTO}/Step_012_01_backup_files.sh $fulldate $MAMS > $logdir/Step_012_01_backup_files.log 2>&1
/bin/sh -xv ${AUTO}/Step_012_02_figure_NWP.sh $fulldate $MAMS > $logdir/Step_012_02_figure_NWP.log 2>&1
/bin/sh -xv ${AUTO}/Step_013_01_preprocessing_LTRANS.sh $fulldate $MAMS > $logdir/Step_013_01_preprocessing_LTRANS.log 2>&1
/bin/sh -xv ${AUTO}/Step_013_02_make_locfile_for_LTRANS.sh $fulldate $MAMS > $logdir/Step_013_02_make_locfile_for_LTRANS.log 2>&1
/bin/sh -xv ${AUTO}/Step_013_03_make_ctrlfile_and_run_LTRANS.sh $fulldate $MAMS > $logdir/Step_013_03_make_ctrlfile_and_run_LTRANS.log 2>&1
#csh -xv ${AUTO}/Step_011_01_NWP_backup
#csh -xv ${AUTO}/Step_011_02_NWP_get_transport (Korea, Tsugaru, Soya, Taiwan, Kuroshio Intrusion)
#csh -xv ${AUTO}/Step_011_03_NWP_make_monthly 
#csh -xv ${AUTO}/Step_011_04_NWP_plot_temperature 
#csh -xv ${AUTO}/Step_011_05_NWP_plot_salinity 
#csh -xv ${AUTO}/Step_011_06_NWP_plot_current 
#csh -xv ${AUTO}/Step_011_07_NWP_plot_sealevel 
#csh -xv ${AUTO}/Step_011_08_NWP_cut_figure_for_homepage
#csh -xv ${AUTO}/Step_011_09_NWP_plot_drifters 

## ES 1/30
#csh -xv ${AUTO}/Step_009_ES_make_roms_SBC_from_NOMADS.csh
#csh -xv ${AUTO}/Step_009_01_read_NOMADS (East, West, South, North)
#csh -xv ${AUTO}/Step_009_02_read_grids
#csh -xv ${AUTO}/Step_009_03_horizontal_interpolation (temp, pres, hum, uwind, vwind, swrad)
#csh -xv ${AUTO}/Step_009_04_create_SBC_file
#csh -xv ${AUTO}/Step_010_ES_make_roms_OBC_from_NWP.csh
#csh -xv ${AUTO}/Step_010_01_read_ROMS_NWP (East, West, South, North)
#csh -xv ${AUTO}/Step_010_02_read_grids
#csh -xv ${AUTO}/Step_010_03_horizontal_interpolation (Temp, Salt, U, V, ssh)
#csh -xv ${AUTO}/Step_010_04_vertical_interpolation (Temp, Salt, U, V)
#csh -xv ${AUTO}/Step_010_05_create_OBC_file
#csh -xv ${AUTO}/Step_011_ES_make_roms_oceanin.csh
#csh -xv ${AUTO}/Step_012_ES_run_roms.csh
#csh -xv ${AUTO}/Step_012_01_ES_run_roms
#csh -xv ${AUTO}/Step_012_02_ES_DA_roms
#csh -xv ${AUTO}/Step_013_ES_postprocess.csh
#csh -xv ${AUTO}/Step_013_01_ES_backup
#csh -xv ${AUTO}/Step_013_02_ES_get_transport (Korea, Tsugaru, Soya)
#csh -xv ${AUTO}/Step_013_03_ES_make_monthly 
#csh -xv ${AUTO}/Step_013_04_ES_plot_temperature 
#csh -xv ${AUTO}/Step_013_05_ES_plot_salinity 
#csh -xv ${AUTO}/Step_013_06_ES_plot_current 
#csh -xv ${AUTO}/Step_013_07_ES_plot_sealevel 
#csh -xv ${AUTO}/Step_013_08_ES_cut_figure_for_homepage
#csh -xv ${AUTO}/Step_013_09_ES_plot_drifters 


## YS&ECS 1/30
#csh -xv ${AUTO}/Step_014_YSECS_make_roms_SBC_from_NOMADS.csh
#csh -xv ${AUTO}/Step_014_01_read_NOMADS (East, West, South, North)
#csh -xv ${AUTO}/Step_014_02_read_grids
#csh -xv ${AUTO}/Step_014_03_horizontal_interpolation (temp, pres, hum, uwind, vwind, swrad)
#csh -xv ${AUTO}/Step_014_04_create_SBC_file
#csh -xv ${AUTO}/Step_015_YSECS_make_roms_OBC_from_NWP.csh
#csh -xv ${AUTO}/Step_015_01_read_ROMS_NWP (East, West, South, North)
#csh -xv ${AUTO}/Step_015_02_read_grids
#csh -xv ${AUTO}/Step_015_03_horizontal_interpolation (Temp, Salt, U, V, ssh)
#csh -xv ${AUTO}/Step_015_04_vertical_interpolation (Temp, Salt, U, V)
#csh -xv ${AUTO}/Step_015_05_create_OBC_file
#csh -xv ${AUTO}/Step_016_YSECS_make_roms_oceanin.csh
#csh -xv ${AUTO}/Step_017_YSECS_run_roms.csh
#csh -xv ${AUTO}/Step_017_01_YSECS_run_roms
#csh -xv ${AUTO}/Step_017_02_YSECS_DA_roms
#csh -xv ${AUTO}/Step_018_YSECS_postprocess.csh
#csh -xv ${AUTO}/Step_018_01_YSECS_backup
#csh -xv ${AUTO}/Step_018_02_YSECS_get_transport (Korea, Tsugaru, Soya)
#csh -xv ${AUTO}/Step_018_03_YSECS_make_monthly 
#csh -xv ${AUTO}/Step_018_04_YSECS_plot_temperature 
#csh -xv ${AUTO}/Step_018_05_YSECS_plot_salinity 
#csh -xv ${AUTO}/Step_018_06_YSECS_plot_current 
#csh -xv ${AUTO}/Step_018_07_YSECS_plot_sealevel 
#csh -xv ${AUTO}/Step_018_08_YSECS_cut_figure_for_homepage





