%--------------------------------------------------------------------------
%       get Changiang River Discharge 
%
% v1   : extract the 'datong' discharge data from url, 04Mar2014
% v1.1 : if empty cell exists, display 'NaN', bug modification on 28Nov2014
% v1.2 : bug modification on 25Feb2019
% v2   : Add subfunction 'getTableFromWeb_mod.m' srcipt, modification on 29Aug2016
% v3   : use regexp, read num from char., 13Feb2019
%        Modified by CSKIM, 
%--------------------------------------------------------------------------
close all; clear all; clc;


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

% nstr=split(strs,',');
nstr=strsplit(strs,',');

StrComp  = '大通';
NStrComp = length(StrComp);
for k = 1:length(nstr)
idx = strfind(nstr{k},StrComp);
if isfinite(idx) == 1
    disp(k)
    idx_datong = k;
    break    
end
end

%% find discharge
idx_dis = idx_datong-3;
nstr1 = nstr{idx_dis};
Nnstr1 = length(nstr1);
StrComp  = '"q":"';
NStrComp = length(StrComp);
dis = str2num(nstr1(NStrComp+1:Nnstr1-1));

%% find time
idx_tm = idx_datong +1 ;
nstr1 = nstr{idx_tm};
Nnstr1 = length(nstr1);
idx2 = 10; % length of data(char) 
StrComp  = '"tm":';
NStrComp = length(StrComp);
tm = str2num(nstr1(NStrComp+1:NStrComp+idx2));


% add 1970yrs, 2days and 9 hours
%add1970yrs=daysact(datenum(1,1,1),datenum(1970,12,31));
%add_time = add1970yrs+2+9/24 ;
add_time = sum(yeardays(1:1970))+2+9/24 ;

Htime = datevec( tm/86400 + add_time);

%%

T = clock;
t3 = [Htime dis T(1:5)];

yy = T(1);
mm = T(2);
dd = T(3);
hh = T(4);
ym = [num2str(yy),num2str(mm,'%2.2d')];
ymdh = [num2str(yy),num2str(mm,'%2.2d'),num2str(dd,'%2.2d'),num2str(hh,'%2.2d')];

disp(ymdh)

fout_head = ['/home/auto/MAMS/Data/CJD/',num2str(yy),'/'];

if isdir(fout_head) ~= 1
mkdir(fout_head);
end

fout = strcat([fout_head,'datong_archive_',ym,'.dat']);
fid = fopen(fout,'a');
out = [t3 ];
fprintf(fid,'%5.0f %5.0f %5.0f %5.0f %5.0f %5.0f %10.3f %5.0f %5.0f %5.0f %5.0f %5.0f\n',out');
% fprintf(fid,'%5.0f %5.0f %5.0f %5.0f %5.0f %5.0f %10.3f\n',out');
fclose(fid);

exit


