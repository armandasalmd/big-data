function showModelSpecById = ncDesc(modelNum)
    fileName = ['../data', '/model', int2str(modelNum), '.nc']
    ncdisp(fileName)
end