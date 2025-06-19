function [fig,tileaxes] = correlation_variant_plot(total_data_sets,cell_line_names,selected_cell_lines, ...
    marker_list, ...
    options)
%CORRELATION_VARIANT_PLOT Summary of this function goes here
%   Detailed explanation goes here
%% Function arguments
% required inputs
arguments
    total_data_sets {mustBeA(total_data_sets,{'cell','dictionary'})}
    cell_line_names {mustBeA(cell_line_names,{'string','cell'})}
    selected_cell_lines {mustBeA(selected_cell_lines,{'string','cell'})}
    marker_list {mustBeA(marker_list,{'string','char','cell'})}
end

% optional
arguments
    % app plot
    options.app
    options.panel {mustBeA(options.panel,{'matlab.ui.container.Panel'})}
    % plot type
    options.type (1,:) string {mustBeMember(options.type,{'scatter','bin scatter'})} = 'scatter';
    options.marker_type {mustBeA(options.marker_type,{'string','char'})} = "x";
    % histogram settings
    options.do_histbins = 0;
    options.histbins = 30;
    options.do_scatterbins = 0;
    options.scatterbins = 200;
    % correlation settings
    options.correlation_method {mustBeMember(options.correlation_method,{'Pearson','Kendall','Spearman'})} = 'Spearman';
    % adjust plot data
    options.do_scatter = 1;
    options.do_linear_fit = 0;
    options.do_annotate_plots = 1;
    options.do_drawnow = 1;
end

%% Function begins
%% If not using an app
fig = 0;
if ~isfield(options,'panel')
    no_app = 1;
    fig = uifigure('Name', selected_cell_lines,'Position',[50,50, 1000, 1000]);
    options.panel = uipanel(fig,"Position",[0,0, 1000, 1000],"BorderType","none");
end

%% data conversions
selected_cell_lines = string(selected_cell_lines);
cell_line_names = string(cell_line_names);
marker_list = string(marker_list);

%% Create data matrix
%select data
switch class(total_data_sets)
    case 'cell'
        data = table2array(total_data_sets{cell_line_names==selected_cell_lines}(:,marker_list));
    case 'dictionary'
        selected_data = total_data_sets(selected_cell_lines);
        selected_data = selected_data{1};
        data = table2array(selected_data(:,marker_list));
end

nVars = numel(marker_list);

%% Create plotmatrix
tileaxes = tiledlayout(options.panel,nVars,nVars);
tileaxes.Padding = 'compact';

for y = 1:nVars
    for x = 1:nVars
        rowpos = (y-1)*nVars;

        %index subplot
        temp_ax = nexttile(tileaxes,rowpos+x);

        if y==x
            % plot histogram between quartile limits
            if     options.do_histbins
            histogram(temp_ax,data(:,y), ...
                options.histbins);
            else
                histogram(temp_ax,data(:,y));
            end

            if options.do_annotate_plots
                % add text stating mean and standard deviation
                text(temp_ax, ...
                    min(xlim(temp_ax))+range(xlim(temp_ax))*.05, ...
                    max(ylim(temp_ax)),...
                    sprintf('Mu=%.3f, std=%.3f',mean(data(:,x)),std(data(:,x))), ...
                    'Horiz','Left', ...
                    'Vert','top', ...
                    'FontSize',9, ...
                    'FontWeight','normal', ...
                    'Color','r')
            end
        else
            if options.do_scatter
                switch string(options.type)
                    case "bin scatter"
                        %Scatter plot
                        if options.do_scatterbins
                        binscatter(temp_ax,data(:,x),data(:,y),options.scatterbins);
                        else
                            binscatter(temp_ax,data(:,x),data(:,y));
                        end
                        
                        % remove colorbar
                        colorbar(temp_ax,"off");

                    case "scatter"
                        sp = scatter(temp_ax,data(:,x),data(:,y),options.marker_type);
                        sp.MarkerFaceAlpha = 0.4;
                        sp.MarkerEdgeAlpha = 0.4;
                end
            end
            %calculate correlation
            if options.do_annotate_plots
                switch options.correlation_method
                    case {'Pearson','Kendall','Spearman'}
                        [r,p] = corr(data(:,x),data(:,y),"type",options.correlation_method);
                end

                text(temp_ax, ...
                    min(data(:,x))+range(data(:,x))*.05, ...
                    max(data(:,y))+range(data(:,y))*.05,...
                    sprintf('r=%.2f, p=%.2f',r,p),'Horiz','Left', ...
                    'Vert','top', ...
                    'FontSize',9, ...
                    'FontWeight','normal', ...
                    'Color','r')
            end

            if options.do_linear_fit
                %calculate least squares linear fit
                c = polyfit(data(:,x),data(:,y),1);
                y_est = polyval(c,data(:,x));
                %plot least squares linear fit
                hold(temp_ax,"on")
                plot(temp_ax,data(:,x),y_est,'r--')
                hold(temp_ax,"off")
            end
        end

        %only label x axis of bottom row
        if y==nVars
            xlabel(temp_ax,marker_list(x))
        else
            xticklabels(temp_ax,[])
        end
        %only label y axis of left column
        if x==1
            ylabel(temp_ax,marker_list(y))
        else
            yticklabels(temp_ax,[])
        end
        if options.do_drawnow
            drawnow;
        end
    end
end

title(tileaxes,selected_cell_lines)

end

