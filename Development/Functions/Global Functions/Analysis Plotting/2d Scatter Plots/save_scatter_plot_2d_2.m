function [] = save_scatter_plot_2d_2(total_data_sets,cell_line_names,new_column_names,outputplot_dir,options)
%2D_SCATTER_PLOT Summary of this function goes here
%   Detailed explanation goes here
%   'axis'    -  target axis to plot

%% Function arguments
% required inputs
arguments
    total_data_sets {mustBeA(total_data_sets,{'cell','dictionary'})}
    cell_line_names {mustBeA(cell_line_names,{'string','cell'})}
    new_column_names {mustBeA(new_column_names,{'string','cell'})}
    outputplot_dir {mustBeA(outputplot_dir,{'string','char'})}
end

% optional specified
arguments
    % plot type
    options.type (1,:) string {mustBeMember(options.type,{'scatter','bin scatter','3d histogram'})} = 'scatter'
    % binned plots
    options.bins double
    options.binwidth double
    % do plot settings
    options.do_bins logical = false
    options.do_binwidth logical = false
end

%% Function begins
%data conversions
new_column_names = string(new_column_names);
cell_line_names = string(cell_line_names);
outputplot_dir = string(outputplot_dir);

%initial checks
if numel(new_column_names)<1||numel(cell_line_names)<1
    return
end

if isequal(class(total_data_sets),'dictionary')
    total_data_sets = total_data_sets.values;
end

for i = 1:numel(cell_line_names)
    for j = 1:numel(new_column_names)
        for k = 1:numel(new_column_names)

            if new_column_names(j)==new_column_names(k)
                continue
            end

            % Create figure
            fig = figure('Name', cell_line_names(i),'Position',[50,50, 1600, 1600]);

            switch options.type
                case 'scatter'

                    scatter(total_data_sets{i}.(new_column_names(j)),total_data_sets{i}.(new_column_names(k)))

                case 'bin scatter'

                    if options.do_binwidth
                        binscatter(total_data_sets{i}.(new_column_names(j)),total_data_sets{i}.(new_column_names(k)),[options.binwidth,options.binwidth])
                    else
                        binscatter(total_data_sets{i}.(new_column_names(j)),total_data_sets{i}.(new_column_names(k)))
                    end

                case '3d histogram'

                    if options.do_bins
                        histogram2(total_data_sets{i}.(new_column_names(j)),total_data_sets{i}.(new_column_names(k)),options.bins,'FaceColor','flat')
                    else
                        histogram2(total_data_sets{i}.(new_column_names(j)),total_data_sets{i}.(new_column_names(k)),'FaceColor','flat')
                    end

            end

            % Add plot labels
            xlabel(new_column_names(j))
            ylabel(new_column_names(k))

            %Title figure window
            sgtitle(cell_line_names(i))

            %Save figure window
            saveas(fig,strcat(outputplot_dir,"Marker Combinations Scatter\",cell_line_names(i),"\",cell_line_names(i),"_",new_column_names(j)," vs ",new_column_names(k),".png"))

            %close figure window
            close(fig)

        end
    end
end

end

