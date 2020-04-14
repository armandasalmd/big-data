clc;
disp("=== Starting the tests!")

% Begin the test execution here
%% Test1 - plot 8 models in 1 window time test
MODELS = loadMainDataFile([]);
tic;
startTest1(MODELS, 3)
timeElapsed = toc;
disp(timeElapsed / 3)

%% End the test execution here
disp("=== All tests finished!")
clear;

%% Functions
function startTest1(MODELS, attempts)
    for attempt = 1:attempts
        percentStr = strcat(" (", int2str(attempt/attempts*100), "%", ")");
        disp(strcat("Attempt: ", int2str(attempt), "/", int2str(attempts), percentStr))
        disp("Wait!")
        actionPlotAllModels(MODELS, -1);
    end
    close all
end

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
