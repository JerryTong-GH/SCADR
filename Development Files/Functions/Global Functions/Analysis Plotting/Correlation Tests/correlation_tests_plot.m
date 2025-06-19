function [fig_plot] = correlation_tests_plot(total_data_sets, ...
    selected_cell_lines,selected_markers,options,options_1d,options_boxchart)
%2D_SCATTER_PLOT Summary of this function goes here
%   Detailed explanation goes here
%   'axis'    -  target axis to plot

%% Function arguments
% required inputs
arguments (Input)
    total_data_sets {mustBeA(total_data_sets,{'cell','dictionary'})}
    selected_cell_lines {mustBeA(selected_cell_lines,{'string','cell'})}
    selected_markers {mustBeA(selected_markers,{'string','char','cell'})}
end

% optional specified
arguments (Input)
    % app plot
    options.app
    options.axis {mustBeA(options.axis,{'matlab.ui.control.UIAxes','matlab.graphics.axis.Axes'})}
    options.fig_name {mustBeA(options.fig_name,{'string','char'})} = "";
    % which plot to do
    options.which_plot_type {mustBeMember(options.which_plot_type,{'Histogram','Correlation distribution','Correlation Comparison'})} = 'Correlation distribution';
    % correlation settings
    options.correlation_method {mustBeMember(options.correlation_method,{'Pearson','Kendall','Spearman'})} = 'Spearman';
    options.do_bootstrap = 1;
    options.bootstrap_repeat_samples = 1000;
    options.bootstrap_sample_size = 100; %in percent of datapoints
    options.bootstrap_replace = 1;
    options.histogram_ci_percent = 95;
    % which plot to do
    options.do_all_marker_combinations {mustBeMember(options.do_all_marker_combinations,[1,0])} = 0;
    options.do_histogram_ci {mustBeMember(options.do_histogram_ci,[1,0])} = 1
    options.do_legend {mustBeMember(options.do_legend,[1,0])} = 1
    %% Unused
    options.normality_alpha = 0.05;
    options.comparison_method
end

arguments (Input)
    %% histogram plot settings
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
end

arguments(Input)
    options_boxchart.MarkerStyle = 0;
    options_boxchart.Notch = 1;
    options_boxchart.JitterOutliers = 1;
end

arguments (Output)
    fig_plot
end

%% Function begins
%% If not using an app
fig_plot = 0;
if ~isfield(options,'axis')
    no_app = 1;
    fig_plot = figure("Name",options.fig_name);
    options.axis = axes(fig);
end

%% Initial checks
if numel(selected_cell_lines)<1||numel(selected_markers)<1
    return
end

%% Selected data
switch class(total_data_sets)
    case 'dictionary'
        selected_data = total_data_sets(selected_cell_lines);
end

%% Data conversions/Initialisation
selected_cell_lines = string(selected_cell_lines);
selected_markers = string(selected_markers);

%Correlation
options.bootstrap_replace = options.bootstrap_replace==1;
CI = string(options.histogram_ci_percent);
options.histogram_ci_percent = options.histogram_ci_percent/2;
options.histogram_ci_percent = [50-options.histogram_ci_percent,50+options.histogram_ci_percent];

if options.do_all_marker_combinations
    options.do_all_marker_combinations = numel(selected_markers);
else
    options.do_all_marker_combinations = 1;
end

%Histogram settings

% boxchart settings 
if options_boxchart.MarkerStyle
    options_boxchart.MarkerStyle = ".";
else
    options_boxchart.MarkerStyle = "none";
end

if options_boxchart.Notch
    options_boxchart.Notch = "on";
else
    options_boxchart.Notch = "off";
end

if options_boxchart.JitterOutliers
    options_boxchart.JitterOutliers = "on";
else
    options_boxchart.JitterOutliers = "off";
end

fields = fieldnames(options_boxchart);
options_boxchart = rmfield(options_boxchart, fields(structfun(@isempty, options_boxchart)));
options_boxchart = namedargs2cell(options_boxchart);
%% Initialise plot
hold(options.axis,"on");

