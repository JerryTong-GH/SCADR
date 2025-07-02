function [new_cell_line_names] = index_repeat_names(new_cell_line_names)
%INDEX_REPEAT_NAMES Summary of this function goes here
%   Detailed explanation goes here
    for i = 1:numel(new_cell_line_names)
        name_count = sum(new_cell_line_names==new_cell_line_names(i));
        if name_count>1
            replacement_string = repelem(new_cell_line_names(i),name_count);
            for j = 1:name_count
                replacement_string(j) = strcat(replacement_string(j),"_",string(j));
            end
            new_cell_line_names(new_cell_line_names==new_cell_line_names(i)) = replacement_string';
        end
    end
end

