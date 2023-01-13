function [] = pop_out_button(position,name,object2copy,options)
%POP_OUT_BUTTON Summary of this function goes here
%   Detailed explanation goes here
%% Function arguments
% required inputs
arguments (Input)
    position
    name {mustBeA(name,{'string','char'})}
    object2copy
    options.figfather
    options.tabpanel
    options.label
    options.dataset_name
end

arguments (Output)

end

%% Function begins
%% Create new figure to paste
if isfield(options,'figfather')
    base_pos = [options.figfather.Position(1:2),0,0];
    if isfield(options,'tabpanel')
        position = base_pos + options.tabpanel.Position;
    else
        old_units = object2copy.Units;
        object2copy.Units = 'pixels';
        position(1:2) = base_pos(1:2);
        position(3:4) = object2copy.Position(3:4);
        object2copy.Units = old_units;
    end
end

%% Initialise
if numel(name)>1
    name = strjoin(name," | ");
end

%% Add dataset name to figure name
if isfield(options,'dataset_name')
    name = strcat(options.dataset_name,": ",name);
end

%% Copy object
switch class(object2copy)
    case 'matlab.ui.control.UIAxes'
        fig = figure('Position',position,'Name',name);
        ax = axes(fig);

        objax = object2copy.Children;
        copyobj(objax,ax);

        legend(ax,object2copy.Legend.String{:})
        xlabel(ax,object2copy.XLabel.String)
        ylabel(ax,object2copy.YLabel.String)
        zlabel(ax,object2copy.ZLabel.String)
        title(ax,object2copy.Title.String)

    case 'matlab.graphics.layout.TiledChartLayout'
        fig = figure('Units','pixels','Position',position,'Name',name);
        new_obj = copyobj(object2copy,fig);
        new_obj.Units = 'normalized';
        new_obj.Position = [0.1,0.1,0.8,0.8];
    case 'matlab.ui.control.Table'
        fig = uifigure('Position',position,'Name',name);
        figtable = uitable(fig,'Position',[0,0,fig.Position(3:4)]);
        figtable.Data = object2copy.Data;
    case 'matlab.ui.container.Tab'
        fig = uifigure('Position',position,'Name',name,'Scrollable','on');
        tbgroup = uitabgroup(fig);
        copyobj(object2copy,tbgroup)
    case 'matlab.ui.container.Panel'
        fig = uifigure('Position',position,'Name',name,'Scrollable','on');
        copyobj(object2copy,fig)
end

end

