function model = getModelByName(variableName)
    model = ncread('../data/full_data_set.nc', [variableName, '_ozone']);
end