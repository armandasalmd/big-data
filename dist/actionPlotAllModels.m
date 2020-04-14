function actionPlotAllModels(models, colorSchemaId)
    if colorSchemaId >= 0
        hour = input('Select an hour 1-25: ');
        if hour >= 1 && hour <= 25
            draw(models(:,:,:,hour), strcat("Plot All Models. Hour ", int2str(hour)));
        end
        changeColorSchema(colorSchemaId);
    else
        % Test call
        hour = 1;
        draw(models(:,:,:,hour), strcat("Plot All Models. Hour ", int2str(hour)));
    end
end

% expects 8x700x400 matrix
function draw(models, mTitle)
	sz = size(models);
	modelNames = getModelNames();
	figure('units','normalized','outerposition',[0 0 1 1],'menubar','none','numbertitle','off','name',mTitle);
	for idx = 1 : sz(1)	
		prop = squeeze(models(idx, :, :));
		subplot(2, 4, idx);
		plotHeatMap(prop, modelNames(idx));

		Plots = findobj(gca,'Type','Axes');
		Plots.SortMethod = 'depth';
	end
end

function plotHeatMap(model, mTitle)
	% model must be 698x398
	[X] = 30.05:0.1:69.75; % create X values 398x1
	[Y] = -24.95:0.1:44.75;% create Y values 698x1
	[X,Y] = meshgrid(X, Y);
	model = flip(model, 2);% flip the Y(2nd) axis
	% open new figure window
	% figure
	% clf
	title(mTitle);
	worldmap('Europe'); % set the part of the earth to show
	load coastlines
	plotm(coastlat,coastlon)
	loadMapEntities()
	% colormap(flipud(jet))
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
