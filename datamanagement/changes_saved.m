function [ ] = changes_saved( handles, flagname )
%UNSAVED_CHANGE Sets the change flag for a figure and activates Save/Cancel Buttons
    
assignin('base', flagname, 0);
set(handles.button_save, 'Enable', 'off');
set(handles.button_cancel, 'Enable', 'off');

end

