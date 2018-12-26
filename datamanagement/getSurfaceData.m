function [surfX, surfY, surfZ] = getSurfaceData(type, layer, interpolation, x, y, z, limits, quadsize)
    limits = limits + [0 0; 0.08 0.08];


    key = char(strcat(type, num2str(layer), interpolation));
    surfaceCache = evalin('base', 'surface_cache');
    if (surfaceCache.isKey(key))
        data = surfaceCache(key);
        if (isequal(data{4}, limits) && isequal(data{5}, quadsize))
            surfX = data{1};
            surfY = data{2};
            surfZ = data{3};
            %return;
        end
    end
    
    % data not in cache -> do interpolation, cache surface and return
    % values
    
    filteredData(:,1) = x';
    filteredData(:,2) = y';
    filteredData(:,3) = -z';
    filteredData = filteredData(all(~isnan(filteredData),2),:);
    [surfX, surfY] = meshgrid(limits(1, 1):quadsize(1):limits(1,2), limits(2, 1):quadsize(2):limits(2, 2));
    surfX = surfX';
    surfY = surfY';
    if (strcmp(interpolation, 'none'))
        surfX = filteredData(:,1);
        surfY = filteredData(:,2);
        surfZ = filteredData(:,3);
    elseif (strcmp(interpolation, 'TPS'))
        tpsXY = filteredData(:,1:2)';
        tpsZ  = filteredData(:,3)';
        tps = tpaps(tpsXY, tpsZ,0.999999);
        surfZ = reshape(fnval(tps, [reshape(surfX, 1, []); reshape(surfY, 1, [])]), size(surfX, 1), size(surfX, 2));
    elseif (strcmp(interpolation, 'kriging'))
        krigXY = filteredData(:,1:2)./1000;
        krigZ  = filteredData(:,3)./1000;
        v = variogram(krigXY, krigZ,'plotit',false,'maxdist',150);%
        [~,~,~,vstruct] = variogramfit(v.distance,v.val,[],[],[],'model','stable','plotit',false);
        [surfZ,Zvar] = kriging(vstruct,krigXY(:,1),krigXY(:,2), krigZ, surfX./1000, surfY./1000);
        surfZ = surfZ.*1000;
    else
        surfZ = griddata(filteredData(:,1), filteredData(:,2), filteredData(:,3), surfX, surfY, char(interpolation));
    end
    
    surfZ = arrayfun(@pos2zero, surfZ);
    
    data = {surfX, surfY, surfZ, limits, quadsize};
    surfaceCache(key) = data;
    
%     limits = limits ./ 2.2861;
%         crossx = (limits(1, 1):(limits(1,2)-limits(1, 1))/100:limits(1,2));
%         crossy = (limits(2, 1):(limits(2,2)-limits(2, 1))/100:limits(2,2));
%         crossz = griddata(surfx,surfy,surfz, crossx, crossy, 'linear');
%         crossxy = ((crossx.^2 + crossy.^2).^0.5) - sqrt(limits(1, 1)^2 + limits(2, 1)^2);
%         test_data = evalin('base', 'test');
%         test_data(layer, 1:4) = {[crossx], [crossy], [crossz], [crossxy]};
%         assignin('base', 'test', test_data);
% 
%     plot_data = evalin('base', 'plot_data');
%     plot_data(layer, 1:6) = {x,y,z,surfx,surfy,surfz};
%     assignin('base', 'plot_data', plot_data);
  
    
end

function out = pos2zero(in)
    if in > 0
        out = 0;
    else
        out = in;
    end
end