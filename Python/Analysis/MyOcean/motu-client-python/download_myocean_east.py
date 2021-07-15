# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import sys
import os
import datetime
LIBRARIES_PATH = os.path.join(os.path.dirname(__file__), './lib3')
sys.path.append(LIBRARIES_PATH)  
import motu_api

class C:
    pass
today= datetime.datetime(2019,1,1,12)
lag_max=6
bdry_name='east'
_east = C()
_east.auth_mode = motu_api.AUTHENTICATION_MODE_CAS
_east.proxy_server = None
_east.outputWritten = None
_east.describe = None
_east.size = None
_east.sync = None
_east.console_mode = None
_east.socket_timeout = None
_east.block_size = 65536
_east.user = 'ykim7'
_east.pwd  = 'Mepl036$'
_east.motu = 'http://nrtcmems.mercator-ocean.fr/mis-gateway-servlet/Motu'
_east.service_id = 'http://purl.org/myocean/ontology/service/database#GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS'
_east.product_id = 'global-analysis-forecast-phy-001-024'
_east.longitude_min = 162
_east.longitude_max = 162
_east.latitude_min  = 15
_east.latitude_max  = 52
_east.depth_min     = 0.494
_east.depth_max     = 5727.9171
_east.variable      = ['zos', 'so', 'thetao', 'uo', 'vo']

work_dir=os.getcwd()
data_dir=work_dir+'/'+bdry_name

for lag_day in range(0,lag_max):
  dstr_time=today + datetime.timedelta(lag_day)
  this_time=dstr_time.strftime("%Y%m%d")
  fname = 'myocean_'+bdry_name+'_'+this_time+'.nc'

  if os.path.isfile( data_dir+'/'+fname ):
  
     print( data_dir+'/'+fname )
  else:
     _east.date_min      = dstr_time.strftime("%Y-%m-%d %H:%M:%S")
     _east.date_max      = _east.date_min
     _east.out_dir       = './'
     _east.out_name      = fname

     motu_api.execute_request(_east)
#    ${python} ${work_dir}/motu-client.py -u ykim7 -p Mepl036$ -m http://nrtcmems.mercator-ocean.fr/mis-gateway-servlet/Motu -s http://purl.org/myocean/ontology/service/database#GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS -d global-analysis-forecast-phy-001-024 -x ${x_min} -X ${x_max} -y ${y_min} -Y ${y_max} -t "${dstr_time} 12:00:00" -T "${dstr_time} 12:00:00" -z ${z_min} -Z ${z_max} ${var_str} -o ./ -f myocean_${bdry_name}_${this_time}.nc
     print( '\n '+bdry_name+' '+dstr_time.strftime("%Y-%m-%d")+' = '+str(lag_day)+'\n')
     os.system('ncrename -v thetao,temperature -v so,salinity -v uo,u -v vo,v -v zos,ssh -v time,time_counter -d time,time_counter -O ./'+fname)
  
     os.system('mv -f '+fname+' '+data_dir)
     os.system('ls '+data_dir+'/'+fname)
