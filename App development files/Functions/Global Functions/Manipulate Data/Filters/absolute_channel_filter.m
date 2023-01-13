function [total_data_sets] = absolute_channel_filter( ...
    total_data_sets, marker_list, ...
    absolute_filter_bounds, ...
    cell_line_names)
%ABSOLUTE_CHANNEL_FILTER Summary of this function goes here
%   Detailed explanation goes here

%% Define arguments
arguments
    %import variables
    total_data_sets {mustBeA(total_data_sets,{'table','cell','dictionary'})}
    %which channels are relevant markers
    marker_list {mustBeA(marker_list,{'string','cell'})}
    %lower and upper absolute marker filters
    absolute_filter_bounds {mustBeA(absolute_filter_bounds,'dictionary')}
end

% Optional arguments
arguments
    cell_line_names {mustBeA(cell_line_names,{'string','cell'})} = ""
end

%% Function Starts
switch string(class(total_data_sets))
    
    case "dictionary"
        cell_line_names = total_data_sets.keys;
        total_data_sets = total_data_sets.values;
        for i = 1:numel(total_data_sets)
            filter_range = absolute_filter_bounds(cell_line_names(i));
            for j = 1:numel(marker_list)
                range = filter_range(marker_list(j));
                if isempty(range{1})
                    continue
                end
                marker_min = range{1}(1);
                marker_max = range{1}(2);

                condition_lower = total_data_sets{i}.(marker_list(j))>=marker_min;
                condition_upper = total_data_sets{i}.(marker_list(j))<=marker_max;

                total_data_sets{i} = total_data_sets{i}((condition_lower&condition_upper),:);
            end
        end
        total_data_sets = dictionary(cell_line_names,total_data_sets);

    case "cell"
        for i = 1:numel(total_data_sets)
            filter_range = absolute_filter_bounds(cell_line_names(i));
            for j = 1:numel(marker_list)
                range = filter_range(marker_list(j));
                marker_min = range{1}(1);
                marker_max = range{1}(2);

                condition_lower = total_data_sets{i}.(marker_list(j))>=marker_min;
                condition_upper = total_data_sets{i}.(marker_list(j))<=marker_max;

                total_data_sets{i} = total_data_sets{i}((condition_lower&condition_upper),:);
            end
        end

    case "table"
        for j = 1:numel(marker_list)
            range = absolute_filter_bounds(marker_list(j));
            marker_min = range{1}(1);
            marker_max = range{1}(2);

            condition_lower = total_data_sets.(marker_list(j))>=marker_min;
            condition_upper = total_data_sets.(marker_list(j))<=marker_max;

            total_data_sets = total_data_sets((condition_lower&condition_upper),:);
        end
end

end

