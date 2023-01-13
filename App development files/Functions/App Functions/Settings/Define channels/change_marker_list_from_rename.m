function [marker_list] = change_marker_list_from_rename(marker_list,OldcolumnnamesList,NewcolumnnamesList)
%CHANGE_MARKER_LIST Summary of this function goes here
%   Detailed explanation goes here
if numel(marker_list)>0
    for i = 1:numel(NewcolumnnamesList)
        is_match = 0;
        for j = 1:numel(marker_list)
            condition1 = string(marker_list{j})==string(NewcolumnnamesList{i});
            condition2 = string(marker_list{j})==string(OldcolumnnamesList{i});
            if (condition1||condition2)
                is_match = 1;
            end
        end

        if ~is_match
            marker_list{end+1} = NewcolumnnamesList{i};
        end
        
    end
else
    marker_list = NewcolumnnamesList;
end

end

