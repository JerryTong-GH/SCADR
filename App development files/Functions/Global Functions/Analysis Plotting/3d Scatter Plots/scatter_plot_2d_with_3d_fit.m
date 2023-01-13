function [fig] = scatter_plot_2d_with_3d_fit(total_data_sets,cell_line_names,selected_cell_lines,xvar,yvar,zvar,options)
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
    % plot type
    options.point = 'o'
    % binned plots
    options.zvar_bins double = 30
    options.binning_type {mustBeMember(options.binning_type,{'percentile','linear'})} = 'percentile';
    % scatter sizes
    options.scatter_size_type {mustBeMember(options.scatter_size_type,{'exponential','linear','log10'})} = 'linear';
    % Error bar type
    options.error_bar_type {mustBeMember(options.error_bar_type,{'standard error','95% range','std'})} = '0.25'
    % smooth options
    options.smooth_method {mustBeMember(options.smooth_method,{'movmean','movmedian','gaussian','lowess','loess','rlowess','rloess','sgolay'})} = 'rloess';
    options.auto_smooth_span_factor = 0.25;
    options.specify_smooth_span {mustBeMember(options.specify_smooth_span,[1,0])} = 0;
    options.smooth_span = 5;
    % do plot settings
    options.use_smoothed_data = 0;
    options.do_scatter = 1;
    options.do_error_bars = 1;
    options.do_legend = 1;
    options.do_scatter_line = 0;
end

%% Function begins
%% If not using an app
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
zvar = string(zvar);

%% initialise plot
hold(options.axis,"on");

%% initial checks
if numel(selected_cell_lines)<1||numel(unique([xvar,yvar,zvar]))<3
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

%% Do plot
legendlabel = [];
sp = {};
er = {};
sl = {};
plots = [];

clr = hsv(numel(selected_data));

for i = 1:numel(selected_data)
    %% Find bin intervals
    data = selected_data{i}(:,[zvar,xvar,yvar]);
    data = sortrows(data,zvar);

    switch options.binning_type
        case 'percentile'
            %percentile spacing
            zvar_bin_boundaries = prctile(data.(zvar),linspace(0,100,options.zvar_bins+1));

        case 'linear'
            %linear spacing
            min_zvar = min(data.(zvar));
            max_zvar = max(data.(zvar));
            zvar_bin_boundaries = linspace(min_zvar,max_zvar,options.zvar_bins+1);
    end

    zvar_bin_middle = movmean(zvar_bin_boundaries,[0,1],'Endpoints','discard');

    %% Fit xvar to zvar
    % Fit xvar to zvar and segment
    [xz_fit_bin,xz_fit_error] = fit_error_2_vars(data,zvar,xvar,options.zvar_bins,zvar_bin_boundaries, ...
        'smooth_method',options.smooth_method, ...
        'error_bar_type',options.error_bar_type, ...
        "use_smoothed_data",options.use_smoothed_data, ...
        "auto_smooth_span_factor",options.auto_smooth_span_factor, ...
        "smooth_span",options.smooth_span, ...
        "specify_smooth_span",options.specify_smooth_span);

    %% Fit yvar to zvar
    [yz_fit_bin,yz_fit_error] = fit_error_2_vars(data,zvar,yvar,options.zvar_bins,zvar_bin_boundaries, ...
        'smooth_method',options.smooth_method, ...
        'error_bar_type',options.error_bar_type, ...
        "use_smoothed_data",options.use_smoothed_data, ...
        "auto_smooth_span_factor",options.auto_smooth_span_factor, ...
        "smooth_span",options.smooth_span, ...
        "specify_smooth_span",options.specify_smooth_span);

    %% Remove nans
    nan_index = isnan(yz_fit_bin)&isnan(xz_fit_bin);

    xz_fit_bin(nan_index) = [];
    xz_fit_error(nan_index,:) = [];

    yz_fit_bin(nan_index) = [];
    yz_fit_error(nan_index,:) = [];

    zvar_bin_middle(nan_index) = [];
    %% Combine fits
    plot_data = array2table([xz_fit_bin,yz_fit_bin],'VariableNames',[xvar,yvar]);

    scatter_sizes = (zvar_bin_middle-min(data.(zvar)))/range(data.(zvar));
    switch options.scatter_size_type
        case 'log10'
            scatter_sizes = log10(scatter_sizes(end:-1:1));
            scatter_sizes = scatter_sizes./max(scatter_sizes)*200+10;
        case 'exponential'
            scatter_sizes = exp(scatter_sizes*10);
            scatter_sizes = scatter_sizes./max(scatter_sizes)*200+10;
        case 'linear'
            scatter_sizes = scatter_sizes.*200+10;
    end

    if options.do_scatter
        sp{i} = scatter(options.axis,plot_data.(xvar),plot_data.(yvar),scatter_sizes,options.point, ...
            'SizeDataMode','manual', ...
            'MarkerEdgeColor',clr(i,:));

        sp{i}.DataTipTemplate.DataTipRows(1).Label = xvar;
        sp{i}.DataTipTemplate.DataTipRows(2).Label = yvar;
        sp{i}.DataTipTemplate.DataTipRows(3).Label = zvar;
        sp{i}.DataTipTemplate.DataTipRows(3).Value = zvar_bin_middle;

        legendlabel = [legendlabel,selected_cell_lines(i)];
        plots = [plots,sp{i}];
    end

    if options.do_scatter_line
        sl{i} = plot(options.axis,plot_data.(xvar),plot_data.(yvar),'--', ...
            "Color",clr(i,:));

        sl{i}.DataTipTemplate.DataTipRows(1).Label = xvar;
        sl{i}.DataTipTemplate.DataTipRows(2).Label = yvar;

        dtRows = dataTipTextRow(zvar,zvar_bin_middle);
        sl{i}.DataTipTemplate.DataTipRows(end+1) = dtRows;
    end

    if options.do_error_bars
        er{i} = errorbar(options.axis,plot_data.(xvar),plot_data.(yvar), ...
            yz_fit_error(:,1),yz_fit_error(:,2),xz_fit_error(:,1),xz_fit_error(:,2), ...
            "LineStyle","none", ...
            "Color",clr(i,:));

        er{i}.DataTipTemplate.DataTipRows(1).Label = xvar;
        er{i}.DataTipTemplate.DataTipRows(2).Label = yvar;
        %delta
        er{i}.DataTipTemplate.DataTipRows(3).Label = strcat(xvar," delta:");
        er{i}.DataTipTemplate.DataTipRows(4).Label = strcat(yvar," delta:");
        % zvar
        dtRows = dataTipTextRow(zvar,zvar_bin_middle);
        er{i}.DataTipTemplate.DataTipRows(end+1) = dtRows;

        legendlabel = [legendlabel,strcat(selected_cell_lines(i),": ",string(options.error_bar_type))];
        plots = [plots,er{i}];
    end
end

%% Add plot labels
xlabel(options.axis,xvar)
ylabel(options.axis,yvar)

if options.do_legend&&(options.do_scatter||options.do_error_bars)
    legend(options.axis,plots,legendlabel,'NumColumns',numel(selected_cell_lines));
else
    legend(options.axis,'hide');
end

end