%% Get correlations and/or error bars
%% Get plotdata
if ~isequal(options.which_plot_type,'Histogram')
    plot_clrs = hsv(numel(selected_cell_lines));
    master_table = table('Size',[0,3],'VariableTypes',{'double','string','string'},'VariableNames',{'corr','marker pair','cell line name'});

    rho_error = [];
    rho_median = [];

    for i = 1:numel(selected_cell_lines)
        for j = 1:options.do_all_marker_combinations
            for k = (j+1):numel(selected_markers)
                marker_1 = selected_markers(j);
                marker_2 = selected_markers(k);

                if marker_1==marker_2
                    continue
                end

                marker_pair_name = strcat(marker_1," x ",marker_2);

                cell_line_name = selected_cell_lines(i);
                cell_line_data = total_data_sets(cell_line_name);
                cell_line_data = cell_line_data{1};

                data_size = size(cell_line_data);
                if data_size(1)<5
                    continue
                end

                if options.do_bootstrap
                    number_of_samples = ceil(numel(cell_line_data.(marker_1))*(options.bootstrap_sample_size/100));
                    rho = nan(options.bootstrap_repeat_samples,1);
                    table_cell_line_names = repelem(cell_line_name,options.bootstrap_repeat_samples);
                    table_marker_pair_name = repelem(marker_pair_name,options.bootstrap_repeat_samples);

                    % Parfor bootstrap sampling
                    correlation_method = options.correlation_method;
                    xvar = cell_line_data.(marker_1);
                    yvar = cell_line_data.(marker_2);

                    parfor l = 1:options.bootstrap_repeat_samples
                        [sample_x,sample_y] = datasample(xvar,number_of_samples,'Replace',options.bootstrap_replace);
                        sample_y = yvar(sample_y);

                        switch correlation_method
                            case {'Pearson','Kendall','Spearman'}
                                rho(l) = corr(sample_x,sample_y,"type",correlation_method);
                        end
                    end

                    rho_error = [rho_error,std(rho)*2];
                    rho_median = [rho_median,median(rho)];

                else
                    table_cell_line_names = cell_line_name;
                    table_marker_pair_name = marker_pair_name;
                    switch options.correlation_method
                        case {'Pearson','Kendall','Spearman'}
                            rho = corr(cell_line_data.(marker_1),cell_line_data.(marker_2),"type",options.correlation_method);
                    end
                end

                temp_table = table(rho,table_marker_pair_name',table_cell_line_names','VariableNames',{'corr','marker pair','cell line name'});
                master_table = [master_table;temp_table];

            end
        end
    end
end

%% Do plot
switch options.which_plot_type
    case 'Histogram'
        for i = 1:numel(selected_markers)
            if options_1d.do_histogram
                [~,~] = histogram_plot_1d(total_data_sets, ...
                    selected_cell_lines,selected_markers(i), ...
                    "axis",options.axis, ...
                    "app",options.app, ...
                    "add_legend_suffix",selected_markers(i));
            end
        end
        xlabel(options.axis,"Fluorescence")
    case 'Correlation distribution'

        if options.do_bootstrap
            unique_pairs = unique(master_table.("marker pair"));
            for i = 1:numel(unique_pairs)
                for j = 1:numel(selected_cell_lines)
                    cell_line_name = selected_cell_lines(j);
                    marker_pair = unique_pairs(i);

                    if isempty(master_table.("cell line name")==cell_line_name)
                        continue
                    end
                    
                    rho = master_table.("corr")(master_table.("marker pair")==marker_pair&master_table.("cell line name")==cell_line_name);
                    legend_name = strcat(cell_line_name,": ",marker_pair);

                    if options_1d.do_histogram
                        histogram(options.axis,rho,"DisplayName",legend_name,"FaceColor",plot_clrs(j,:));
                    end

                    lower_conf = xline(options.axis,prctile(rho,options.histogram_ci_percent(1)),'--',"Label",strcat(legend_name," ",CI,"% CI"),"Color",plot_clrs(j,:));
                    upper_conf = xline(options.axis,prctile(rho,options.histogram_ci_percent(2)),'--',"Label",strcat(legend_name," ",CI,"% CI"),"Color",plot_clrs(j,:));

                    lower_leg = lower_conf.Annotation;
                    lower_leg.LegendInformation.IconDisplayStyle = "off";
                    upper_leg = upper_conf.Annotation;
                    upper_leg.LegendInformation.IconDisplayStyle = "off";
                end
            end

        else
            unique_pairs = unique(master_table.("marker pair"));
            for i = 1:numel(unique_pairs)
                for j = 1:numel(selected_cell_lines)
                    cell_line_name = selected_cell_lines(j);
                    marker_pair = unique_pairs(i);
                    rho = master_table.("corr")(master_table.("marker pair")==marker_pair&master_table.("cell line name")==cell_line_name);

                    xline(options.axis, ...
                        rho, ...
                        "Label",strcat(cell_line_name,": ",marker_pair," Mean Correlation"), ...
                        "Color",plot_clrs(j,:), ...
                        "DisplayName",strcat(cell_line_name,": ",marker_pair," Mean Correlation"));
                end
            end
        end

        xlabel(options.axis,"Correlation")
    case 'Correlation Comparison'
        boxchart(options.axis, ...
            categorical(master_table.("marker pair")), ...
            master_table.("corr"),"GroupByColor", ...
            categorical(master_table.("cell line name")), ...
            options_boxchart{:});

        %         if options.do_error_bars&&~isempty(rho_error)
        %             eb = errorbar(options.axis,rho_median,rho_error,"vertical","LineStyle","none");
        %             eb.Color = 'red';
        %         end

        ylabel(options.axis,"Correlation");
end

if options.do_legend
    legend(options.axis,"show")
else
    legend(options.axis,'hide');
end

end

