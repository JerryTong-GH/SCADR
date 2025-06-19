function [filter_save] = save_polygon_filter(xvar,yvar,selected_cell_lines,filter_save,polygon_shape)
%SAVE_POLYGON_FILTER Summary of this function goes here
%   Detailed explanation goes here

%% Function arguments
% required inputs
arguments
    xvar {mustBeA(xvar,{'string','char','cell'})}
    yvar {mustBeA(yvar,{'string','char','cell'})}
    selected_cell_lines {mustBeA(selected_cell_lines,{'string','cell'})}
    filter_save {mustBeA(filter_save,{'dictionary'})}
    polygon_shape
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

    if isKey(variant_dictionary,condition2)
        %replace entry with corrected polygon index
        variant_dictionary(condition2) = {[polygon_shape(:,2),polygon_shape(:,1)]};
    else
        %either create or replace polygon fit
        variant_dictionary(condition1) = {polygon_shape};
    end

    filter_save(selected_cell_lines(i)) = variant_dictionary;
end

end

