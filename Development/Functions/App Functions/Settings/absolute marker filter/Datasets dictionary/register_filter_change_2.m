function [filter_save] = register_filter_change_2( ...
    selected_datasets, ...
    selected_cell_lines, ...
    selected_marker, ...
    filter_save, ...
    lower_val,upper_val)
%REGISTER_FILTER_CHANGE Summary of this function goes here
%   Detailed explanation goes here

%% Function arguments
% required inputs
arguments
    selected_datasets {mustBeA(selected_datasets,{'string','cell'})}
    selected_cell_lines {mustBeA(selected_cell_lines,{'string','cell'})}
    selected_marker {mustBeA(selected_marker,{'string','char','cell'})}
    filter_save {mustBeA(filter_save,{'dictionary'})}
    lower_val {mustBeNumeric}
    upper_val {mustBeNumeric}
end

%% Function begins
% initialise
selected_datasets = string(selected_datasets);
selected_marker = string(selected_marker);
selected_cell_lines = string(selected_cell_lines);

range = {[lower_val,upper_val]};

% go through each selected data set
for k = 1:numel(selected_datasets)
    variant_pack = filter_save(selected_datasets(k));
    % go through each selected cell line and change range
    for i = 1:numel(selected_cell_lines)
        if isKey(variant_pack,selected_cell_lines(i))
            marker_dictionary = variant_pack(selected_cell_lines(i));
            for j = 1:numel(selected_marker)
                marker_dictionary(selected_marker(j)) = range;
            end
            variant_pack(selected_cell_lines(i)) = marker_dictionary;
        end
    end
    filter_save(selected_datasets(k)) = variant_pack;
end

end

