function [] = tsne_plot_selection_popout(ax,Y,variant_ID,options)
%TSNE_PLOT_POLYGON_POPOUT Summary of this function goes here
%   Detailed explanation goes here
%% Arguments
arguments (Input)
    ax
    Y
    variant_ID
end

arguments (Input)
    options.app
end
%% Function starts
%% Setup figure, panel, axes and table
fig = uifigure;

fig_bottom = 50;
fig_width = 500;
fig_height = 600;

table_height = 120;
table_width = 400;
table_gap = 10;

if isfield(options,'app')
    fig.Position(1) = options.app.UIFigure.Position(1);
end

fig.Position(2:4) = [fig_bottom,fig_width,fig_height];

fig.Units = 'normalized';

pnl_fig = uipanel(fig,'Units','normalized','Position',[0,0,1,1],'BorderType','line','BorderWidth',3);

new_ax = copyobj(ax,pnl_fig);
new_ax.Position([2,4]) = [0.25,0.7];
legend(new_ax,ax.Legend.String{:})

tbl_fig = uitable(pnl_fig,'Units','normalized');
tbl_fig.Position = [0.05,0.01,0.9,0.18];

%% Initialise table
% Initialise table data
selected_cell_lines = unique(variant_ID);
num_cell_lines = numel(selected_cell_lines);
num_cells = zeros(num_cell_lines,1);
for i = 1:num_cell_lines
    num_cells(i) = sum(variant_ID==selected_cell_lines(i));
end

table_data = zeros(3,num_cell_lines);

% table names
rowlabel = ["Number of cells selected","% of cells of entire variant","% of variant within selection"];
plot_table = array2table(table_data,"VariableNames",selected_cell_lines',"RowNames",rowlabel');

tbl_fig.ColumnName = selected_cell_lines';
tbl_fig.RowName = rowlabel';
tbl_fig.Data = plot_table;

%% Draw polygon

ydims = size(Y);

switch ydims(2)
    case 2
        roi = drawpolygon(new_ax);
    case 3
        roi = drawcuboid(new_ax);
end

if isempty(roi.Position)
    return
else
    update_roi_table;
end

addlistener(roi,'DrawingStarted',@tsne_allroievents);
addlistener(roi,'DrawingFinished',@tsne_allroievents);
addlistener(roi,'MovingROI',@tsne_allroievents);
addlistener(roi,'ROIMoved',@tsne_allroievents);

    function tsne_allroievents(~,event)
        roi.Position = event.CurrentPosition;
        update_roi_table;
    end

    function update_roi_table
        % Find cells inside
        switch ydims(2)
            case 2
                index_in = inROI(roi,Y(:,1),Y(:,2));
            case 3
                index_in = inROI(roi,Y(:,1),Y(:,2),Y(:,3));
        end

        total_selected_cells = sum(index_in);
        selected_cell_categories = variant_ID(index_in);
        for i = 1:num_cell_lines
            current_line = selected_cell_lines(i);
            table_data(1,i) = sum(selected_cell_categories==current_line);
            table_data(2,i) = sum(selected_cell_categories==current_line)/num_cells(i)*100;
            table_data(3,i) = sum(selected_cell_categories==current_line)/sum(index_in)*100;
        end
        tbl_fig.Data = array2table(table_data,"VariableNames",selected_cell_lines',"RowNames",rowlabel');
        fig.Name = strcat("Total selected cells: ",string(total_selected_cells));
    end

end

