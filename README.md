# BasinVis
A Matlab application for stratigraphic and subsidence modelling of sedimentary basins based on well data.

Release Notes:

To start BasinVis 1.0 open Matlab and change the active directory to the location of the BasinVis files.
Then run "mainwindow" in the Matlab console.

Data has to be filled in step by step (Study Area > Stratigraphic Units > Well Data Input > Parameter Input). Well and porosity data can be imported from excel spreadsheets. Buttons in the mainmenu become active as soon as required information in the previous data input windows is saved. 

An example project with data used to create the figures in the paper can be found in the "/data" subdirectory (ExampleProject.mat). Please note that processing wells with backstripping takes several seconds per well. Cached results are currently not saved in the project file and have to be recalculated for the Subsidence Modelling stage (which might take a few minutes depending on the hardware).
