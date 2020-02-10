function model = getModelByName(variableName)
    model = ncread('../data/model_combined.nc', [variableName, '_ozone']);
end