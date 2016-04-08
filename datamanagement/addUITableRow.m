function [ ] = addUITableRow( handle, selectname, above )
%addUITableRow Add a row to the specified uitable

sel = evalin('base', selectname);
row = 0;

if size(sel,1) > 0 && size(sel,2) > 0
    row = sel(1);
end
data = get(handle, 'Data');
rows = size(data, 1);
cols = size(get(handle, 'ColumnName'), 1);
colTypes = get(handle, 'ColumnFormat');

newRow = repmat({[]}, [1 cols]);
for i = 1:cols
    if strcmp(colTypes{i}, 'char')
        newRow{i} = '';
    end
end

if rows < 1
    data = newRow;
    set(handle, 'Data', data);
    return
end

if row < 1
    if above
        row = 1;
    else
        row = rows;
    end
end

data(rows+1, 1:cols) = newRow;

if above
    data(row+1:rows+1, :) = data(row:rows, :);
    data(row, :) = newRow;
else
    if row < rows
        data(row+2:rows+1, 1:cols) = data(row+1:rows, 1:cols);
        data(row+1, 1:cols) = newRow;
    end
end

set(handle, 'Data', data);

end

