function [old_column_names_list,new_column_names_list] = remove_channel_renames( ...
    old_column_names_list,new_column_names_list, ...
    old_selected,new_selected)
%REMOVE_CHANNEL_RENAMES Summary of this function goes here
%   Detailed explanation goes here
if numel(new_selected)>0
    for i = 1:numel(new_selected)
        new_column_names_list = new_column_names_list(string(new_column_names_list)~=string(new_selected{i}));
        old_column_names_list = old_column_names_list(string(old_column_names_list)~=string(old_selected{i}));
    end
end

end

