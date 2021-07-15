# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# original mepl setting
#alias cdda1='cd /data1/auto/'
#alias cdda2='cd /data2/auto/'
#alias cdauto='cd /data1/auto/'
alias cdsrc='cd /data1/auto/src'
alias cdbak='cd /data1/auto/backup'
#alias cdum='cd /data1/nap/UM'
#alias cdnwpbak='cd /data1/auto/NWP/backup'
#alias ftpum='ftp 147.47.242.138'
#alias vnc='vncserver -geometry 1152x864 :9'
#alias vnck='vncserver -kill :9'
#alias mat='/usr/local/bin/matlab'
alias viold='vi /data1/auto/src/auto_old_all.csh'
alias cshold='csh /data1/auto/src/auto_old_all.csh'
alias vncserver='vncserver -geometry 1680x1050'

#Ferret 6.93
source /home/auto/MAMS/App/FERRET/ferret_paths.sh

#kwgrib
export PATH=$PATH:/home/auto/MAMS/App/kwgrib2

#openmpi (gcc, gfortran. not intel)
export PATH=/home/auto/MAMS/App/openmpi/intel_3_1_4/bin/:$PATH
export LD_LIBRARY_PATH=/home/auto/MAMS/App/openmpi/intel_3_1_4/lib/:$LD_LIBRARY_PATH

#HDF5 1.8.6
export PATH=$PATH:/home/auto/MAMS/App/hdf5/g_hdf5_1_8_6/bin/
export LD_LIBRARY_PATH=/home/auto/MAMS/App/hdf5/g_hdf5_1_8_6/lib/:$LD_LIBRARY_PATH

#netcdf 4.1.3
export PATH=/home/auto/MAMS/App/netcdf/g_netcdf_4_1_3/bin/:$PATH
export LD_LIBRARY_PATH=/home/auto/MAMS/App/netcdf/g_netcdf_4_1_3/lib/:$LD_LIBRARY_PATH


# Uncomment the following line if you don't like systemctl's auto-paging feature:

# export SYSTEMD_PAGER=

### User specific aliases and functions
### added by Anaconda3 2018.12 installer
### >>> conda init >>>

### !! Contents within this block are managed by 'conda init' !!

__conda_setup="$(CONDA_REPORT_ERRORS=false '/home/auto/MAMS/App/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/home/auto/MAMS/App/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/auto/MAMS/App/anaconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/home/auto/MAMS/App/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

### <<< conda init <<<
