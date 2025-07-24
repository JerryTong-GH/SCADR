function [total_data_sets] = quantile_channel_filter_2(total_data_sets,marker_list, ...
    quantile_filter_bounds,cell_line_names)
%quantile_channel_filter_2 Summary of this function goes here
%   Detailed explanation goes here

%% Define arguments
arguments
    %import variables
    total_data_sets {mustBeA(total_data_sets,{'table','cell','dictionary'})}
    %which channels are relevant markers
    marker_list {mustBeA(marker_list,{'string','cell'})}
    %lower and upper absolute marker filters
    quantile_filter_bounds {mustBeA(quantile_filter_bounds,'dictionary')}
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
            filter_range = quantile_filter_bounds(cell_line_names(i));

            %% Find the absolute threshold corresponding to quantile value for each marker
            quantile2absolute_threshold_min = dictionary();
            quantile2absolute_threshold_max = dictionary();

            for j = 1:numel(marker_list)
                range = filter_range(marker_list(j));
                marker_min = range{1}(1);
                marker_max = range{1}(2);

                quantile2absolute_threshold_min(marker_list(j)) = prctile(total_data_sets{i}.(marker_list(j)),marker_min);
                quantile2absolute_threshold_max(marker_list(j)) = prctile(total_data_sets{i}.(marker_list(j)),marker_max);
            end

            %% Apply the absolute threshold for each marker
            for j = 1:numel(marker_list)

                condition_lower = total_data_sets{i}.(marker_list(j))>=quantile2absolute_threshold_min(marker_list(j));
                condition_upper = total_data_sets{i}.(marker_list(j))<=quantile2absolute_threshold_max(marker_list(j));

                total_data_sets{i} = total_data_sets{i}((condition_lower&condition_upper),:);
            end


            %             for j = 1:numel(marker_list)
            %                 range = filter_range(marker_list(j));
            %                 marker_min = range{1}(1);
            %                 marker_max = range{1}(2);
            %
            %                 condition_lower = total_data_sets{i}.(marker_list(j))>prctile(total_data_sets{i}.(marker_list(j)),marker_min);
            %                 condition_upper = total_data_sets{i}.(marker_list(j))<prctile(total_data_sets{i}.(marker_list(j)),marker_max);
            %
            %                 total_data_sets{i} = total_data_sets{i}((condition_lower&condition_upper),:);
            %             end


        end
        total_data_sets = dictionary(cell_line_names,total_data_sets);

    case "cell"
        for i = 1:numel(total_data_sets)
            filter_range = quantile_filter_bounds(cell_line_names(i));

            %% Find the absolute threshold corresponding to quantile value for each marker
            quantile2absolute_threshold_min = dictionary();
            quantile2absolute_threshold_max = dictionary();

            for j = 1:numel(marker_list)
                range = filter_range(marker_list(j));
                marker_min = range{1}(1);
                marker_max = range{1}(2);

                quantile2absolute_threshold_min(marker_list(j)) = prctile(total_data_sets{i}.(marker_list(j)),marker_min);
                quantile2absolute_threshold_max(marker_list(j)) = prctile(total_data_sets{i}.(marker_list(j)),marker_max);
            end

            %% Apply the absolute threshold for each marker
            for j = 1:numel(marker_list)

                condition_lower = total_data_sets{i}.(marker_list(j))>=quantile2absolute_threshold_min(marker_list(j));
                condition_upper = total_data_sets{i}.(marker_list(j))<=quantile2absolute_threshold_max(marker_list(j));

                total_data_sets{i} = total_data_sets{i}((condition_lower&condition_upper),:);
            end

            %             for j = 1:numel(marker_list)
            %                 range = filter_range(marker_list(j));
            %                 marker_min = range{1}(1);
            %                 marker_max = range{1}(2);
            %
            %                 condition_lower = total_data_sets{i}.(marker_list(j))>prctile(total_data_sets{i}.(marker_list(j)),marker_min);
            %                 condition_upper = total_data_sets{i}.(marker_list(j))<prctile(total_data_sets{i}.(marker_list(j)),marker_max);
            %
            %                 total_data_sets{i} = total_data_sets{i}((condition_lower&condition_upper),:);
            %             end

        end

    case "table"
        %% Find the absolute threshold corresponding to quantile value for each marker
        quantile2absolute_threshold_min = dictionary();
        quantile2absolute_threshold_max = dictionary();

        for j = 1:numel(marker_list)
            range = quantile_filter_bounds(marker_list(j));
            marker_min = range{1}(1);
            marker_max = range{1}(2);

            quantile2absolute_threshold_min(marker_list(j)) = prctile(total_data_sets.(marker_list(j)),marker_min);
            quantile2absolute_threshold_max(marker_list(j)) = prctile(total_data_sets.(marker_list(j)),marker_max);
        end

        %% Apply the absolute threshold for each marker
        for j = 1:numel(marker_list)

            condition_lower = total_data_sets.(marker_list(j))>=quantile2absolute_threshold_min(marker_list(j));
            condition_upper = total_data_sets.(marker_list(j))<=quantile2absolute_threshold_max(marker_list(j));

            total_data_sets = total_data_sets((condition_lower&condition_upper),:);
        end

end

end

