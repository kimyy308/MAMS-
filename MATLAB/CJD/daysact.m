function d = daysact(t1,t2) 
%DAYSACT Actual number of days between serial date numbers. 
%   D = DAYSACT(T) converts the date representations to a DAYS  
%   scalar value, which is the elapsed time, in units of days, from an  
%   origin roughly 2000 years ago, on the day before January first of  
%   year 0.  
%
%   D = DAYSACT(T1,T2), with two arguments in any of the two  
%   representations, is the same as DAYSACT(T2) - DAYSACT(T1), which is  
%   the number of days from T1 to T2.  This is negative if T2 represents  
%   an earlier time than T1. 
% 
%   Examples: 
%     d=daysact('7-sep-1995', '25-dec-1995') 
%       returns d = 109.
%     
%     d=daysact('9/7/1995') 
%       returns d = 728909.
% 
%   See also DATENUM, DAYS360, DAYS365, DAYSDIF, DATEVEC. 

%       Copyright 1995-2015 The MathWorks, Inc.
 
if nargin < 1 
  error(message('finance:daysact:missingInputs')) 
end 
if ischar(t1) || isdatetime(t1)
  t1 = datenum(t1); 
end 
if nargin < 2
    d = t1;
end 
if nargin == 2 
    if ischar(t2) || isdatetime(t2)
        t2 = datenum(t2); 
    end  
    d = t2 - t1; 
end
