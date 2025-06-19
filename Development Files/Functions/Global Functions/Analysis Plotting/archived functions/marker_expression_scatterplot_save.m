function [] = marker_expression_scatterplot_save(total_data_sets,cell_line_names,new_column_names, ...
    expression_channel_name,normalising_channel_name,scatterbins)
%MARKER_EXPRESSION_SCATTER Summary of this function goes here
%   Detailed explanation goes here

for i = 1:numel(cell_line_names)
    for j = 1:numel(new_column_names)

        %initialise
        cell_variant_plot = cell_line_names(i);
        marker_plot = new_column_names(j);

        if marker_plot==expression_channel_name||marker_plot==normalising_channel_name
            continue
        end

        %create figure
        fig = figure("Name", strcat(cell_variant_plot,": ",marker_plot),'Position',[50,50, 1600, 1600]);

        %extract out chosen data from chosen cell line, expression and marker
        data = total_data_sets{cell_variant_plot==cell_line_names}(:,[expression_channel_name,marker_plot]);

        %plot data
        binscatter(data.(expression_channel_name),data.(marker_plot),scatterbins);

        %label plot
        xlabel(expression_channel_name)
        ylabel(marker_plot)

        %%%%%%%%%%%%%%%%%%%%
        %Title figure window
        sgtitle(strcat(cell_variant_plot,"-",marker_plot))

        %Save figure window
        saveas(fig,strcat(cd,"\Output Plots\Expression vs Marker Scatter\",cell_variant_plot,"-",marker_plot,".png"))

        %close figure window
        close(fig)

    end

end

