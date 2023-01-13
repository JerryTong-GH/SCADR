% fig = uifigure;
% ax = axes(fig);
% surf(ax,peaks(20));
% roi = images.roi.Cuboid.empty;
% roi(end+1) = drawcuboid(ax);

% roi_selection = roi.Position;


% el = listener(roi,'MovingROI',@(src,evnt)tsne_allroievents(src,evnt));




% addlistener(roi,'MovingROI',@tsne_allroievents);
% addlistener(roi,'ROIMoved',@tsne_allroievents);

% function tsne_allroievents(src,evnt)
% evnt
% 
% end


%% Figure setup

% fig = figure;
% 
% fig_bottom = 50;
% fig_width = 500;
% fig_height = 600;
% 
% table_height = 120;
% table_width = 400;
% table_gap = 10;
% 
% fig.Position(2:4) = [fig_bottom,fig_width,fig_height];
% 
% pnl_fig = uipanel(fig,'BorderType','line','BorderWidth',3);
% 
% new_ax = copyobj(ax,pnl_fig);
% new_ax.Position([2,4]) = [0.25,0.71];
% legend(new_ax,ax.Legend.String{:})
% 
% tbl_fig = uitable(pnl_fig,'Units','normalized');
% tbl_fig.Position = [0.05,0.01,0.9,0.18];







