function [slider_min,slider_max,marker_min,marker_max,quantile_min,quantile_max] = filters_min_max_2(selected_data_set,selected_cell_lines,selected_marker, ...
    dataset_absolute_limits, ...
    dataset_absolute_filter, ...
    dataset_quantile_filter)
%SLIDER_MIN_MAX Summary of this function goes here
%   Detailed explanation goes here
%% Function arguments
% required inputs
arguments
    selected_data_set {mustBeA(selected_data_set,{'string','cell'})}
    selected_cell_lines {mustBeA(selected_cell_lines,{'string','cell'})}
    selected_marker {mustBeA(selected_marker,{'string','char'})}
    dataset_absolute_limits {mustBeA(dataset_absolute_limits,{'dictionary'})}
    dataset_absolute_filter {mustBeA(dataset_absolute_filter,{'dictionary'})}
    dataset_quantile_filter {mustBeA(dataset_quantile_filter,{'dictionary'})}
end

%% Function begins
%% Initialise output
slider_min = nan;
slider_max = nan;
marker_min = nan;
marker_max = nan;
quantile_min = nan;
quantile_max = nan;

%% initialise input
selected_marker = string(selected_marker);
selected_cell_lines = string(selected_cell_lines);
selected_data_set = string(selected_data_set);

%% Initialise for single selected variant
% Chosen dataset filter dictionaries
pack_absolute_limits = dataset_absolute_limits(selected_data_set);
pack_absolute_filter = dataset_absolute_filter(selected_data_set);
pack_quantile_filter = dataset_quantile_filter(selected_data_set);

% Extracted ranges
slider_range = pack_absolute_limits(selected_cell_lines(1));
marker_range = pack_absolute_filter(selected_cell_lines(1));
quantile_range = pack_quantile_filter(selected_cell_lines(1));

%specify marker
slider_range = slider_range(selected_marker);
marker_range = marker_range(selected_marker);
quantile_range = quantile_range(selected_marker);

%Find the maximum across all values for filter range
if isempty(marker_range{1})
    return
end

marker_min = marker_range{1}(1);
marker_max = marker_range{1}(2);

slider_min = slider_range{1}(1);
slider_max = slider_range{1}(2);

quantile_min = quantile_range{1}(1);
quantile_max = quantile_range{1}(2);

%% For multiple cell lines
for i = 2:numel(selected_cell_lines)
    slider_range = pack_absolute_limits(selected_cell_lines(i));
    marker_range = pack_absolute_filter(selected_cell_lines(i));
    quantile_range = pack_quantile_filter(selected_cell_lines(i));

    %specify marker
    slider_range = slider_range(selected_marker);
    marker_range = marker_range(selected_marker);
    quantile_range = quantile_range(selected_marker);

    %set min and max
    marker_min = min(marker_min,marker_range{1}(1));
    marker_max = max(marker_max,marker_range{1}(2));

    slider_min = min(slider_min,slider_range{1}(1));
    slider_max = max(slider_max,slider_range{1}(2));

    quantile_min = min(quantile_min,quantile_range{1}(1));
    quantile_max = max(quantile_max,quantile_range{1}(2));
end

end

