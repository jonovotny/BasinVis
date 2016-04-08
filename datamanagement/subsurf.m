function [x, y, z, surfaceX, surfaceY, surfaceZ] = subsurf (data, column, limits, quadsize) %, linespec, shaded, cmap, climit, levels, aspectRatio, plot)

% if nargin < 11
%   aspectRatio = [1 1 0.2];
% end

filteredData = data;%(not(isnan(data(:,column))),:);
xy = filteredData(:,1:2)';
z = filteredData(:,column)';
tps = tpaps(xy,-z,1);
assignin('base','tps',tps);

patchsize = quadsize * 51;

xPatches = ceil((limits(1,2) - limits(1,1))/patchsize(1));
yPatches = ceil((limits(2,2) - limits(2,1))/patchsize(2));

patchstart = [limits(1,1) limits(2,1)];

surfaceX = zeros(xPatches * 51, yPatches * 51);
surfaceY = zeros(xPatches * 51, yPatches * 51);
surfaceZ = zeros(xPatches * 51, yPatches * 51);

for ix = 1:xPatches
    patchstart(2) = limits(2,1);
    for iy = 1:yPatches
        tps.interv{1,1} = [patchstart(1) (patchstart(1)+ patchsize(1))];
        tps.interv{1,2} = [patchstart(2) (patchstart(2)+ patchsize(2))];
        patch = fnplt(tps);
        
        surfaceX(((ix-1)*51)+1:(ix*51), ((iy-1)*51)+1:(iy*51)) = patch{1};
        surfaceY(((ix-1)*51)+1:(ix*51), ((iy-1)*51)+1:(iy*51)) = patch{2};
        surfaceZ(((ix-1)*51)+1:(ix*51), ((iy-1)*51)+1:(iy*51)) = patch{3};
        
        patchstart(2) = patchstart(2) + patchsize(2);
    end;
    patchstart(1) = patchstart(1) + patchsize(1);
end;

surfaceLimits = [ceil((limits(1,2) - limits(1,1))/quadsize(1)) ceil((limits(2,2) - limits(2,1))/quadsize(1))]; 
surfaceX = surfaceX(1:surfaceLimits(1), 1:surfaceLimits(2));
surfaceY = surfaceY(1:surfaceLimits(1), 1:surfaceLimits(2));
surfaceZ = surfaceZ(1:surfaceLimits(1), 1:surfaceLimits(2));
quadsize
assignin('base', 'a', surfaceX);
[surfaceX, surfaceY] = meshgrid(limits(1,1):0.4:limits(1,2), limits(2,1):0.4:limits(2,2));
surfaceX = surfaceX';
surfaceY = surfaceY';
assignin('base', 'b', surfaceX);
patch2 = reshape(fnval(tps, [reshape(surfaceX, 1, []); reshape(surfaceY, 1, [])]), size(surfaceX, 1), size(surfaceX, 2));
if (surfaceZ == patch2)
    disp('your message');
else
    disp('fail')
end

surfaceZ(surfaceZ > 0) = 0;

surfaceX = surfaceX ./ 2.2861;
surfaceY = surfaceY ./ 2.2861;


xy = xy ./ 2.2861;


x = xy(1,:);
y = xy(2,:);

end