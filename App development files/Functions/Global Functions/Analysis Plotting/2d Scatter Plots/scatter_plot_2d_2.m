function [fig,cell_count] = scatter_plot_2d_2(total_data_sets,cell_line_names,selected_cell_lines,xvar,yvar,options,options_2d)
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
end

% optional specified
arguments
    % app plot
    options.app
    options.axis {mustBeA(options.axis,{'matlab.ui.control.UIAxes','matlab.graphics.axis.Axes'})}
end

arguments
    % plot type
    options_2d.type_2d (1,:) string {mustBeMember(options_2d.type_2d,{'scatter','bin scatter','3d histogram','density scatter','bin bars'})} = 'scatter'
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
    % bin bars settings
    options_2d.binbar_nbins_2d = 10;
    options_2d.binbar_bin_method_2d (1,:) string {mustBeMember(options_2d.binbar_bin_method_2d,{'linear','quantile'})} = 'linear'
    % do plots
    options_2d.do_scatter_2d = 1;
    options_2d.do_legend_2d = 1;
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

%% data conversions
selected_cell_lines = string(selected_cell_lines);
cell_line_names = string(cell_line_names);
xvar = string(xvar);
yvar = string(yvar);

%% initialise plot
hold(options.axis,"on");

%% initial checks
num_cell_lines = numel(selected_cell_lines);
if num_cell_lines<1||all(yvar==xvar)
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

%% Initialise plot variables
tp = [];
p = [];
legend_labels = [];

%% Do plot
for i = 1:num_cell_lines
    cell_count = numel(selected_data{i}.(xvar))+cell_count;
    if options_2d.do_scatter_2d
        switch options_2d.type_2d
            case 'scatter'
                %% Get plot data for gscatter
                [~,variant_ID,~,~] = dataset_selection_2_table(total_data_sets,selected_cell_lines,[xvar,yvar]);

                clr = hsv(num_cell_lines);

                p = scatter(options.axis,selected_data{i}.(xvar),selected_data{i}.(yvar),options_2d.markertype_2d);
                
                p.DataTipTemplate.DataTipRows(1).Label = xvar;
                p.DataTipTemplate.DataTipRows(2).Label = yvar;
                dtRows = dataTipTextRow("Variant",variant_ID');
                p.DataTipTemplate.DataTipRows(end+1) = dtRows;

            case 'bin scatter'
                if options_2d.do_bin_width_2d
                    n = [options_2d.binwidth_2d,options_2d.binwidth_2d];
                elseif options_2d.do_bins_2d
                    n = options_2d.num_bins_2d;
                end

                if options_2d.do_bin_width_2d||options_2d.do_bins_2d
                    p = binscatter(options.axis,selected_data{i}.(xvar),selected_data{i}.(yvar),n);
                else
                    p = binscatter(options.axis,selected_data{i}.(xvar),selected_data{i}.(yvar));
                end

            case '3d histogram'

                [master_table,~,~,~] = dataset_selection_2_table(total_data_sets,selected_cell_lines,[xvar,yvar]);
                xvar_data = master_table.(xvar);
                yvar_data = master_table.(yvar);

                if options_2d.do_histogram_bin_width_2d
                    n = [options_2d.histogram_bin_width_2d,options_2d.histogram_bin_width_2d];
                elseif options_2d.do_histogram_bins_2d
                    n = options_2d.num_histogram_bins_2d;
                end

                if options_2d.do_histogram_bin_width_2d||options_2d.do_histogram_bins_2d
                    histogram2(options.axis,xvar_data,yvar_data,n,'FaceColor','flat');
                else
                    histogram2(options.axis,xvar_data,yvar_data,'FaceColor','flat');
                end
        end
        tp = [tp,p];
        legend_labels = [legend_labels, selected_cell_lines(i)];
    end
end

if cell_count==0
    return
end

% Do a density scatter if selected
if isequal(options_2d.type_2d,"density scatter")
    combined_plot_data = dataset_selection_2_table(total_data_sets,selected_cell_lines,[xvar,yvar]);
    dscatter(combined_plot_data.(xvar),combined_plot_data.(yvar), ...
        'MARKER',options_2d.markertype_2d, ...
        "axes_handle",options.axis);
end

% Do a bin bars if selected
if isequal(options_2d.type_2d,"bin bars")
    % Calculate bin boundaries and midpoints
    combined_plot_data = dataset_selection_2_table(total_data_sets,selected_cell_lines,[xvar,yvar]);
    switch options_2d.binbar_bin_method_2d
        case 'linear'
            min_xvar = min(combined_plot_data.(xvar));
            max_xvar = max(combined_plot_data.(xvar));
            boundaries = linspace(min_xvar,max_xvar,options_2d.binbar_nbins_2d+1);
            % midpoints = (max_xvar-min_xvar)/(options_2d.binbar_nbins_2d*2)+x(1:(end-1));
        case 'quantile'
            boundaries = quantile(combined_plot_data.(xvar),linspace(0,1,options_2d.binbar_nbins_2d+1));
    end
    midpoints = (boundaries(2:end)-boundaries(1:(end-1)))/2+boundaries(1:(end-1));

    % Reformat table for boxchart
    combined_plot_data.('midpoint') = nan(height(combined_plot_data),1);

    for bin_indx = 1:options_2d.binbar_nbins_2d
        rows_in_bin_indx = combined_plot_data.(xvar)>=boundaries(bin_indx)&combined_plot_data.(xvar)<boundaries(bin_indx+1);
        combined_plot_data(rows_in_bin_indx,'midpoint').Variables = repelem(midpoints(bin_indx),sum(rows_in_bin_indx))';
    end

    boxchart(options.axis,categorical(combined_plot_data.('midpoint')),combined_plot_data.(yvar),'GroupByColor',combined_plot_data.('variant_ID'));
end
%% Add plot labels
xlabel(options.axis,xvar)
ylabel(options.axis,yvar)
zlabel(options.axis,"Count")

if options_2d.do_legend_2d
    if isequal(options_2d.type_2d,'scatter')&&options_2d.do_scatter_2d
        legend(options.axis,tp,cellstr(legend_labels));
    end
    if isequal(options_2d.type_2d,'bin bars')
        legend(options.axis,"show");
    end
end

end

