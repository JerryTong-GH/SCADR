function [datasets_dictionary_marker_absolute_limits,...
    datasets_dictionary_absolute_filter_bounds, ...
    datasets_dictionary_quantile_fitler_bounds, ...
    datasets_dictionary_polygon_filter] = ...
    initialise_filter_dictionaries_upon_marker_change_2( ...
    marker_list, new2old_column_names, ...
    datasets_dictionary, ...
    datasets_dictionary_marker_absolute_limits,...
    datasets_dictionary_absolute_filter_bounds, ...
    datasets_dictionary_quantile_fitler_bounds, ...
    datasets_dictionary_polygon_filter)
%initialise_filter_dictionaries_upon_marker_change Adds a dictionary entry for
%filter bounds if a new marker has been added
%   Detailed explanation goes here

%% Function arguments
% required inputs
arguments
    marker_list {mustBeA(marker_list,{'string','cell'})}
    new2old_column_names {mustBeA(new2old_column_names,{'dictionary'})}
    datasets_dictionary {mustBeA(datasets_dictionary,{'cell','dictionary'})}
    datasets_dictionary_marker_absolute_limits {mustBeA(datasets_dictionary_marker_absolute_limits,{'dictionary'})}
    datasets_dictionary_absolute_filter_bounds {mustBeA(datasets_dictionary_absolute_filter_bounds,{'dictionary'})}
    datasets_dictionary_quantile_fitler_bounds {mustBeA(datasets_dictionary_quantile_fitler_bounds,{'dictionary'})}
    datasets_dictionary_polygon_filter {mustBeA(datasets_dictionary_polygon_filter,{'dictionary'})}
end

%% Find max and min values for particular marker across all data sets

%ensure string data type
marker_list = cellstr(marker_list);
old_name_marker_list = new2old_column_names(marker_list);

marker_list = string(marker_list);
old_name_marker_list = string(old_name_marker_list);

% cell_line_names = original_data_sets.keys;

% if isequal(class(original_data_sets),'dictionary')
%     original_data_sets = original_data_sets(cell_line_names);
% end

%% Create dictionary entry for new variants

dataset_list = datasets_dictionary.keys;
if numel(dataset_list)<1
    return
end

%% For each variants pack in a dataset
for k = 1:numel(dataset_list)
    variants_pack = datasets_dictionary(dataset_list(k));

    %% Initialise pack dictionaries
    if ~isKey(datasets_dictionary_marker_absolute_limits,dataset_list(k))
        datasets_dictionary_marker_absolute_limits(dataset_list(k)) = dictionary(string.empty,dictionary());
        datasets_dictionary_absolute_filter_bounds(dataset_list(k)) = dictionary(string.empty,dictionary());
        datasets_dictionary_quantile_fitler_bounds(dataset_list(k)) = dictionary(string.empty,dictionary());
        datasets_dictionary_polygon_filter(dataset_list(k)) = dictionary(string.empty,dictionary());
    end

    pack_absolute_limits = datasets_dictionary_marker_absolute_limits(dataset_list(k));
    pack_absolute_filter_bounds = datasets_dictionary_absolute_filter_bounds(dataset_list(k));
    pack_quantile_filter_bounds = datasets_dictionary_quantile_fitler_bounds(dataset_list(k));
    pack_polygon_filter = datasets_dictionary_polygon_filter(dataset_list(k));

    cell_line_names = variants_pack.keys;

    %% For each cell line in a variants pack
    if numel(marker_list)>0&&numel(cell_line_names)>0
        for i = 1:numel(cell_line_names)
            if ~isKey(pack_absolute_limits,cell_line_names(i))
                %create new dictionary for new cell line entry with absolute
                %min and max values
                pack_absolute_limits(cell_line_names(i)) = dictionary(string.empty,cell.empty);
                pack_absolute_filter_bounds(cell_line_names(i)) = dictionary(string.empty,cell.empty);
                pack_quantile_filter_bounds(cell_line_names(i)) = dictionary(string.empty,cell.empty);
                pack_polygon_filter(cell_line_names(i)) = dictionary(cell.empty,cell.empty);
            end

            cell_line_absolute_limits = pack_absolute_limits(cell_line_names(i));
            cell_line_absolute_filter_bounds = pack_absolute_filter_bounds(cell_line_names(i));
            cell_line_quantile_fitler_bounds = pack_quantile_filter_bounds(cell_line_names(i));

            %% Create dictionary entry for each cell lines with each newly added markers
            for j = 1:numel(marker_list)
                if ~isKey(cell_line_absolute_limits,marker_list(j))
                    cell_line_data = variants_pack(cell_line_names(i));
                    cell_line_data = cell_line_data{1};

                    %% Initialise filter values
                    cell_line_absolute_limits(marker_list(j)) = {[min(cell_line_data.(old_name_marker_list(j))),max(cell_line_data.(old_name_marker_list(j)))]};
                    cell_line_absolute_filter_bounds(marker_list(j)) = {[min(cell_line_data.(old_name_marker_list(j))),max(cell_line_data.(old_name_marker_list(j)))]};
                    cell_line_quantile_fitler_bounds(marker_list(j)) = {[0,100]};
                end
            end

            %% Save marker filter values to respective cell lines in a pack
            pack_absolute_limits(cell_line_names(i)) = cell_line_absolute_limits;
            pack_absolute_filter_bounds(cell_line_names(i)) = cell_line_absolute_filter_bounds;
            pack_quantile_filter_bounds(cell_line_names(i)) = cell_line_quantile_fitler_bounds;
        end
        %% Save pack dictionaries to datasets dictionary
        datasets_dictionary_marker_absolute_limits(dataset_list(k)) = pack_absolute_limits;
        datasets_dictionary_absolute_filter_bounds(dataset_list(k)) = pack_absolute_filter_bounds;
        datasets_dictionary_quantile_fitler_bounds(dataset_list(k)) = pack_quantile_filter_bounds;
        datasets_dictionary_polygon_filter(dataset_list(k)) = pack_polygon_filter;
    end
end

end