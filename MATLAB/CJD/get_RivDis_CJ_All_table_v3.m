%--------------------------------------------------------------------------
%       get Changiang River Discharge 
%
% v1   : extract the 'datong' discharge data from url, 04Mar2014
% v1.1 : if empty cell exists, display 'NaN', bug modification on 28Nov2014
% v2   : Add subfunction 'getTableFromWeb_mod.m' srcipt, modification on 29Aug2016
% v3   : use regexp, read num from char., 13Feb2019
%        Modified by CSKIM, 
%--------------------------------------------------------------------------
close all; clear all; clc;

var    ={'"stnm":"','"tm":', '"z":"',      '"q":"',    '"oq":"'};
var_out={'St.',    'Time',   'WaterLevel', 'RivDis1',  'RivDis2'};

T = clock;
YM  = sprintf('%04g%02g',   T(1:2)) ; 
%%
dir_out = ['/home/auto/MAMS/Data/CJD/', num2str(T(1)), '/'];
if isdir(dir_out) ~= 1
mkdir(dir_out);
end

outfile = [dir_out,'discharge_',YM,'.mat'];
idc = dir(outfile); 
ic = 0;
if length(idc)> 0 
disp(['load MAT file : ',outfile])
load(outfile);
ic = length(CJ);
end

%%
url= strcat(['http://www.cjh.com.cn/sqindex.html']);
html = urlread(url);
% web(url); myTableData = getTableFromWeb
%use regular expressions to remove undesired markup.
pop1 = regexp(html,'var sssq = [(.*];)','tokens');
% get strs
% {"oq":"0","q":"4860","rvnm":"长江","stcd":"60105400","stnm":"寸滩","tm":1549983600000,"wptn":"5","z":"169.97"},{"oq":"0","q":"1640","rvnm":"乌江","stcd":"60803000","stnm":"武隆","tm":1549983600000,"wptn":"5","z":"173.87"},{"oq":"0","q":"7830","rvnm":"长江","stcd":"60107300","stnm":"宜昌","tm":1549983600000,"wptn":"4","z":"40.33"},{"oq":"0","q":"6800","rvnm":"长江","stcd":"60108300","stnm":"沙市","tm":1549983600000,"wptn":"5","z":"30.4"},{"oq":"0","q":"0","rvnm":"长江","stcd":"60111200","stnm":"城陵矶(莲)","tm":1549983600000,"wptn":"6","z":"21.39"},{"oq":"0","q":"11900","rvnm":"长江","stcd":"60112200","stnm":"汉口","tm":1549983600000,"wptn":"4","z":"14.91"},{"oq":"0","q":"12400","rvnm":"长江","stcd":"60113400","stnm":"九江","tm":1549983600000,"wptn":"6","z":"9.67"},{"oq":"0","q":"16100","rvnm":"长江","stcd":"60115000","stnm":"大通","tm":1549983600000,"wptn":"4","z":"5.81"},{"oq":"0","q":"4820","rvnm":"洞庭湖","stcd":"61512000","stnm":"城陵矶(七)","tm":1549983600000,"wptn":"5","z":"21.43"},{"oq":"0","q":"2710","rvnm":"鄱阳湖","stcd":"62601600","stnm":"湖口","tm":1549980000000,"wptn":"6","z":"8.96"},{"oq":"0","q":"0","rvnm":"长江","stcd":"60107000","stnm":"茅坪(二)","tm":1549984800000,"wptn":"4","z":"169.722"},{"oq":"5780","q":"0","rvnm":"长江","stcd":"60106980","stnm":"三峡水库","tm":1549983600000,"wptn":"5","z":"169.73"},{"oq":"0","q":"0","rvnm":"汉江","stcd":"61802500","stnm":"龙王庙","tm":1549983600000,"wptn":"6","z":"154.56"},{"oq":"777","q":"154","rvnm":"汉江","stcd":"61802700","stnm":"丹江口水库","tm":1549972800000,"wptn":"4","z":"154.56"}];
strs = pop1{1,1}{1,1};
%%
for k = 1:length(var)
    
% StrComp  = '"stnm":"';
StrComp  = var{k};
NStrComp = length(StrComp);
idx1 = strfind(strs,StrComp);
idx2 = 8; % length of data(char) 
if k == 2; idx2 = 10; end
for i=1:size(idx1,2)
fndtxt=strs(idx1(i)+NStrComp:idx1(i)+NStrComp+idx2);
Strcomp2 = strfind(fndtxt,'"');
idx_ = isfinite(Strcomp2);
if (k==2 & length(idx_)==0); length(idx_); Strcomp2 = idx2+1; end
temp{i,k} = cellstr(fndtxt(1:Strcomp2(1)-1));
end   
end

out_table = [var_out;temp];

%%
% 1550131200000 - 1550124000000 = 7200000 = 2h 
% 1550131200000, 14日 17时00分
% 1550133600000, 14日 17时40分
% 1550124000000, 14日 15时00分
% Htime = datevec(str2num(cell2mat(temp{1,2}))/86400 +2 );
% Htime = datevec(str2num(cell2mat(temp{14,2}))/86400 +2 );

% add 1970yrs, 2days and 9 hours
add1970yrs=daysact(datenum(1,1,1),datenum(1970,12,31));
add_time = add1970yrs+2+9/24 ;

for i=1:size(idx1,2)
Htime(i,:) = datevec(str2num(cell2mat(temp{i,2}))/86400 + add_time );
end


%%
ic = ic+1;
CJ{ic,1}.discharge = out_table;
CJ{ic,1}.Htime = Htime;
CJ{ic,1}.Ctime = T(1:5);
Ctime(ic,:) = T(1:5); 
README.Ctime='time at running script';
README.Htime='time at Homepage data';
save(outfile,'CJ','Ctime','README')

exit
