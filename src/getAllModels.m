function models = getAllModels()
    models = zeros(7,700,400,25);
    for i = 1:7
        models(i,:,:,:) = getModelById(i);
    end
end