function nd = year2day(y)
if mod(y,400)==0
elseif mod(y,100)==0
elseif mod(y,4)==0
    nd = 366;
else
    nd=365;
end