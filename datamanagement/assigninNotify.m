function [ ] = assigninNotify( workspace, name, value )
%assigninNotify calls assignin and notifies all registered observers
    
    assignin( workspace, name, value );
end

