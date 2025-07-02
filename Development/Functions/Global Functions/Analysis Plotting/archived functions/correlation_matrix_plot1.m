function [] = correlation_matrix_plot1(total_data_sets,new_column_names,cell_line_names, ...
    do_correlationmatrix_plot_expression,do_correlationmatrix_plot_normalise)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%% Correlation table

%Decide whether to keep expression and normalising channel in plots
if ~do_correlationmatrix_plot_expression
    new_column_names = new_column_names(new_column_names~=expression_channel_name);
end

if ~do_correlationmatrix_plot_normalise
    new_column_names = new_column_names(new_column_names~=normalising_channel_name);
end

for i = 1:numel(cell_line_names)
    %create data matrix
    data = table2array(total_data_sets{i}(:,new_column_names));
    nVars = numel(new_column_names);

    % Create plotmatrix
    figure('Name', cell_line_names(i),'Position',[200,100, 1000, 1000])
    [sh, ax, ~, hh] = plotmatrix(data);

    % Add axis labels
    arrayfun(@(h,lab)ylabel(h,lab),ax(:,1), cellstr(new_column_names))
    arrayfun(@(h,lab)xlabel(h,lab),ax(end,:), cellstr(new_column_names)')

    % Compute correlation for each scatter plot axis
    [r,p] = arrayfun(@(h)corr(h.Children.XData(:),h.Children.YData(:)),ax(~eye(nVars)));

    % Label the correlation and p values
    arrayfun(@(h,r,p)text(h,min(xlim(h))+range(xlim(h))*.05,max(ylim(h)),...
        sprintf('r=%.2f,  p=%.3f',r,p),'Horiz','Left','Vert','top','FontSize',10,'FontWeight','bold','Color','r'),...
        ax(~eye(nVars)),r,p)

    % Change marker appearance
    set(sh, 'Marker', 'o','MarkerSize', 2, 'MarkerEdgeColor', ax(1).ColorOrder(1,:))
    lsh = arrayfun(@(h)lsline(h),ax(~eye(nVars)));
    % Add least square regression line.
    set(lsh,'color', 'm')
end


%increase transparancy of points
% transparancy_val = repelem(0.1,size(data,1));
% alpha(hh(3),0.5)




% corrplot(total_data_sets{1}(:,new_column_names),'TestR','on')



end

