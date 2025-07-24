function [] = marker_expression_scatterplot(total_data_sets,cell_line_names, ...
    expression_channel_name, cell_variant_plot,marker_plot,binwidth)
%MARKER_EXPRESSION_SCATTER Summary of this function goes here
%   Detailed explanation goes here
%create figure
fig = figure("Name", cell_variant_plot);

%extract out chosen data from chosen cell line, expression and marker
data = total_data_sets{cell_variant_plot==cell_line_names}(:,[expression_channel_name,marker_plot]);

%plot data
binscatter(data.(expression_channel_name),data.(marker_plot),binwidth);

%label plot
xlabel(expression_channel_name)
ylabel(marker_plot)

end

