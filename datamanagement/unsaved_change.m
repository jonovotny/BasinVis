function [ ] = unsaved_change( handles, flagname )
%UNSAVED_CHANGE Sets the change flag for a figure and activates Save/Cancel Buttons
    
assignin('base', flagname, 1);
set(handles.button_save, 'Enable', 'on');
set(handles.button_cancel, 'Enable', 'on');

end

