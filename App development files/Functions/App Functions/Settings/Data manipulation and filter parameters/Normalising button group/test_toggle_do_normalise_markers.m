master_fig = uifigure("Position",[100,100,500,500]);

%%%%%%%%%%%%%%Reassign fluorescent channels to marker protein names
column_names = dictionary();
%assign new channel name on left-hand side, and old on right-hand side
column_names("GAPDH") = "B525-FITC-A";
column_names("HA") = "R712-APCA700-A";
% column_names("pAKT") = "V450-PB-A";
% column_names("p4EBP1") = "Y585-PE-A";
% column_names("pS6") = "Y763-PC7-A";
% column_names("pCREB") = "R660-APC-A";
new_column_names = keys(column_names);
marker_list = cellstr(new_column_names);

position = [10, 10, 300, 300];

[marker_do_normalise_buttons] = toggle_do_normalise_markers(master_fig,position,marker_list);

% slider11 = superSlider(master_fig, 'numSlides', 2,'controlColor',[.5 .1 .5],...
% 'position',[300, 10, 20, 30],'stepSize',.1);