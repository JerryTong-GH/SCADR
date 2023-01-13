function [fig] = filter_scatter_plot(total_data_sets,selected_cell_lines,xvar,yvar,options)
%2D_SCATTER_PLOT Summary of this function goes here
%   Detailed explanation goes here
%   'axis'    -  target axis to plot

%% Function arguments
% required inputs
arguments
    total_data_sets {mustBeA(total_data_sets,{'cell','dictionary'})}
    selected_cell_lines {mustBeA(selected_cell_lines,{'string','cell'})}
    xvar {mustBeA(xvar,{'string','char'})}
    yvar {mustBeA(yvar,{'string','char'})}
end

% optional specified
arguments
    % app plot
    options.app 
    options.axis {mustBeA(options.axis,{'matlab.ui.control.UIAxes'})}
    % plot type
    options.type (1,:) string {mustBeMember(options.type,{'scatter','bin scatter','3d histogram'})} = 'scatter'
    % binned plots
    options.binwidth double
    % do plot settings
    options.do_binwidth logical
    options.alpha {mustBeA(options.alpha,{'double'})} = 0.1;
    % do legend
    options.legend_labels
    options.cell_line_names {mustBeA(options.cell_line_names,{'string','cell'})} = "";
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
cell_line_names = options.cell_line_names;
cell_line_names = string(cell_line_names);
xvar = string(xvar);
yvar = string(yvar);

%initialise plot
hold(options.axis,"on");

%initial checks
if numel(selected_cell_lines)<1||yvar==xvar
    return
end

%% selected data
switch class(total_data_sets)
    case 'cell'
        index_for_data = array_of_array(cell_line_names,selected_cell_lines);
        selected_data = total_data_sets(index_for_data);
    case 'dictionary'
        selected_data = total_data_sets(selected_cell_lines);
end

for i = 1:numel(selected_cell_lines)
    switch string(options.type)
        case "scatter"
            alpha_data = repelem(options.alpha,numel(selected_data{i}.(xvar)));
            scatter(options.axis,selected_data{i}.(xvar),selected_data{i}.(yvar),'x','AlphaData',alpha_data,'MarkerEdgeAlpha','flat')
        case "bin scatter"
            if options.do_binwidth
                binscatter(options.axis,selected_data{i}.(xvar),selected_data{i}.(yvar),[options.binwidth,options.binwidth])
            else
                binscatter(options.axis,selected_data{i}.(xvar),selected_data{i}.(yvar))
            end
    end
end

%% Add plot labels
xlabel(options.axis,xvar)
ylabel(options.axis,yvar)

if isfield(options,'legend_labels') 
    legend(options.axis,options.legend_labels)
end

% if isfield(options,'axis')
%     fig = 0;
% end

end

