% === Show combined model file specification
% showCombinedModelSpec()
% === Show selected model(single) specification (1-7)
% showModelSpecById(7)
% === Read 3D matrix model
% model = getModelById(7);
% === Read 3D matrix model
% model = getModelByName('eurad');
% === Read all models into 4D matrix
% === [model, lon, lat, time]
% models = getAllModels();
% === Calculates the average(by combining) for given models list
% ensembleModel = genMeanEnsemble(getAllModels());

% === Plot the simple mean ensemble with contourf(m1)
% === and axis values mapped to coordinates
 ensembleModel = genMeanEnsemble(getAllModels());
 m1 = ensembleModel(:,:,1);
% figure
% imagesc(getCoordinates('lat'), getCoordinates('lon'), m1)
% xlabel 'degrees longitude'
% ylabel 'degrees latitude'


lat_rng=[30 70];
lon_rng=[-25 45];
ax = worldmap(lat_rng,lon_rng,m1);
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow('landareas.shp')

% hold on
% 
% ensembleModel = genMeanEnsemble(getAllModels());
% m1 = ensembleModel(:,:,1);
% figure
% imagesc(getCoordinates('lat'), getCoordinates('lon'), m1)
% xlabel 'degrees longitude'
% ylabel 'degrees latitude'
% 
% hold off
% alpha(0.5)

% imagesc(m1)
% hold on
% geoshow('landareas.shp', 'FaceColor', [0.5 1.0 0.5]);
% hold off
% alpha(0.5)