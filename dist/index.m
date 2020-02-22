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
hourToUseForPlotting = 1

disp('Program started!')
clear

if isempty(gcp('nocreate')) % check if we already have a parallel pool?
    parpool(6);
end

%% Loading simple mean ensemble (SME)
% if exists load from file, else calculate using parallel processing
% when calculating your own values, the result has to be scaled

if isfile('../data/org/24HR_Orig_01.csv') && isfile('../data/org/24HR_Orig_25.csv')
	% program assumes that files 1-25 exists
	ORG = zeros(698,398,25);
	for i = 1:25
		if i < 10
			fileName = ['../data/org/24HR_Orig_0', int2str(i), '.csv'];
		else
			fileName = ['../data/org/24HR_Orig_', int2str(i), '.csv'];
		end
		ORG(:,:,i) = csvread(fileName)';
	end
else
	disp('ORG files doesnt exist')
	exit
end

%% Scale the SME if needed
% scale by: Ozone – multiply by 1.0497548e-07, then add 2.9458301e-08

%% Loading clusted based ensemble (CBE)
% if exists load from .csv files, else disp(error)

if isfile('../data/cbe/24HR_CBE_01.csv') && isfile('../data/cbe/24HR_CBE_25.csv')
	% program assumes that files 1-25 exists
	CBE = zeros(698,398,25);
	for i = 1:25
		if i < 10
			fileName = ['../data/cbe/24HR_CBE_0', int2str(i), '.csv'];
		else
			fileName = ['../data/cbe/24HR_CBE_', int2str(i), '.csv'];
		end
		CBE(:,:,i) = csvread(fileName)';
	end
else
	disp('CBE files doesnt exist')
	exit
end
CBE = scaleModel(CBE);


% 7 700 400 25
models = getAllModels();
%% TODO: Add to the report as parallel processing with small data set
% runs longer due to tasks splitting
SME = zeros(700,400,25);
% Creating single mean ensemble
for idx = 1:25
	SME(:,:,idx) = mean(models(:,:,:,idx), 1);
end
SME(end-1:end,:,:) = []; % drops last 2 columns. 700 -> 698
SME(:,end-1:end,:) = []; % drops last 2 rows. 400 -> 398
clear models;

% ensemble = genMeanEnsemble(models);

%% Sub-space the ensembles

%% Running parallel processing on subspaced sets

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
	% model is matrix of 700x400x25
	scaledModel = (model.*1.0497548e-07)+2.9458301e-08;
end

