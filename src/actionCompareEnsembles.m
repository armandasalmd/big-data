function actionCompareEmsembles(model1, model2)
	hour = input('Select an hour 1-25: ');
	strength = input('Select difference strength 1-5: ');
	if hour >= 1 && hour <= 25 && strength >= 1 && strength <= 5
		model1 = squeeze(model1(:,:,hour));
		model2 = squeeze(model2(:,:,hour));
		bias = model1 - model2;
		bias = sharpenEnsemble(bias, strength);
		draw(model1, model2, bias);
	end
end

function draw(model1, model2, bias)
	figure('numbertitle','off','name','SME and Orig comparison');
	% change color schema as it 
	% less smooth and help to see differences
	colormap(flipud(jet));
	% PLOT 1
	subplot(2,3,1);
	plotHeatMap(model1, "CBE model");
	Plots = findobj(gca,'Type','Axes');
	Plots.SortMethod = 'depth';
	% PLOT 2
	subplot(2,3,2);
	plotHeatMap(model2, "Orig model");
	Plots = findobj(gca,'Type','Axes');
	Plots.SortMethod = 'depth';
	% PLOT 3
	subplot(2,3,3);
	plotHeatMap(bias, "BIAS of 2");
	Plots = findobj(gca,'Type','Axes');
	Plots.SortMethod = 'depth';
	% PLOT 4
	subplot(2,3,6);
	plotMeshMap(bias)
end


function plotHeatMap(model, mTitle)
	% model must be 698x398
	[X] = 30.05:0.1:69.75; % create X values 398x1
	[Y] = -24.95:0.1:44.75;% create Y values 698x1
	[X,Y] = meshgrid(X, Y);
	model = flip(model, 2);% flip the Y(2nd) axis
	% open new figure window
	worldmap('Europe'); % set the part of the earth to show
	title(mTitle);
	load coastlines
	plotm(coastlat,coastlon)
	loadMapEntities()
	% Plot the data
	% edge colour outlines the edges, 'FaceAlpha', sets the transparency
	surfm(X, Y, model, 'EdgeColor', 'none', 'FaceAlpha', 0.9)
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

function plotMeshMap(model)
	% model must be 698x398
	[X] = 30.05:0.1:69.75; % create X values 398x1
	[Y] = -24.95:0.1:44.75;% create Y values 698x1
	title('SME and Orig comparison');
	mesh(X, Y, model);
end

function result = sharpenEnsemble(ensemble, strength)
	% this function calculates an average
	% then goes over every location and finds outstanding values compared to the average
	% then if it was 1000% different then average, make it smaller
	% so the matlab map scales the colors better
	sz = size(ensemble);
	average = 0;
	for idx = 1:sz(1)
		for jdx = 1:sz(2)
			average = average + ensemble(idx,jdx);
		end
	end
	average = average / (sz(1) * sz(2));
	for idx = 1:sz(1)
		for jdx = 1:sz(2)
			percent = ensemble(idx,jdx) * 100 / average;
			if abs(percent) > 1000
				% ensemble(idx,jdx) = ensemble(idx,jdx) / strength;
				ensemble(idx,jdx) = average;
			end
		end
	end
	result = ensemble;
end

function result = parSharpenEnsemble(ensemble, strength)
	NumProcessors = 6; % change this to vary the number of processors used
	if isempty(gcp('nocreate')) % check if we already have a parallel pool?
		parpool(NumProcessors);
	end
	% function start
	sz = size(ensemble);
	result = zeros(size(ensemble));
	L = size(result, 2);
	tic
	parfor idx = 1:sz(1)
		for jdx = 1:L
			% do it for the first half - reduces wait time 4 times
			if jdx < L / 4
				average = avr(ensemble);
			end
			percent = ensemble(idx,jdx) * 100 / average;
			value = 0;
			if abs(percent) > 1000
				value = ensemble(idx,jdx) / strength;
			else
				value = ensemble(idx,jdx);
			end
			result(idx,jdx) = value;
		end
	end
	t2 = toc;
	fprintf('Sequential processing time: %.3f\n', t2)
	% result = ensemble;
end

function average = avr(ensemble)
	% average =====
	sz = size(ensemble);
	average = 0;
	for mdx = 1:sz(1)
		for ndx = 1:sz(2)
			average = average + ensemble(mdx,ndx);
		end
	end
	average = average / (sz(1) * sz(2));
	% average =====
end
