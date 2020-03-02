function model = getModelByName(variableName)
    model = ncread('../data/models-combined.nc', strcat(variableName, "_ozone"));
end
