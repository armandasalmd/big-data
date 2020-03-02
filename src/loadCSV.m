function ensemble = loadCSV(folderName, modelPrefix)
	% program assumes that files 1-25 exists
	disp(['Loading ', modelPrefix])
	ensemble = zeros(698,398,25);
	for i = 1:25
		if i < 10
			fileName = ['../data/', folderName, '/24HR_', modelPrefix, '_0', int2str(i), '.csv'];
		else
			fileName = ['../data/', folderName, '/24HR_', modelPrefix, '_', int2str(i), '.csv'];
		end
		ensemble(:,:,i) = csvread(fileName)';
	end
end
