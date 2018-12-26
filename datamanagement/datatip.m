function output_txt = datatip(~,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

pos = get(event_obj,'Position');
userdata = get(get(event_obj,'Target'),'UserData');
output_txt = {['X: ',num2str(pos(1),'%.0f'), 'm'],...
    ['Y: ',num2str(pos(2),'%.0f'), 'm']};

ztypes = get(get(get(event_obj,'Target'),'Parent'),'UserData');
primtype = get(get(event_obj,'Target'), 'Type');

% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    if (strcmp(primtype, 'patch')) 
        output_txt{end+1} = [ztypes{1,2}, num2str(-userdata,'%.2f'), ztypes{1,4}];
    else
        output_txt{end+1} = [ztypes{1,1}, num2str(pos(3),'%.2f'), ztypes{1,3}];
    end
end
