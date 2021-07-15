#!/bin/bsh

echo "$*"
echo 'abc'
echo "$@"

author='Y-Y. Kim from SNU'

#usage --> command inputfiles outputfile

params=( "$@" )
lastnum=`echo "${#params[@]}-1"|bc` #last number of input file
if [[ $lastnum -lt 2 ]]; then
  echo "lastnum = "$lastnum
  echo "Why is the number of inputfiles smaller than 2? There might be misunderstanding. Bye!"
  exit
fi
echo "${params[0]}" > avginputlist 
for (( i=1; i<=lastnum-1; i++ )) do
  echo "${params[i]}" >> avginputlist 
done

today=`date`
run_cmd="matlab -nosplash -nojvm -nodisplay -nodesktop -r \"run('./avg_roms_output.m'); exit;\""

cat > avg_roms_output.m << EOF
%% make averaged file, like ncra

close all; clear all; clc;
addpath(genpath([matlabroot,'/toolbox/matlab/imagesci/'])); % add new netcdf path

fid = fopen('avginputlist')
for inputnum = 0:${lastnum}-1
  filenames{inputnum+1} = fgetl(fid);
  if (inputnum==0)
    combined_filenames=filenames{inputnum+1};
  else
    combined_filenames= [combined_filenames, ', ', filenames{inputnum+1}];
  end
end
fclose(fid)
num_inputfile = length(filenames);

filenames
outputname = '${params[${lastnum}]}'

%% create the averaged file
ncid=netcdf.create(outputname, '64BIT_OFFSET');

for numfile=1:num_inputfile
  info_input = ncinfo(filenames{numfile});
  num_dim = length(info_input.Dimensions);
  num_var = length(info_input.Variables);
  num_glo_att = length(info_input.Attributes);
  ncid_input = netcdf.open(filenames{numfile});
  if (numfile==1) % get dimension and variable information, define dimension and variable in the output file
    for dimi=1:num_dim  % define dimension
      dimid(dimi) = netcdf.defDim(ncid, info_input.Dimensions(dimi).Name, info_input.Dimensions(dimi).Length);
    end
    for atti=1:num_glo_att
      attname=info_input.Attributes(atti).Name;
      attvalue=info_input.Attributes(atti).Value;
      netcdf.putAtt(ncid, netcdf.getConstant('NC_GLOBAL'), attname, attvalue);
    end
    attname='averaged_file_list';
    attvalue=combined_filenames;
    netcdf.putAtt(ncid, netcdf.getConstant('NC_GLOBAL'), attname, attvalue);
    
    attname='averaged_date';
    attvalue='$today';
    netcdf.putAtt(ncid, netcdf.getConstant('NC_GLOBAL'), attname, attvalue);
    
    attname='Author';
    attvalue='$author';
    netcdf.putAtt(ncid, netcdf.getConstant('NC_GLOBAL'), attname, attvalue);
    
    for vari=1:num_var

      num_dim_in_var = info_input.Variables(vari).Dimensions;
      if (length(num_dim_in_var)>0) % dimensions exist
        dimensionless = 0;
        for vardimi=1:length(num_dim_in_var) % examine dimension in variable  
	  for dimi=1:num_dim
       	    if (strcmp(info_input.Dimensions(dimi).Name, info_input.Variables(vari).Dimensions(vardimi).Name)==1)
              if (exist('dimidset'))<1
	        dimidset = dimid(dimi);  % get dimension id
	      else
	        dimidset = [dimidset dimid(dimi)]; % get dimension id set for define variables
	      end
	    end
	  end
	end
      else % no dimension 
        dimensionless = 1;
      end
      switch(info_input.Variables(vari).Datatype)
        case('int8')
	  var_data_type='NC_SHORT';
	case('char')
	  var_data_type='NC_CHAR';
	case('int16')
	  var_data_type='NC_SHORT';
	case('int32')
	  var_data_type='NC_INT';
	case('single')
	  var_data_type='NC_FLOAT';
        case('double')
	  var_data_type='NC_DOUBLE';
      end
      if (dimensionless ==1)
        varid(vari) = netcdf.defVar(ncid, info_input.Variables(vari).Name, var_data_type, []);
      else
        varid(vari) = netcdf.defVar(ncid, info_input.Variables(vari).Name, var_data_type, dimidset);
      end
      num_att_in_var=length(info_input.Variables(vari).Attributes);
      for atti=1:num_att_in_var
        attname=info_input.Variables(vari).Attributes(atti).Name;
        attvalue=info_input.Variables(vari).Attributes(atti).Value;
	netcdf.putAtt(ncid,varid(vari),attname,attvalue);
      end
      clear dimidset
    end
    netcdf.endDef(ncid);
    netcdf.close(ncid)
  end
  
  for vari=1:num_var
    varid_input(vari) = netcdf.inqVarID(ncid_input, info_input.Variables(vari).Name);
    if(numfile==1)
      var_data{vari} = netcdf.getVar(ncid_input, varid_input(vari));
    else
      var_data{vari} = var_data{vari} + netcdf.getVar(ncid_input, varid_input(vari));
    end
  end
  
  netcdf.close(ncid_input);

end
ncid = netcdf.open(outputname, 'WRITE');
for vari=1:num_var
  varid(vari)=netcdf.inqVarID(ncid, info_input.Variables(vari).Name);  
  var_data{vari}=var_data{vari}/num_inputfile;
  info_input.Variables(vari).Name;
  size(var_data{vari});
  netcdf.putVar(ncid, varid(vari), squeeze(var_data{vari}));
end
netcdf.close(ncid);

EOF



echo $run_cmd
eval $run_cmd
