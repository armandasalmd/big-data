function models = getModels()
    % modelNames = ["chimere", "emep", "eurad", "match", "mocage", "silam"];
    variables = getModelNames();
    models = zeros(length(variables), 700, 400, 25);
    
    disp("Loading MAIN models")
	for idx = 1:length(variables)
        models(idx,:,:,:) = getModelByName(variables(idx));
    end
end
