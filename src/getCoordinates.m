function list = getCoordinates(axis)
    % axis:string = lon OR lat
    if axis == 'lon'
        list = flip(ncread('../data/model1.nc', 'latitude'));
    else if axis == 'lat' % then its lat
        list = ncread('../data/model1.nc', 'longitude');
    end
end