function [index_for_data] = array_of_array(cell_line_names,selected_cell_lines)
%ARRAY_OF_ARRAY Summary of this function goes here
%   Detailed explanation goes here

arguments
    cell_line_names {mustBeA(cell_line_names,{'string','cell'})} % master list
    selected_cell_lines {mustBeA(selected_cell_lines,{'string','cell'})} % search list
end

%isolate data for selected variants
selected_cell_lines = string(selected_cell_lines);
cell_line_names = string(cell_line_names)';

index_for_data = zeros(numel(cell_line_names),1);

for i = 1:numel(selected_cell_lines)
    index_for_data =  index_for_data|(cell_line_names==selected_cell_lines(i));
end

end

