function model = getModelByName(variableName)
    result = ncread('../data/full_data_set.nc', variableName);
end