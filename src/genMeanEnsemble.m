% returns 3D matrix [lat,lon,time]
function ensemble = genMeanEnsemble(models)
    % create empty matrix with the same dimentions
    sz = size(models);
    e = zeros(sz(2), sz(3), sz(4));
    for i = 1:sz(4) % iterate every hour
        for j = 1:sz(2) % iterate every lat
            for k = 1:sz(3) % iterate every lon
                % for every point at map sum the model values
                sum = 0; % reset sum on new map point
                for l = 1:sz(1) % sum up every model value
                    sum = sum + models(l,j,k,i);
                end
                % calculating models average and saving to a result matrix
                e(j, k, i) = sum / sz(1);
            end
        end
    end
    % rotate the map
    ensemble = zeros(sz(3), sz(2), sz(4));
    for i = 1:sz(4)
        ensemble(:,:,i) = e(:,:,i)';
    end
end