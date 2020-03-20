function actionPlotSingleModel(models, colorSchemaId)
	ModelNames = getModelNames();
	Ids = 1:length(ModelNames);
	T = table(Ids(:), ModelNames(:), 'VariableNames',{'ID','MODEL NAME'});
	disp(T)
	choice = input('Select model id 1-8: ');
	if choice >= 1 && choice <= length(ModelNames)
		% removes dimentions of size 1
		prop = squeeze(models(choice, :, :, :));
		draw(prop, strcat("o3 Model ", ModelNames(choice)));
	end
	changeColorSchema(colorSchemaId);
end

% expects 700x400x25
function draw(models, windowTitle)
	if ~exist('windowTitle', 'var')
		windowTitle = "No window title"
	end
	sz = size(models);
	% Plot different plots according to slider location.
	S.fh = figure('units','pixels',...
				'position',[200 100 600 600],...
				'menubar','none',...
				'name',windowTitle,...
				'numbertitle','off');    
	S.x = 1:25;  % For plotting.         
	S.ax = axes('unit','pix',...
				'position',[50 80 500 500]);
	% plot(S.x,S.x,'r');
	S.models = models;
	S.windowTitle = windowTitle;
	plotHeapMap(models(:,:,1), strcat(windowTitle, ", Hour 1"));
	S.sl = uicontrol('style','slide',...
					'unit','pix',...
					'position',[20 10 260 30],...
					'min',1,'max',sz(3),'val',1,...
					'sliderstep',[1/(sz(3)-1) , 10/(sz(3)-1)],...
					'callback',{@sl_call,S});
end

function plotHeapMap(model, mTitle)
	if ~exist('mTitle', 'var')
		mTitle = "No title";
	end
	% model must be 698x398
	[X] = 30.05:0.1:69.75; % create X values 398x1
	[Y] = -24.95:0.1:44.75;% create Y values 698x1
	[X,Y] = meshgrid(X, Y);
	model = flip(model, 2);% flip the Y(2nd) axis
	% open new figure window
	% figure

	clf
	title(mTitle);
	worldmap('Europe'); % set the part of the earth to show
	load coastlines
	plotm(coastlat,coastlon)
	loadMapEntities()
	% colormap(flipud(jet))
	% Plot the data
	% edge colour outlines the edges, 'FaceAlpha', sets the transparency
	surfm(X, Y, model, 'EdgeColor', 'none', 'FaceAlpha', 0.9)
	
	Plots = findobj(gca,'Type','Axes');
	Plots.SortMethod = 'depth';
	clear Plots;
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

function [] = sl_call(varargin)
	% Callback for the slider.
	[h,S] = varargin{[1,3]};  % calling handle and data structure.
	cla
	% slider value 1-25:
	selectedHour = round(get(h,'value'));
	sz = size(S.models);
	if selectedHour >= 1 && selectedHour <= 25
		cla
		% title(['Hour ', int2str(selectedHour)]);
		plotHeapMap(S.models(:,:,selectedHour), strcat(S.windowTitle, ", Hour ", int2str(selectedHour)));
		S.sl = uicontrol('style','slide',...
					'unit','pix',...
					'position',[20 10 260 30],...
					'min',1,'max',sz(3),'val',1,...
					'sliderstep',[1/(sz(3)-1) , 10/(sz(3)-1)],...
					'value', selectedHour,...
					'callback',{@sl_call,S});
	end
end

