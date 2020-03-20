function changeColorSchema(colorId)
	% id is expected to be from 1-7
	switch colorId
	case 1
		colormap(flipud(parula))
	case 2
		colormap(flipud(gray))
	case 3
		colormap(flipud(jet))
	case 4
		colormap(flipud(hsv))
	case 5
		colormap(flipud(hot))
	case 6
		colormap(flipud(cool))
	case 7
		colormap(flipud(spring))
	case 8
		colormap(flipud(summer))
	end
end
