function [total_data_sets] = quantile_channel_filter(total_data_sets,do_quantile_filter, ...
    new_column_names,quantile_filter_bounds)
%QUANTILE_CHANNEL_FILTER Summary of this function goes here
%   Detailed explanation goes here
if do_quantile_filter
    for i = 1:numel(total_data_sets)
        for j = 1:numel(new_column_names)

            condition_lower = (total_data_sets{i}.(new_column_names(j))>= ...
                (prctile(total_data_sets{i}.(new_column_names(j)),quantile_filter_bounds("lowerbound"))));
            condition_upper = (total_data_sets{i}.(new_column_names(j))<= ...
                (prctile(total_data_sets{i}.(new_column_names(j)),quantile_filter_bounds("upperbound"))));

            total_data_sets{i} = total_data_sets{i}((condition_lower&condition_upper),:);
            
        end
    end
end

end

