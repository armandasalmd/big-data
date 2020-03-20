%% Title: CBE and Orig model comparison and visualization
% Description: The headers (%%) will be following the Data Flow Diagram
% Author: Armandas Barkauskas
% Usage: 
% - open root folder
% - ensure you have big data on your machine
% - ensure you have all toolboxes installed
% - type: run('./dist/index.m')
% Github: https://github.coventry.ac.uk/barkausa/big-data
% Expected output: a menu asking to input an action:
% 1. Plot all models in 1 window (select single hour)
% 2. Plot all hours for model (select single model)
% 3. Compare Orig and CBE (3 plots)
% Also, execution time printed in the console.
% Program assumes that this scrip runs from './dist/index.m'
disp('Program started!')

% =============== MAIN PROGRAM =================

CBE = [];
ORIG = [];
MAIN = [];
choice = -1;
allColorSchemas = ["parula", "color blind", "jet", "hsv", "hot", "cool", "spring", "summer"];
colorSchema = 1;

while not(choice == 0)
	disp('0. Exit')
	disp('1. Plot all models in 1 window (select single hour)')
	disp('2. Plot all hours for model (select single model)')
	disp('3. Compare Orig and CBE (3 plots)')
    disp(strcat('4. Change color schema. Current:', allColorSchemas(colorSchema)))
	choice = input('Select an action to perform: ');
	clc
	switch choice
	case 0
		continue
	case 1
		result = loadMainDataFile(MAIN);
		if not(result == -1)
			MAIN = result;
			actionPlotAllModels(MAIN, colorSchema);
		end
	case 2
		result = loadMainDataFile(MAIN);
		if not(result == -1)
			MAIN = result;
			actionPlotSingleModel(MAIN, colorSchema);
		end
	case 3
		result = loadCBE(CBE);
		if not(result == -1)
			CBE = result;
		else
			continue
		end
		result = loadORIG(ORIG);
		if not(result == -1)
			ORIG = result;
			actionCompareEnsembles(CBE, ORIG);
        end
    case 4
        disp('Select an option:')
		SelectionIds = 1:length(allColorSchemas);
		T = table(SelectionIds(:), allColorSchemas(:), 'VariableNames',{'ID','COLOR SCHEMA'});
		disp(T)
		colorSchema = input('Select model id 1-8: ');
		clc
	otherwise
		fprintf('Error: unknown action\n')
	end
	fprintf('\n')
end

% ============== TERMINATED ====================
clear choice
clear result
clc
disp('Program finished!')
% =============== MAIN PROGRAM END =============

function result = loadMainDataFile(org)
	result = -1;
	if size(org) == 0
		if isfile('../data/models-combined.nc')
			result = getModels();
		else
			disp('/data/models-combined.nc does not exist')
		end
	else
		result = org;
	end
end

function result = loadCBE(org)
	result = -1;
	if size(org) == 0
		if isfile('../data/org/24HR_Orig_01.csv') && isfile('../data/org/24HR_Orig_25.csv')
			result = loadCSV('cbe', 'CBE');					% load from file
			result = eliminateZerosWithSomeValue(result);   % get rid of zeros
			result = (result.*1.0497548e-07)+2.9458301e-08; % scale back
		else
			disp('CBE files doesnt exist')
		end
	else
		result = org;
	end
end

function result = loadORIG(org)
	result = -1;
	if size(org) == 0
		if isfile('../data/org/24HR_Orig_01.csv') && isfile('../data/org/24HR_Orig_25.csv')
			result = loadCSV('org', 'Orig');
		else
			disp('ORG files doesnt exist')
		end
	else
		result = org;
	end
end

function result = eliminateZerosWithSomeValue(ensemble)
	% expected 698x398x25 matrix
	sz = size(ensemble);
	% tic
	for kdx = 1:sz(3)
		defaultVal = ensemble(3, 3, kdx);
		% disp(defaultVal)
		for idx = 1:sz(1)
			for jdx = 1:sz(2)
				if ensemble(idx, jdx, kdx) == 0
					ensemble(idx, jdx, kdx) = defaultVal;
				end
			end
		end
	end
	result = ensemble;
	% time = toc
end
