function [slider_min,slider_max,marker_min,marker_max,quantile_min,quantile_max] = filters_min_max(selected_marker,selected_cell_lines,absolute_limits,absolute_filter,quantile_filter)
%SLIDER_MIN_MAX Summary of this function goes here
%   Detailed explanation goes here
%% Function arguments
% required inputs
arguments
    selected_marker {mustBeA(selected_marker,{'string','char'})}
    selected_cell_lines {mustBeA(selected_cell_lines,{'string','cell'})}
    absolute_limits {mustBeA(absolute_limits,{'dictionary'})}
    absolute_filter {mustBeA(absolute_filter,{'dictionary'})}
    quantile_filter {mustBeA(quantile_filter,{'dictionary'})}
end

%% Function begins
% initialise
selected_marker = string(selected_marker);
selected_cell_lines = string(selected_cell_lines);

%% Initialise for single selected variant
slider_range = absolute_limits(selected_cell_lines(1));
marker_range = absolute_filter(selected_cell_lines(1));
quantile_range = quantile_filter(selected_cell_lines(1));

%specify marker
slider_range = slider_range(selected_marker);
marker_range = marker_range(selected_marker);
quantile_range = quantile_range(selected_marker);

%Find the maximum across all values for filter range
marker_min = marker_range{1}(1);
marker_max = marker_range{1}(2);

slider_min = slider_range{1}(1);
slider_max = slider_range{1}(2);

quantile_min = quantile_range{1}(1);
quantile_max = quantile_range{1}(2);

%% For multiple cell lines
for i = 1:numel(selected_cell_lines)
    slider_range = absolute_limits(selected_cell_lines(i));
    marker_range = absolute_filter(selected_cell_lines(i));
    quantile_range = quantile_filter(selected_cell_lines(i));

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

