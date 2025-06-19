function [] = filter_scatter_overlay_polygons(xvar,yvar,selected_cell_lines,filter_save,axis)
%FILTER_SCATTER_OVERLAY_POLYGON Summary of this function goes here
%   Detailed explanation goes here

%% Function arguments
% required inputs
arguments
    xvar {mustBeA(xvar,{'string','char','cell'})}
    yvar {mustBeA(yvar,{'string','char','cell'})}
    selected_cell_lines {mustBeA(selected_cell_lines,{'string','cell'})}
    filter_save {mustBeA(filter_save,{'dictionary'})}
    axis
end

%% Function begins
% initialise
xvar = string(xvar);
yvar = string(yvar);
selected_cell_lines = string(selected_cell_lines);

% go through each selected cell line and change range
for i = 1:numel(selected_cell_lines)
    variant_dictionary = filter_save(selected_cell_lines(i));

    condition1 = {[xvar,yvar]};
    condition2 = {[yvar,xvar]};

    if isKey(variant_dictionary,condition1)
        position = cell2mat(variant_dictionary(condition1));
        drawpolygon(axis,'Position',position,"FaceAlpha",0.1);
    elseif isKey(variant_dictionary,condition2)
        position = cell2mat(variant_dictionary(condition2));
        position = [position(:,2),position(:,1)];
        drawpolygon(axis,'Position',position,"FaceAlpha",0.1);
    end
end

end

