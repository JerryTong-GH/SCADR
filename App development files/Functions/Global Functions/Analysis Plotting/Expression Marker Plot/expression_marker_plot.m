function [fig,segmentdata,smoothwindow_size] = expression_marker_plot(total_data_sets,cell_line_names, ...
    selected_cell_lines,selected_marker,expression_channel,options)
%2D_SCATTER_PLOT Summary of this function goes here
%   Detailed explanation goes here
%   'axis'    -  target axis to plot

%% Function arguments
% required inputs
arguments (Input)
    total_data_sets {mustBeA(total_data_sets,{'cell','dictionary'})}
    cell_line_names {mustBeA(cell_line_names,{'string','cell'})}
    selected_cell_lines {mustBeA(selected_cell_lines,{'string','cell'})}
    selected_marker {mustBeA(selected_marker,{'string','char','cell'})}
    expression_channel {mustBeA(expression_channel,{'string','char','cell'})}
end

% optional specified
arguments (Input)
    % app plot
    options.app
    options.axis {mustBeA(options.axis,{'matlab.ui.control.UIAxes','matlab.graphics.axis.Axes'})}
    options.fig_name {mustBeA(options.fig_name,{'string','char'})} = "";
    % plot settings
    options.type (1,:) string {mustBeMember(options.type,{'scatter','bin scatter'})} = 'scatter';
    options.marker_type {mustBeA(options.marker_type,{'string','char'})} = "x";
    options.marker_face_alpha = 0.5;
    % smooth options
    options.segment_on_smooth {mustBeMember(options.segment_on_smooth,[1,0])} = 0;
    options.smooth_method {mustBeMember(options.smooth_method,{'movmean','movmedian','gaussian','lowess','loess','rlowess','rloess','sgolay'})} = 'movmean';
    options.specify_smooth_span {mustBeMember(options.specify_smooth_span,[1,0])} = 0;
    options.smooth_span = 5;
    options.auto_smooth_span_factor = 0.25;
    % segmentation settings
    options.segment_using_threshold {mustBeMember(options.segment_using_threshold,[1,0])} = 0;
    options.max_segments = 4;
    options.threshold = 1;
    options.segment_method {mustBeMember(options.segment_method,{'mean','variance','linear'})} = 'linear'
    % segment binning settings
    options.segment_bins = 30;
    % fit settings
    options.fit_on_smooth = 1;
    options.fit_type {mustBeMember(options.fit_type,{'poly1','poly11','poly2','linearinterp','cubicinterp','smoothingspline','lowess'})} = 'poly1';
    options.pred_interval = 0.95;
    % do legend
    options.legend_labels
    % which plot to do
    options.do_scatter {mustBeMember(options.do_scatter,[1,0])} = 0;
    options.do_smooth_data {mustBeMember(options.do_smooth_data,[1,0])} = 0;
    options.do_segmentations {mustBeMember(options.do_segmentations,[1,0])} = 0;
    options.do_segment_line_fit {mustBeMember(options.do_segment_line_fit,[1,0])} = 0;
    options.do_segment_line_standard_error {mustBeMember(options.do_segment_line_standard_error,[1,0])} = 0;
    options.do_legend {mustBeMember(options.do_legend,[1,0])} = 1
end

arguments (Output)
    fig
    segmentdata
    smoothwindow_size
end

%% Function begins
%% If not using an app
segmentdata = struct();
smoothwindow_size = 0;
fig = 0;
if ~isfield(options,'axis')
    no_app = 1;
    fig = figure("Name",options.fig_name);
    options.axis = axes(fig);
end

%% Data conversions
selected_cell_lines = string(selected_cell_lines);
cell_line_names = string(cell_line_names);
selected_marker = string(selected_marker);
expression_channel = string(expression_channel);

%% Initial checks
if numel(selected_cell_lines)<1||expression_channel==selected_marker
    smoothwindow_size = "NA";
    return
end

%% Selected data
switch class(total_data_sets)
    case 'cell'
        index_for_data = array_of_array(cell_line_names,selected_cell_lines);
        selected_data = total_data_sets(index_for_data);
    case 'dictionary'
        selected_data = total_data_sets(selected_cell_lines);
end

