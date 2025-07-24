function [original_variants_marker_absolute_limits,...
    original_variants_marker_absolute_filter_bounds,original_variants_marker_quantile_fitler_bounds,original_variants_marker_polygon_filter] = ...
initialise_filter_dictionaries_upon_marker_change( ...
    marker_list, new2old_column_names, cell_line_names, ...
    original_data_sets, ...
    original_variants_marker_absolute_limits,...
    original_variants_marker_absolute_filter_bounds,original_variants_marker_quantile_fitler_bounds, ...
    original_variants_marker_polygon_filter)
%initialise_filter_dictionaries_upon_marker_change Adds a dictionary entry for
%filter bounds if a new marker has been added
%   Detailed explanation goes here

%% Function arguments
% required inputs
arguments
    marker_list {mustBeA(marker_list,{'string','cell'})}
    new2old_column_names {mustBeA(new2old_column_names,{'dictionary'})}
    cell_line_names {mustBeA(cell_line_names,{'string','cell'})}
    original_data_sets {mustBeA(original_data_sets,{'cell','dictionary'})}
    original_variants_marker_absolute_limits {mustBeA(original_variants_marker_absolute_limits,{'dictionary'})}
    original_variants_marker_absolute_filter_bounds {mustBeA(original_variants_marker_absolute_filter_bounds,{'dictionary'})}
    original_variants_marker_quantile_fitler_bounds {mustBeA(original_variants_marker_quantile_fitler_bounds,{'dictionary'})}
    original_variants_marker_polygon_filter {mustBeA(original_variants_marker_polygon_filter,{'dictionary'})}
end

%% Find max and min values for particular marker across all data sets

% original_absolute_limits = find_min_max_values_across_all_data_sets(marker_list,new2old_column_names,original_data_sets);

%ensure string data type
marker_list = cellstr(marker_list);
old_name_marker_list = new2old_column_names(marker_list);

marker_list = string(marker_list);
old_name_marker_list = string(old_name_marker_list);

if isequal(class(original_data_sets),'dictionary')
    original_data_sets = original_data_sets(cell_line_names);
end

%% Create dictionary entry for new variants

if numel(marker_list)>0&&numel(cell_line_names)>0
    for i = 1:numel(cell_line_names)
        if ~isKey(original_variants_marker_absolute_limits,cell_line_names(i))
            %create new dictionary for new cell line entry with absolute
            %min and max values
            original_variants_marker_absolute_limits(cell_line_names(i)) = dictionary(string.empty,cell.empty);
            original_variants_marker_absolute_filter_bounds(cell_line_names(i)) = dictionary(string.empty,cell.empty);
            original_variants_marker_quantile_fitler_bounds(cell_line_names(i)) = dictionary(string.empty,cell.empty);
            original_variants_marker_polygon_filter(cell_line_names(i)) = dictionary(cell.empty,cell.empty);
        end

        %% Create dictionary entry for variants with newly added markers
        for j = 1:numel(marker_list)
            temp_original_variants_marker_absolute_limits = original_variants_marker_absolute_limits(cell_line_names(i));
            temp_original_variants_marker_absolute_filter_bounds = original_variants_marker_absolute_filter_bounds(cell_line_names(i));
            temp_original_variants_marker_quantile_fitler_bounds = original_variants_marker_quantile_fitler_bounds(cell_line_names(i));

            if ~isKey(temp_original_variants_marker_absolute_limits,marker_list(j))
                temp_original_variants_marker_absolute_limits(marker_list(j)) = {[min(original_data_sets{i}.(old_name_marker_list(j))),max(original_data_sets{i}.(old_name_marker_list(j)))]};
                temp_original_variants_marker_absolute_filter_bounds(marker_list(j)) = {[min(original_data_sets{i}.(old_name_marker_list(j))),max(original_data_sets{i}.(old_name_marker_list(j)))]};

                temp_original_variants_marker_quantile_fitler_bounds(marker_list(j)) = {[0,100]};

                original_variants_marker_absolute_limits(cell_line_names(i)) = temp_original_variants_marker_absolute_limits;
                original_variants_marker_absolute_filter_bounds(cell_line_names(i)) = temp_original_variants_marker_absolute_filter_bounds;
                original_variants_marker_quantile_fitler_bounds(cell_line_names(i)) = temp_original_variants_marker_quantile_fitler_bounds;
            end
        end
    end
end

end