function [fig,cell_count] = plot_nD_vars(total_data_sets,cell_line_names,selected_cell_lines,xvar,yvar,zvar,options,options_1d,options_2d,options_3d)
%2D_SCATTER_PLOT Summary of this function goes here
%   Detailed explanation goes here
%   'axis'    -  target axis to plot

%% Function arguments
% required inputs
arguments
    total_data_sets {mustBeA(total_data_sets,{'cell','dictionary'})}
    cell_line_names {mustBeA(cell_line_names,{'string','cell'})}
    selected_cell_lines {mustBeA(selected_cell_lines,{'string','cell'})}
    xvar {mustBeA(xvar,{'string','char'})}
    yvar {mustBeA(yvar,{'string','char'})}
    zvar {mustBeA(zvar,{'string','char'})}
end

% optional specified
arguments
    % app plot
    options.app 
    options.axis {mustBeA(options.axis,{'matlab.ui.control.UIAxes','matlab.graphics.axis.Axes'})}
end

arguments
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
end

arguments
    % plot type
    options_2d.type_2d (1,:) string {mustBeMember(options_2d.type_2d,{'scatter','bin scatter','3d histogram','density scatter'})} = 'scatter'
    options_2d.markertype_2d = 'x'
    % 2d binned plots
    options_2d.do_bins_2d double
    options_2d.num_bins_2d double
    options_2d.do_bin_width_2d
    options_2d.binwidth_2d
    % 3d bin settings
    options_2d.do_histogram_bins_2d logical
    options_2d.num_histogram_bins_2d logical
    options_2d.do_histogram_bin_width_2d
    options_2d.histogram_bin_width_2d
    % do plots
    options_2d.do_scatter_2d = 1;
    options_2d.do_legend_2d = 1;
end

arguments
    % plot type
    options_3d.type_3d (1,:) string {mustBeMember(options_3d.type_3d,{'scatter'})} = 'scatter';
    % do plot settings
    options_3d.marker_type_3d {mustBeA(options_3d.marker_type_3d,{'string','char'})} = "x";
    % which plot to do
    options_3d.do_scatter_3d {mustBeMember(options_3d.do_scatter_3d,[1,0])} = 1;
    options_3d.do_line_fit_3d {mustBeMember(options_3d.do_line_fit_3d,[1,0])} = 0;
    options_3d.do_line_standard_error_3d {mustBeMember(options_3d.do_line_standard_error_3d,[1,0])} = 0;
    options_3d.do_legend_3d = 1;
end

%% Function begins
%% If not using an app
fig = 0;
if ~isfield(options,'axis')
    no_app = 1;
    fig = figure;
    options.axis = axes(fig);
end

%data conversions
selected_cell_lines = string(selected_cell_lines);
cell_line_names = string(cell_line_names);
xvar = string(xvar);
yvar = string(yvar);
zvar = string(zvar);

%% Figure out how many dimensions to plot
remaining_vars = unique([xvar,yvar,zvar],'stable');

switch numel(remaining_vars)
    case 1
        % do histogram
        plot_params = options_1d;
        fields = fieldnames(plot_params);
        plot_params = rmfield(plot_params, fields(structfun(@isempty, plot_params)));
        plot_params = namedargs2cell(plot_params);

        [~,~,cell_count] = histogram_plot_1d(total_data_sets, ...
            selected_cell_lines,remaining_vars,"axis",options.axis,plot_params{:});
    case 2
        % do 2d plot
        plot_params = options_2d;
        fields = fieldnames(plot_params);
        plot_params = rmfield(plot_params, fields(structfun(@isempty, plot_params)));
        plot_params = namedargs2cell(plot_params);

        [~,cell_count] = scatter_plot_2d_2(total_data_sets,cell_line_names,selected_cell_lines,remaining_vars(1),remaining_vars(2),"axis",options.axis,plot_params{:});
    case 3
        % do 3d plot
        plot_params = options_3d;
        fields = fieldnames(plot_params);
        plot_params = rmfield(plot_params, fields(structfun(@isempty, plot_params)));
        plot_params = namedargs2cell(plot_params);

        [~,cell_count] = scatter_plot_3d(total_data_sets,cell_line_names,selected_cell_lines,xvar,yvar,zvar,"axis",options.axis,plot_params{:});
end



end

