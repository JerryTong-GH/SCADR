function [filter_save] = delete_polygon_filter_2(xvar,yvar,selected_data_set,selected_cell_lines,filter_save)
%SAVE_POLYGON_FILTER Summary of this function goes here
%   Detailed explanation goes here

%% Function arguments
% required inputs
arguments
    xvar {mustBeA(xvar,{'string','char','cell'})}
    yvar {mustBeA(yvar,{'string','char','cell'})}
    selected_data_set {mustBeA(selected_data_set,{'string','cell'})}
    selected_cell_lines {mustBeA(selected_cell_lines,{'string','cell'})}
    filter_save {mustBeA(filter_save,{'dictionary'})}
end

%% Function begins
% initialise
xvar = string(xvar);
yvar = string(yvar);
selected_data_set = string(selected_data_set);
selected_cell_lines = string(selected_cell_lines);

% go through each data set
for j = 1:numel(selected_data_set)
    variant_pack_filter = filter_save(selected_data_set(j));

    % go through each selected cell line and change range
    for i = 1:numel(selected_cell_lines)
        cell_line_filter = variant_pack_filter(selected_cell_lines(i));

        condition1 = {[xvar,yvar]};
        condition2 = {[yvar,xvar]};

        if isKey(cell_line_filter,condition2)
            %replace entry with corrected polygon index
            cell_line_filter(condition2) = [];
        elseif isKey(cell_line_filter,condition1)
            %either create or replace polygon fit
            cell_line_filter(condition1) = [];
        end

        variant_pack_filter(selected_cell_lines(i)) = cell_line_filter;
    end
    filter_save(selected_data_set(j)) = variant_pack_filter;
end

end

