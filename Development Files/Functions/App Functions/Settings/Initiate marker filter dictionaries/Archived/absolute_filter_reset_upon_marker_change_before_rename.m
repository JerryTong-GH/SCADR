function [marker_list_absolute_filter_upper_bounds,marker_list_absolute_filter_lower_bounds,...
    marker_list_absolute_filter_upper_limits,marker_list_absolute_filter_lower_limits] = absolute_filter_reset_upon_marker_change_before_rename( ...
    marker_list, total_data_sets, ...
    marker_list_absolute_filter_upper_bounds,marker_list_absolute_filter_lower_bounds, ...
    marker_list_absolute_filter_upper_limits,marker_list_absolute_filter_lower_limits)
%ABSOLUTE_FILTER_RESET_UPON_MARKER_CHANGE Adds a dictionary entry for
%filter bounds if a new marker has been added
%   Detailed explanation goes here

if numel(marker_list)>0
    for i = 1:numel(marker_list)

        upperval = max(total_data_sets{1}.(marker_list{i}));
        lowerval = min(total_data_sets{1}.(marker_list{i}));

        for j = 1:numel(total_data_sets)

            upperval = max(upperval,max(total_data_sets{j}.(marker_list{i})));
            lowerval = min(lowerval,min(total_data_sets{j}.(marker_list{i})));

        end

        %If the dictionary is not empty
        if marker_list_absolute_filter_upper_bounds.numEntries>0
            if ~isKey(marker_list_absolute_filter_upper_bounds,marker_list{i})

                marker_list_absolute_filter_upper_bounds(string(marker_list{i})) = upperval;
                marker_list_absolute_filter_lower_bounds(string(marker_list{i})) = lowerval;

                marker_list_absolute_filter_upper_limits(string(marker_list{i})) = upperval;
                marker_list_absolute_filter_lower_limits(string(marker_list{i})) = lowerval;

            end

        else %If the dictionary is empty

            marker_list_absolute_filter_upper_bounds(string(marker_list{i})) = upperval;
            marker_list_absolute_filter_lower_bounds(string(marker_list{i})) = lowerval;

            marker_list_absolute_filter_upper_limits(string(marker_list{i})) = upperval;
            marker_list_absolute_filter_lower_limits(string(marker_list{i})) = lowerval;

        end
    end
end

end