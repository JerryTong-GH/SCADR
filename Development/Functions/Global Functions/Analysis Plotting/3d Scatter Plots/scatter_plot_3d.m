function [fig,cell_count] = scatter_plot_3d(total_data_sets,cell_line_names,selected_cell_lines,xvar,yvar,zvar,options,options_3d)
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
cell_count = 0;
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

%initialise plot
hold(options.axis,"on");

%initial checks
if numel(selected_cell_lines)<1||numel(unique([xvar,yvar,zvar]))<3
    return
end

%selected data
switch class(total_data_sets)
    case 'cell'
        index_for_data = array_of_array(cell_line_names,selected_cell_lines);
        selected_data = total_data_sets(index_for_data);
    case 'dictionary'
        selected_data = total_data_sets(selected_cell_lines);
end

tp = [];
p = [];
legend_labels = [];

for i = 1:numel(selected_cell_lines)
    cell_count = cell_count + numel(selected_data{i}.(xvar));
    switch options_3d.type_3d
        case 'scatter'
            p = scatter3(options.axis,selected_data{i}.(xvar),selected_data{i}.(yvar),selected_data{i}.(zvar), ...
                options_3d.marker_type_3d);
            tp = [tp,p];
            legend_labels = [legend_labels,strcat(selected_cell_lines(i),": Data")];
    end
end

%% Add plot labels
xlabel(options.axis,xvar)
ylabel(options.axis,yvar)
zlabel(options.axis,zvar)

% if isfield(options_3d,'legend_labels') 
%     legend(options.axis,options_3d.legend_labels)
% end

if options_3d.do_legend_3d
    legend(options.axis,tp,cellstr(legend_labels));
end

% isfield(options,'axis')
end

