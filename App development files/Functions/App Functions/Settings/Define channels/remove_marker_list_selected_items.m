function [marker_list] = remove_marker_list_selected_items(marker_list,selected)
%REMOVE_MARKER_LIST_SELECTED_ITEM Summary of this function goes here
%   Detailed explanation goes here
indexes_for_rubbish = [];
if numel(selected)>0
    for i = 1:numel(selected)
        for j = 1:numel(marker_list)
            if string(selected{i})==string(marker_list{j})
                indexes_for_rubbish = [indexes_for_rubbish,j];
            end
        end
    end
end

if numel(indexes_for_rubbish)>0
    marker_list(indexes_for_rubbish) = [];
end

end

