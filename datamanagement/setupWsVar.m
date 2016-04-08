function setupWsVar( name, value, workspace )
    if nargin < 3
      workspace = 'base';
    end
    try
        var = evalin(workspace, name);
    catch ex
        assignin(workspace, name, value);
    end
end

