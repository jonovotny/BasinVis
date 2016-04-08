function [] =  initializeCaches()
    surfCache = containers.Map();
    setupWsVar('surface_cache', surfCache);    
    backstripCache = containers.Map();
    setupWsVar('backstrip_cache', backstripCache);   
end