%% Initialise plot
hold(options.axis,"on");
%plots
tsp = [];
tsmoothp = [];
tlinep = [];
tfitp = [];
tpredfitp = [];
%fits
tfitobj = cell(numel(selected_cell_lines),1);
tfitgof = cell(numel(selected_cell_lines),1);
tfitoutput = cell(numel(selected_cell_lines),1);
tindex = cell(numel(selected_cell_lines),1);
tfitsample = cell(numel(selected_cell_lines),1);
tminsep = cell(numel(selected_cell_lines),1);
tyci = cell(numel(selected_cell_lines),1);
typred = cell(numel(selected_cell_lines),1);
legendlabels = [];
%segment bins
segmentbins = cell(numel(selected_cell_lines),1);
segmentbins_boundaries = cell(numel(selected_cell_lines),1);

%% Iterate
for i = 1:numel(selected_cell_lines)
    %% Initialise
    plotdata = selected_data{i}(:,[expression_channel,selected_marker]);
    plotdata = sortrows(plotdata,expression_channel);

    xvar = plotdata.(expression_channel);
    yvar = plotdata.(selected_marker);

    if options.segment_on_smooth||options.do_smooth_data||(options.do_segment_line_fit&&options.fit_on_smooth)
        if options.specify_smooth_span
            [smooth_yvar,temp_smoothwindow_size] = smoothdata(yvar,options.smooth_method,options.smooth_span);
        else
            [smooth_yvar,temp_smoothwindow_size] = smoothdata(yvar,options.smooth_method,"SmoothingFactor",options.auto_smooth_span_factor);
        end
        smoothwindow_size = max(smoothwindow_size,temp_smoothwindow_size);
    end


    %% Calculate segmentation points if needed
    if options.do_segmentations||options.do_segment_line_fit||options.do_segment_line_standard_error
        if options.segment_on_smooth
            seg_yvar = smooth_yvar;
        else
            seg_yvar = yvar;
        end


        if options.segment_using_threshold
            index = ischange(seg_yvar,options.segment_method,"Threshold",options.threshold);

        else
            if options.max_segments == 0
                index = [];
            else
                index = ischange(seg_yvar,options.segment_method,"MaxNumChanges",options.max_segments);
            end
        end
        index = find(index);
        tindex{i} = index;

    end




    %% Calculate fit if needed
    if options.do_segment_line_fit||options.do_segment_line_standard_error
        %Initialise saving plot data
        y_fit = nan(numel(xvar),1);
        yfit_error_upper = nan(numel(xvar),1);
        yfit_error_lower = nan(numel(xvar),1);
        %initialise saving fit data
        tfitobj{i} = cell(numel(index)+1,1);
        tfitgof{i} = cell(numel(index)+1,1);
        tfitoutput{i} = cell(numel(index)+1,1);
        tfitsample{i} = cell(numel(index)+1,1);
        typred{i} = cell(numel(index)+1,1);
        tyci{i} = cell(numel(index)+1,1);
        %initialising segment bins
        segmentbins{i} = cell(numel(index)+1,0);
        segmentbins_boundaries{i} = cell(numel(index)+1,0);

        startpoint = 1;
        for j = 0:numel(index)
            %index for each segment
            if numel(index) == 0
                temp_index = 1:numel(xvar);
            elseif j<numel(index)
                temp_index = startpoint:index(j+1);
                startpoint = index(j+1);
            else
                temp_index = index(j):numel(xvar);
            end
            %x and y data for each segment
            temp_x = xvar(temp_index);
            if options.fit_on_smooth
                temp_y = smooth_yvar(temp_index);
            else
                temp_y = yvar(temp_index);
            end

            tfitsample{i}{j+1} = [temp_x,temp_y];

            if numel(temp_x)<2
                fitobject = cfit;
                fit_coefficient_bounds = nan;
                gof = struct("sse",nan,"rsquare",nan,"dfe",nan,"adjrsquare",nan,"rmse",nan);
                output = struct('numobs',nan,'numparam',nan,'residuals',nan,'Jacobian',nan,'exitflag',nan,'algorithm',nan,'iterations',nan);
                yci = nan(numel(temp_x),2);
                y_pred = nan(numel(temp_x),1);
            else
                try
                    %fit on segment
                    [fitobject,gof,output] = fit(temp_x,temp_y,options.fit_type);
                    %generate and save plot data
                    [yci, y_pred] = predint(fitobject,temp_x,options.pred_interval,'observation','off');
                catch
                    fitobject = cfit;
                    gof = struct("sse",nan,"rsquare",nan,"dfe",nan,"adjrsquare",nan,"rmse",nan);
                    output = struct('numobs',nan,'numparam',nan,'residuals',nan,'Jacobian',nan,'exitflag',nan,'algorithm',nan,'iterations',nan);
                    yci = nan(numel(temp_x),2);
                    y_pred = nan(numel(temp_x),1);
                end
            end

            %save fit data
            tfitobj{i}{j+1} = fitobject;
            tfitgof{i}{j+1} = gof;
            tfitoutput{i}{j+1} = output;

            tyci{i}{j+1} = yci;
            typred{i}{j+1} = y_pred;
            y_fit(temp_index) = y_pred;
            yfit_error_lower(temp_index) = yci(:,1);
            yfit_error_upper(temp_index) = yci(:,2);

        end
    end



    %% Scatter plot
    if options.do_scatter
        leg_name = strcat(selected_cell_lines(i),": Data");
        switch string(options.type)
            case "scatter"
                sp = scatter(options.axis,selected_data{i}.(expression_channel),selected_data{i}.(selected_marker), ...
                    options.marker_type, ...
                    "DisplayName",leg_name);
                sp.MarkerFaceAlpha = options.marker_face_alpha;
                sp.MarkerEdgeAlpha = options.marker_face_alpha;
            case "bin scatter"
                sp = binscatter(options.axis,selected_data{i}.(expression_channel),selected_data{i}.(selected_marker), ...
                    "DisplayName",leg_name);
        end
        legendlabels = [legendlabels,strcat(selected_cell_lines(i),": Data")];
        tsp = [tsp,sp];
    end
    %% Smooth data line
    if options.do_smooth_data
        leg_name = strcat(selected_cell_lines(i),": Smoothed Data");
        smoothp = plot(options.axis,xvar,smooth_yvar, ...
            "DisplayName",leg_name);
        legendlabels = [legendlabels,strcat(selected_cell_lines(i),": Smoothed Data")];
        tsmoothp = [tsmoothp,smoothp];
    end
    %% Segmentation line
    if options.do_segmentations
        if ~numel(index)==0
            leg_name = strcat(selected_cell_lines(i),": Inflection point");
            linep = xline(options.axis,xvar(index),'--k',"Label","Inflection point", ...
                "DisplayName",leg_name);
            for a = 1:numel(linep)
                linep(a).Annotation.LegendInformation.IconDisplayStyle = 'off';
            end
            tlinep = [tlinep;linep];
        end
    end
    %% Linear line fit
    if options.do_segment_line_fit
        leg_name = strcat(selected_cell_lines(i),": Linear fit");
        fitp = plot(options.axis,xvar,y_fit,'-','LineWidth',2, ...
            "DisplayName",leg_name);
        legendlabels = [legendlabels,strcat(selected_cell_lines(i),": Linear fit")];
        tfitp = [tfitp,fitp];
    end
    %% Linear line fit prediction interval
    if options.do_segment_line_standard_error
        leg_name = strcat(selected_cell_lines(i),": CI");
        predfitp = plot(options.axis,xvar,yfit_error_lower,'m--',xvar,yfit_error_upper,'m--', ...
            "DisplayName",leg_name);
        for a = 1:numel(predfitp)
            predfitp(a).Annotation.LegendInformation.IconDisplayStyle = 'off';
        end
        tpredfitp = [tpredfitp,predfitp];
    end
end

%% Legend
if options.do_legend&&numel(legendlabels)>0
    leg_columns = sum([options.do_scatter,options.do_segment_line_fit,options.do_smooth_data]);
    %     legend(options.axis,[tsp,tsmoothp,tfitp],cellstr(legendlabels),'NumColumns',leg_columns);
    legend(options.axis,'show')
    legend(options.axis,"NumColumns",leg_columns)
else
    legend(options.axis,'hide')
end

%% Add plot labels
xlabel(options.axis,expression_channel)
ylabel(options.axis,selected_marker)

segmentdata.fittype = options.fit_type;
segmentdata.tfitobj = tfitobj;
segmentdata.tfitgof = tfitgof;
segmentdata.tfitoutput = tfitoutput;
segmentdata.tindex = tindex;
segmentdata.tfitsample = tfitsample;
% segmentdata.tminsep = tminsep;
segmentdata.selected_marker = selected_marker;
segmentdata.expression_channel = expression_channel;
segmentdata.selected_cell_lines = selected_cell_lines;
segmentdata.tyci = tyci;
segmentdata.typred = typred;

if smoothwindow_size == 0
    smoothwindow_size = "NA";
else
    smoothwindow_size = string(smoothwindow_size);
end

% isfield(options,'axis')
end

