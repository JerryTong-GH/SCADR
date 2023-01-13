function [plot_data] = histogram_channel_distribution_plot_data(total_data_sets,cell_line_names, ...
    selected_cell_lines,selected_marker,...
    marker_min,marker_max, ...
    quantile_min,quantile_max, ...
    WhichfiltergoesfirstSwitch)
%HISTOGRAM_CHANNEL_DISTRIBUTION_PLOT_DATA Summary of this function goes here
%   Detailed explanation goes here

%ensure cell or string is string
selected_marker = string(selected_marker);

%% selected data
switch class(total_data_sets)
    case 'cell'
        index_for_data = array_of_array(cell_line_names,selected_cell_lines);
        selected_data = total_data_sets(index_for_data);
    case 'dictionary'
        selected_data = total_data_sets(selected_cell_lines);
end

%% longest column read
longest_read = 0;
for i = 1:numel(selected_data)
    longest_read = max(longest_read,numel(selected_data{i}.(selected_marker)));
end

%% plot data
plot_data = nan(longest_read,numel(selected_cell_lines));

for i = 1:numel(selected_data)
    plot_data(1:numel(selected_data{i}.(selected_marker)),i) = selected_data{i}.(selected_marker);
end


%% Filter with bounds

if string(WhichfiltergoesfirstSwitch) == string('Absolute')
    % Filter with current absolute filter bounds
    plot_data(plot_data<marker_min) = nan;
    plot_data(plot_data>marker_max) = nan;

    % Filter with current quantile filter bounds
    for i = 1:numel(selected_cell_lines)
        temp_index_min = plot_data(:,i)<prctile(plot_data(:,i),quantile_min);
        temp_index_max = plot_data(:,i)>prctile(plot_data(:,i),quantile_max);
        plot_data(temp_index_min|temp_index_max,i) = nan;
    end
else
    % Filter with current quantile filter bounds
    for i = 1:numel(selected_cell_lines)
        temp_index_min = plot_data(:,i)<prctile(plot_data(:,i),quantile_min);
        temp_index_max = plot_data(:,i)>prctile(plot_data(:,i),quantile_max);
        plot_data(temp_index_min|temp_index_max,i) = nan;
    end
    % Filter with current absolute filter bounds
    plot_data(plot_data<marker_min) = nan;
    plot_data(plot_data>marker_max) = nan;
end

