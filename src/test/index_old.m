% author: barkausa
disp('Hello world!')

ncdisp('./data/whole_data.nc')

map = ncread('./data/whole_data.nc', 'eurad_ozone');
e = map(2,3,2)
%whos map
%disp(map)

% whos peaksData
% plot(map);

%surf(double(peaksData));
%title('Peaks Data');

%ncdisp('./data/W_fr-meteofrance,MODEL,CHIMERE+FORECAST+SURFACE+O3+0H24H_C_LFPW_20180701000000.nc');