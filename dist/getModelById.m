function model = getModelById(id)
    fileName = ['../data', '/model', int2str(id), '.nc'];
    model = ncread(fileName, 'unknown');
end
