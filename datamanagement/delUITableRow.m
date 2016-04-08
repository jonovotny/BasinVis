function [ ] = delUITableRow( handle, selectname)
%addUITableRow Add a row to the specified uitable

sel = evalin('base', selectname);
row = 0;

if size(sel,1) > 0 && size(sel,2) > 0
    row = sel(1);
else
    return
end

data = get(handle, 'Data');
data(row,:) = [];

set(handle, 'Data', data);

end

