function [filter_save] = register_filter_change(selected_marker,selected_cell_lines,filter_save,lower_val,upper_val)
%REGISTER_FILTER_CHANGE Summary of this function goes here
%   Detailed explanation goes here

%% Function arguments
% required inputs
arguments
    selected_marker {mustBeA(selected_marker,{'string','char','cell'})}
    selected_cell_lines {mustBeA(selected_cell_lines,{'string','cell'})}
    filter_save {mustBeA(filter_save,{'dictionary'})}
    lower_val {mustBeNumeric}
    upper_val {mustBeNumeric}
end

%% Function begins
% initialise
selected_marker = string(selected_marker);
selected_cell_lines = string(selected_cell_lines);

range = {[lower_val,upper_val]};

% go through each selected cell line and change range
for i = 1:numel(selected_cell_lines)
    variant_dictionary = filter_save(selected_cell_lines(i));
    for j = 1:numel(selected_marker)
        variant_dictionary(selected_marker(j)) = range;
    end
    filter_save(selected_cell_lines(i)) = variant_dictionary;
end

end

