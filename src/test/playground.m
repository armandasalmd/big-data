
%printHello();

b = ncRead(4);
b(1,1,1)
%b(100,120,1)


function result = ncReadFullSet(variableName)
    result = ncread('../data/full_data_set.nc', variableName);
end

function result = ncRead(modelNum)
    fileName = ['../data', '/model', int2str(modelNum), '.nc']
    result = ncread(fileName, 'unknown');
end

