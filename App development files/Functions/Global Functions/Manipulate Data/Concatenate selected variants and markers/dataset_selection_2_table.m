function [master_table,variant_ID,variant_ID_num,num_cells] = dataset_selection_2_table(total_data_sets,selected_cell_lines,selected_markers)
%DATASET_SELECTION_2_TABLE Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    total_data_sets {mustBeA(total_data_sets,{'cell','dictionary'})}
    selected_cell_lines {mustBeA(selected_cell_lines,{'string','cell'})}
    selected_markers {mustBeA(selected_markers,{'string','char'})}
end
%% Function starts
%% Selected data
switch class(total_data_sets)
    case 'cell'
        selected_data = total_data_sets;
    case 'dictionary'
        selected_data = total_data_sets(selected_cell_lines);
end

%% Initialise variables
selected_cell_lines = string(selected_cell_lines);
selected_markers = string(selected_markers);

%% Concatenate all tables from selected variants
num_markers = numel(selected_markers);
num_cell_lines = numel(selected_cell_lines);
master_table = table('Size',[0,num_markers], ...
    'VariableTypes',cellstr(repelem("double",num_markers)), ...
    'VariableNames',selected_markers);
num_cells = zeros(num_cell_lines,1);
for i = 1:num_cell_lines
    data = selected_data{i}(:,selected_markers);
    num_cells(i) = size(data,1);
    master_table = [master_table;data];
end

variant_ID = repelem(selected_cell_lines,num_cells);
variant_ID_num = repelem(1:num_cell_lines,num_cells);
master_table.variant_ID = variant_ID';
master_table.variant_ID_num = variant_ID_num';

end

