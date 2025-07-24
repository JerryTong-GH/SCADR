function [total_data_sets] = expression_channel_filter(total_data_sets,expression_channel_name, ...
    do_expression_channel_filter,expression_channel_filter_bounds)
%EXPRESSION_CHANNEL_FILTER Summary of this function goes here
%   Detailed explanation goes here
if do_expression_channel_filter
    for i = 1:numel(total_data_sets)
        
        condition_lower = (total_data_sets{i}.(expression_channel_name)>= ...
            (expression_channel_filter_bounds("lowerbound")));
        condition_upper = (total_data_sets{i}.(expression_channel_name)<= ...
            (expression_channel_filter_bounds("upperbound")));

        total_data_sets{i} = total_data_sets{i}((condition_lower&condition_upper),:);
    end
end


end

