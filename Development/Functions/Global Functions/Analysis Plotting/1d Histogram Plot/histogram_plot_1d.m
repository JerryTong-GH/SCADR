function [fig,plot_data,cell_count] = histogram_plot_1d(total_data_sets, ...
    selected_cell_lines,selected_marker,options,options_1d)
%2D_SCATTER_PLOT Summary of this function goes here
%   Detailed explanation goes here
%   'axis'    -  target axis to plot

%% Function arguments
% required inputs
arguments (Input)
    total_data_sets {mustBeA(total_data_sets,{'cell','dictionary'})}
    selected_cell_lines {mustBeA(selected_cell_lines,{'string','cell'})}
    selected_marker {mustBeA(selected_marker,{'string','char','cell'})}
end

% optional specified
arguments (Input)
    % app plot
    options.app
    options.axis {mustBeA(options.axis,{'matlab.ui.control.UIAxes','matlab.graphics.axis.Axes'})}
end

arguments (Input)
    % filters
    options_1d.absolute_filters
    options_1d.quantile_filters
    options_1d.first_filter
    % histogram bin settings
    options_1d.specify_bins_1d = 0;
    options_1d.num_bins_1d = 15;
    options_1d.specify_bin_width_1d = 0;
    options_1d.bin_width_1d = 100;
    % histogram plot data settings
    options_1d.Normalization_1d {mustBeMember(options_1d.Normalization_1d,{'count','probability','countdensity','pdf','cumcount','cdf'})} = 'count';
    options_1d.display_style_1d {mustBeMember(options_1d.display_style_1d,{'bar','stairs'})} = 'bar'
    options_1d.face_alpha_1d  = 0.6;
    options_1d.orientation_1d {mustBeMember(options_1d.orientation_1d,{'vertical','horizontal'})} = 'vertical';
    % which plots to do
    options_1d.do_histogram = 1;
    options_1d.do_histogram_edge_line = 0;
    options_1d.do_1d_legend = 1;
    options_1d.add_legend_suffix = "";
end

arguments (Output)
    fig
    plot_data
    cell_count
end

%% Function begins
%% If not using an app
cell_count = 0;
fig = 0;
if ~isfield(options,'axis')
    no_app = 1;
    fig = figure;
    options.axis = axes(fig);
end

%% Data conversions
selected_cell_lines = string(selected_cell_lines);
selected_marker = string(selected_marker);
options_1d.num_bins_1d = round(options_1d.num_bins_1d);

%% Initial checks

%% Selected data
switch class(total_data_sets)
    case 'dictionary'
        selected_data = total_data_sets(selected_cell_lines);
end

%% Create plot_data array
% longest column read
longest_read = 0;
for i = 1:numel(selected_data)
    longest_read = max(longest_read,numel(selected_data{i}.(selected_marker)));
end

% plot data
plot_data = nan(longest_read,numel(selected_cell_lines));

for i = 1:numel(selected_cell_lines)
    cell_count = cell_count + numel(selected_data{i}.(selected_marker));
    plot_data(1:numel(selected_data{i}.(selected_marker)),i) = selected_data{i}.(selected_marker);
end

%% Filter if applicable
if isfield(options_1d,'first_filter')
    switch options_1d.first_filter
        case 'Absolute'
            % Filter with current absolute filter bounds
            plot_data(plot_data<options_1d.absolute_filters(1)) = nan;
            plot_data(plot_data>options_1d.absolute_filters(2)) = nan;

            % Filter with current quantile filter bounds
            for i = 1:numel(selected_cell_lines)
                temp_index_min = plot_data(:,i)<prctile(plot_data(:,i),options_1d.quantile_filters(1));
                temp_index_max = plot_data(:,i)>prctile(plot_data(:,i),options_1d.quantile_filters(2));
                plot_data(temp_index_min|temp_index_max,i) = nan;
            end
        case 'Quantile'
            % Filter with current quantile filter bounds
            for i = 1:numel(selected_cell_lines)
                temp_index_min = plot_data(:,i)<prctile(plot_data(:,i),options_1d.quantile_filters(1));
                temp_index_max = plot_data(:,i)>prctile(plot_data(:,i),options_1d.quantile_filters(2));
                plot_data(temp_index_min|temp_index_max,i) = nan;
            end
            % Filter with current absolute filter bounds
            plot_data(plot_data<options_1d.absolute_filters(1)) = nan;
            plot_data(plot_data>options_1d.absolute_filters(2)) = nan;
    end
end

%% Get plot settings
plot_options = struct();
if options_1d.specify_bin_width_1d
    plot_options.BinWidth = options_1d.bin_width_1d;
end
if ~options_1d.do_histogram_edge_line
    plot_options.edgecolor = 'none';
end
plot_options.Normalization = options_1d.Normalization_1d;
plot_options.DisplayStyle = options_1d.display_style_1d;
plot_options.FaceAlpha = options_1d.face_alpha_1d;
plot_options.orientation = options_1d.orientation_1d;

params = plot_options;
fields = fieldnames(params);
params = rmfield(params, fields(structfun(@isempty, params)));
params = namedargs2cell(params);

%% Initialise plot
hold(options.axis,"on");

%plots
tp = [];
%% Iterate
for i = 1:numel(selected_cell_lines)
    if options_1d.do_histogram
        if options_1d.specify_bins_1d
            p = histogram(options.axis,plot_data(:,i),options_1d.num_bins_1d,params{:});
        else
            p = histogram(options.axis,plot_data(:,i),params{:});
        end
        tp = [tp,p];
        p.DisplayName = strcat(selected_cell_lines(i)," ",options_1d.add_legend_suffix);
    end
end

%% Legend
if options_1d.do_1d_legend&&options_1d.do_histogram
legend(options.axis,"show")
else
    legend(options.axis,'hide');
end

%% Add plot labels
xlabel(options.axis,selected_marker);
ylabel(options.axis,string(options_1d.Normalization_1d));

end

