function [] = sub_app_segment_analysis_table(table_app,text,type,segmentdata,variant_number,segment_number,confint_val)
%SUB_APP_SEGMENT_ANALYSIS_PLOT Summary of this function goes here
%   Detailed explanation goes here
%% Function arguments
% required inputs
arguments
    table_app
    text
    type
    segmentdata
    variant_number
    segment_number
    confint_val
end

%% Function begins

fitobj = segmentdata.tfitobj{variant_number}{segment_number};
fitgof = segmentdata.tfitgof{variant_number}{segment_number};
fitoutput = segmentdata.tfitoutput{variant_number}{segment_number};

selected_cell_lines = segmentdata.selected_cell_lines(variant_number);

xvar_name = segmentdata.expression_channel;
yvar_name = segmentdata.selected_marker;

switch type
    case 'Sample features'
        text.Text = strcat("Data characteristics of segment ",string(segment_number), ...
            " from variant ",selected_cell_lines," between markers: ", ...
            segmentdata.expression_channel," and ",segmentdata.selected_marker);

        %table variables
        xvar = segmentdata.tfitsample{variant_number}{segment_number}(:,1);
        yvar = segmentdata.tfitsample{variant_number}{segment_number}(:,2);

        num_datapoints = numel(xvar);

        xvar_mean = mean(xvar);
        xvar_median = median(xvar);
        xvar_std = std(xvar);

        yvar_mean = mean(yvar);
        yvar_median = median(yvar);
        yvar_std = std(yvar);

        noms = string({'Number of data points', ...
            strcat(xvar_name,' Mean'),strcat(xvar_name,' Median'),strcat(xvar_name,' STD'), ...
            strcat(yvar_name,' Mean'),strcat(yvar_name,' Median'),strcat(yvar_name,' STD')});
        
        %create table

        plot_table = table(noms',[num_datapoints,xvar_mean,xvar_median,xvar_std, ...
            yvar_mean,yvar_median,yvar_std]', ...
            'VariableNames',["Characteristics","Values"]);

        table_app.Data = plot_table;
        table_app.ColumnName = ["Characteristics","Values"];

    case 'Fit formula'

        if isequal(segmentdata.fittype,'poly1')
            text.Text = strcat("Fit formula is: y = mx+c, whereby 'x' is ",xvar_name," and 'y' is ",yvar_name);
            varnames = ["m","c"]';
        else
            text.Text = strcat("Fit formula is: y = ",formula(fitobj),", whereby 'x' is ",xvar_name," and 'y' is ",yvar_name);

            varnames = coeffnames(fitobj);
            varnames = string(varnames);
        end

        values = coeffvalues(fitobj)';

        bound = confint(fitobj,confint_val)';
        lowerbound = bound(:,1);
        upperbound = bound(:,2);

        noms = ["Coefficient","Value","Lowerbound","Upperbound"];

        %create table
        plot_table = table(varnames,values,lowerbound,upperbound, ...
            'VariableNames',noms);

        table_app.Data = plot_table;
        table_app.ColumnName = noms;

    case 'Goodness of fit'

        text.Text = strcat("Fit Characteristics of segment ",string(segment_number), ...
            " from variant ",selected_cell_lines," between markers: ", ...
            segmentdata.expression_channel," and ",segmentdata.selected_marker);

        values = struct2cell(fitgof);

        features = ["Sum of squares", ...
            "R-squared", ...
            "Degrees of freedom in the error", ...
            "Degree-of-freedom adjusted coefficient of determination", ...
            "Root mean squared error (i.e. standard error)"]';

        noms = ["Characteristics","Values"];

        plot_table = table(features,values,VariableNames=noms);

        table_app.Data = plot_table;
        table_app.ColumnName = noms;
end

end

