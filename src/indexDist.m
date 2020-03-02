%% Title: CBE and SME model comparison and visualization
% Description: The headers (%%) will be following the Data Flow Diagram
% Author: Armandas Barkauskas
% Usage: 
% - open root folder
% - ensure you have big data on your machine
% - ensure you have all toolboxes installed
% - type: run('./dist/index.m')
% Github: https://github.coventry.ac.uk/barkausa/big-data
% Expected output: 3 figures pop up depicting CBE and SME over Europe and
% their difference plot. Figures gets saved in /figures folder.
% Also, execution time printed in the console.
% Program assumes that this scrip runs from './dist/index.m'
disp('Program started!')
clear

selectedHour = 21

% if isempty(gcp('nocreate')) % check if we already have a parallel pool?
%     parpool(6);
% end

%% Loading Observations ensemble (ORG)

if isfile('../data/org/24HR_Orig_01.csv') && isfile('../data/org/24HR_Orig_25.csv')
	ORG = loadCSV('org', 'Orig');
else
	disp('ORG files doesnt exist')
	return
end

%% Scale the SME if needed
% scale by: Ozone – multiply by 1.0497548e-07, then add 2.9458301e-08

%% Loading clusted based ensemble (CBE)
% if exists load from .csv files, else disp(error)

if isfile('../data/cbe/24HR_CBE_01.csv') && isfile('../data/cbe/24HR_CBE_25.csv')
	CBE = loadCSV('cbe', 'CBE');
	CBE = scaleModel(CBE);
else
	disp('CBE files doesnt exist')
	return
end

%% Load if exist or generate Simple Mean Ensemble
% parallel processing is inefficient due to small data set
% thus disabled. parfor runs longer due to tasks splitting

if isfile('../data/sme/24HR_SME_01.csv') && isfile('../data/sme/24HR_SME_25.csv')
	SME = loadCSV('sme', 'SME');
else
	disp('Generating SME')
	SME = genSME();
	saveSME(SME)
end

%% Sub-space the ensembles
plotHeatMap(CBE(:,:,1))
% plotMeshMap(CBE(:,:,1))
% sets the visibility of the various parts of the
% plot so the land, cities etc shows through.

Plots = findobj(gca,'Type','Axes');
Plots.SortMethod = 'depth';
clear Plots;

%% Running parallel processing on subspaced sets

percents = accuracyPercent(ORG(:,:,selectedHour), SME(:,:,selectedHour), CBE(:,:,selectedHour));
avg = sum(percents(:));

%% Assemble the result into a single variable

%% Plot the SME

%% Plot the CBE

%% Plot the difference between SME and CBE

%% Save the ploted figures
% use /figures folder


%% Removing not needed variables
clear fileName;
clear i;
clear idx;
clear hourToUseForPlotting;

disp('Program ended!')

%% Additional functions
function scaledModel = scaleModel(model)
	% expected model matrix size is 700x400x25
	scaledModel = (model.*1.0497548e-07)+2.9458301e-08;
end

function plotHeatMap(model)
	% model must be 698x398
	[X] = 30.05:0.1:69.75; % create X values 398x1
	[Y] = -24.95:0.1:44.75;% create Y values 698x1
	[X,Y] = meshgrid(X, Y);
	model = flip(model, 2);% flip the Y(2nd) axis
	% open new figure window
	figure
	clf
	worldmap('Europe'); % set the part of the earth to show
	load coastlines
	plotm(coastlat,coastlon)
	loadMapEntities()
	% Plot the data
	% edge colour outlines the edges, 'FaceAlpha', sets the transparency
	surfm(X, Y, model, 'EdgeColor', 'none', 'FaceAlpha', 0.9)
end

function plotMeshMap(model)
	% model must be 698x398
	[X] = 30.05:0.1:69.75; % create X values 398x1
	[Y] = -24.95:0.1:44.75;% create Y values 698x1
	figure
	mesh(X, Y, model)
end

function loadMapEntities()
	land = shaperead('landareas', 'UseGeoCoords', true);
	geoshow(gca, land, 'FaceColor', [0.5 0.7 0.5])

	lakes = shaperead('worldlakes', 'UseGeoCoords', true);
	geoshow(lakes, 'FaceColor', 'blue')

	rivers = shaperead('worldrivers', 'UseGeoCoords', true);
	geoshow(rivers, 'Color', 'cyan')

	cities = shaperead('worldcities', 'UseGeoCoords', true);
	geoshow(cities, 'Marker', '.', 'Color', 'yellow')
end

function ensemble = genSME()
	models = getModels(); % matrix 7 700 400 25
	ensemble = zeros(700,400,25);
	% Creating single mean ensemble - calc mean
	for idx = 1:25
		ensemble(:,:,idx) = mean(models(:,:,:,idx), 1);
	end
	ensemble(end-1:end,:,:) = []; % drops last 2 columns. 700 -> 698
	ensemble(:,end-1:end,:) = []; % drops last 2 rows. 400 -> 398
	clear models;
end

function saveSME(ensembles)
	sz = size(ensembles);
	if not(sz == [698, 398, 25])
		disp('Warning: dimentions are not 698x398x25!')
	end
	for idx = 1:sz(3)
		if idx < 10
			fileName = ['../data/sme/24HR_SME_0', int2str(idx), '.csv'];
		else
			fileName = ['../data/sme/24HR_SME_', int2str(idx), '.csv'];
		end
		csvwrite(fileName, ensembles(:,:,idx)'); % Alert: rotates matrix for consistency 
	end
	disp('SME was saved for the next time /data/sme')
end

