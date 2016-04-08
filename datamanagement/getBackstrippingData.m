function [data] = getBackstrippingData(well_id, interpolated)
    interpol = false;
    if nargin > 1
       interpol = interpolated;
    end

    key = num2str(well_id);
    if interpol
        key = [key '_interpol']
    end
    
    
    backstripCache = evalin('base', 'backstrip_cache');
    if (backstripCache.isKey(key))
        data = backstripCache(key);
        return;
    end

    poro_data = evalin('base','poro_data');
    if evalin('base', ['well_custom_params(' num2str(well_id) ',1)'])
        poro_data = evalin('base', ['well_params{' num2str(well_id) ',1}']);
    end
    poro_data = flipud(poro_data);
    num_layers = size(poro_data,1);
    decomp_data = cell(1,(sum(1:num_layers)+(num_layers*4)));
    
    well_data = evalin('base',['well_data(' num2str(well_id) ',:)']);
    
    if (interpol && isnan(sum(cell2mat(cellfun(@filterCells, well_data(5:end), 'UniformOutput', false)))))
        wellData = evalin('base', 'well_data');
        depth_data = cell2mat(cellfun(@filterCells, wellData(:,2:size(wellData,2)), 'UniformOutput', false));
        depth_data(:,4:size(depth_data,2)) = fliplr(depth_data(:,4:size(depth_data,2)));
        limits = [0 evalin('base', 'area_x_dim');  0 evalin('base', 'area_y_dim')];
        quadsize = [0.4 0.4];
        
        
        for layer = num_layers:-1:1
            if(isempty(well_data{1,end+1-layer}))
                [x, y, z] = getSurfaceData('distri', layer, 'TPS', depth_data(:,1), depth_data(:,2), depth_data(:,layer+3), limits, quadsize);
                well_data{1,end+1-layer} = -interp2(x',y',z',well_data{1,2}, well_data{1,3});
                if(layer < num_layers && well_data{1,end+1-layer} > well_data{1,end-layer})
                    well_data{1,end+1-layer} = well_data{1,end-layer};
                end
                if(layer > 1 && well_data{1,end+1-layer} < max(depth_data(well_id,4:layer+3)))
                    well_data{1,end+1-layer} = max(depth_data(1,end+2-layer:end));
                end
            end
        end
    end
    
    for i = 5:size(well_data,2)-1
       bot = well_data{1,i};
       if well_data{1,i+1} > bot
           well_data{1,i+1} = bot;
       end
    end    

    tops = well_data(1,6:size(well_data,2));
    bottoms = well_data(1,5:size(well_data,2)-1);

    for i = 1:size(tops,2)-1
        if isempty(tops{1,i}) && ~isempty(bottoms{1,i})
            bottoms{1,i+1} = bottoms{1,i};
            bottoms{1,i} = [];
        end
    end

    assignin('base','test',tops)

    write_to = 1;
    dens_water = 1;
    dens_grain = 2.68;
    dens_mantle = 3.3;

    strati_data = evalin('base', 'strati_data');
    age_diff = cell2mat(strati_data(:,2)) - cell2mat(strati_data(:,3));
    age_diff = flipud(age_diff)';

    previous_basement = 0;
    previous_tectonic = 0;

    for i = 1:size(tops,2)
        last_depth = 0;

        dens_column = 0;
        had_layers = 0;
        for j = i:-1:1
            if ~isempty(tops{1,j}) && ~isempty(bottoms{1,j})
                thickness = decompact(poro_data{j,1}, poro_data{j,2}, tops{1,j}, bottoms{1,j}, last_depth);
                density = layer_density(tops{1,j}, thickness, poro_data{j,1}, poro_data{j,2}, dens_water, dens_grain);

                dens_column = dens_column + density;
                last_depth = last_depth + thickness;
                decomp_data{1,write_to} = last_depth;
                had_layers = 1;

            end
            write_to = write_to + 1;

        end

        if had_layers == 1 && ~isempty(tops{1,i}) && ~isempty(bottoms{1,i})
            dens_column = dens_column/last_depth;
            decomp_data{1,write_to} = dens_column;
            write_to = write_to + 1;
            basement_sub_rate = (last_depth - previous_basement)/age_diff(1,i);
            decomp_data{1,write_to} = basement_sub_rate;
            write_to = write_to + 1;

            tectonic_sub = (((dens_mantle - dens_column)/(dens_mantle - dens_water))*last_depth)+poro_data{i,3}-(poro_data{i,4}*(dens_mantle/(dens_mantle - dens_water)));
            decomp_data{1,write_to} = tectonic_sub;
            write_to = write_to + 1;

            tectonic_sub_rate = (tectonic_sub - previous_tectonic)/age_diff(1,i);
            decomp_data{1,write_to} = tectonic_sub_rate;
            write_to = write_to + 1;

            previous_basement = last_depth;
            previous_tectonic = tectonic_sub;
        else 
            if (isempty(tops{1,i}) || isempty(bottoms{1,i})) && i > 1
                decomp_data{1,write_to} = decomp_data{1,write_to-(4+i)};
                write_to = write_to + 1;
                decomp_data{1,write_to} = 0;
                write_to = write_to + 1;
                decomp_data{1,write_to} = decomp_data{1,write_to-(4+i)};
                write_to = write_to + 1;
                decomp_data{1,write_to} = 0;
                write_to = write_to + 1;
            else
                write_to = write_to + 4;
            end
        end

    end

    decomp = cell(num_layers);
    sub_block = cell(4,num_layers);

    read_pos = 1; 
    for i = 1:num_layers
        j = num_layers - i + 1;
        decomp(1:i, num_layers-i+1) = decomp_data(1,read_pos:read_pos+i-1);
        sub_block(1,j) = decomp_data(1,read_pos+i-1);
        sub_block(2:4,j) = decomp_data(1,read_pos+i+1:read_pos+i+3)';
        read_pos = read_pos + i + 4;
    end

    assignin('base','decomp_data',decomp_data);
    % decomp(1,5) = decomp_data(1,1);
    % decomp(1:2,4) = decomp_data(1,4:5)';
    % decomp(1:3,3) = decomp_data(1,8:10)';
    % decomp(1:4,2) = decomp_data(1,13:16)';
    % decomp(1:5,1) = decomp_data(1,19:23)';
    %sub_data = evalin('base', 'sub_data');

    %sub_data(1:num_layers,1:num_layers) = decomp;
    %sub_data(num_layers+2:num_layers+5,1:num_layers) = sub_block;
    
    backstripCache(key) = {sub_block(1,:), sub_block(2,:), sub_block(3,:), sub_block(4,:), decomp};
    data = backstripCache(key);
end

function out = filterCells(in)
    if ~isempty(in)
        out = in;
    else
        out = NaN;
    end
end