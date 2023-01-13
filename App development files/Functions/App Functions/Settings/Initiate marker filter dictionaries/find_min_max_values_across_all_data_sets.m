function [absolute_limits] = ...
find_min_max_values_across_all_data_sets(marker_list,new2old_column_names,original_data_sets)
%find_min_max_values_across_all_data_sets Iterate through all marker
%channels and find the min and max value 
%   Detailed explanation goes here

%% Function arguments
% required inputs
arguments
    marker_list {mustBeA(marker_list,{'string','cell'})}
    new2old_column_names {mustBeA(new2old_column_names,{'dictionary'})}
    original_data_sets {mustBeA(original_data_sets,{'cell','dictionary'})}
end

%% Function begins
%initialise output
absolute_limits = dictionary(string.empty,cell.empty);
if isequal(class(original_data_sets),'dictionary')
    original_data_sets = original_data_sets.values;
end

marker_list_old = new2old_column_names(marker_list);

if numel(marker_list_old)>0&&numel(original_data_sets)>0
    for i = 1:numel(marker_list_old)

        upperval = max(original_data_sets{1}.(marker_list_old{i}));
        lowerval = min(original_data_sets{1}.(marker_list_old{i}));

        for j = 1:numel(original_data_sets)

            upperval = max(upperval,max(original_data_sets{j}.(marker_list_old{i})));
            lowerval = min(lowerval,min(original_data_sets{j}.(marker_list_old{i})));

        end
        %save upper and lower values to dictionary
        absolute_limits(marker_list{i}) = {[lowerval, upperval]};

    end
end

end

