function [] = correlation_matrix_plot4_save(total_data_sets,new_column_names,cell_line_names, ...
    do_linear_fit, ...
    scatterbins, ...
    histplot_upperquartile,histplot_lowerquartile,histbins)
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

    cell_variant_plot = cell_line_names(i);
    %create data matrix
    data = table2array(total_data_sets{cell_line_names==cell_variant_plot}(:,new_column_names));
    nVars = numel(new_column_names);

    % Create plotmatrix
    fig = figure('Name', cell_variant_plot,'Position',[50,50, 1600, 1600]);

    for y = 1:nVars
        for x = 1:nVars
            rowpos = (y-1)*nVars;
            %index subplot
            subplot(nVars,nVars,rowpos+x)

            if y==x
                % plot histogram between quartile limits
                histogram(data( ...
                    (data(:,y)>prctile(data(:,y),histplot_lowerquartile)&(data(:,y)<prctile(data(:,y),histplot_upperquartile))),y) ... 
                    ,histbins)
                % add text stating mean and standard deviation
                drawnow
                text(min(xlim)+range(xlim)*.05,0.99*max(ylim),...
                    sprintf('Mu=%.3f, std=%.3f',mean(data(:,x)),std(data(:,x))),'HorizontalAlignment','left','VerticalAlignment','top','FontSize',10,'FontWeight','bold','Color','r')
            else
                %Scatter plot
                binscatter(data(:,x),data(:,y),scatterbins);
                % remove colorbar
                colorbar off
                %calculate correlation
                [r,p] = corrcoef(data(:,x),data(:,y));
                %label correlation values
                drawnow
                text(min(xlim)+range(xlim)*.05,0.99*max(ylim),...
                    sprintf('r=%.2f, p=%.2f',r(1,2),p(1,2)),'HorizontalAlignment','left','VerticalAlignment','top','FontSize',10,'FontWeight','bold','Color','r')
                if do_linear_fit
                    %calculate least squares linear fit
                    c = polyfit(data(:,x),data(:,y),1);
                    y_est = polyval(c,data(:,x));
                    %plot least squares linear fit
                    hold on
                    plot(data(:,x),y_est,'r--')
                    hold off
                end
            end

            %only label x axis of bottom row
            if y==nVars
                xlabel(new_column_names(x))
            else
                xticklabels([])
            end
            %only label y axis of left column
            if x==1
                ylabel(new_column_names(y))
            else
                yticklabels([])
            end
        end
    end
    
    %Title figure window
    sgtitle(cell_variant_plot)

    %Save figure window
    saveas(fig,strcat(cd,"\Output Plots\Correlation Matrix\",cell_variant_plot,".png"))

    %close figure window
    close(fig)
    
end

end

