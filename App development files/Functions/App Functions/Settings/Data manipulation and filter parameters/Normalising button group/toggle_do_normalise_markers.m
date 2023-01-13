function [marker_do_normalise_buttons,bg] = toggle_do_normalise_markers(master_fig,position,marker_list)
%TOGGLE_DO_NORMALISE_MARKERS Summary of this function goes here
%   Detailed explanation goes here

    bg = uibuttongroup(master_fig,'Position',position,'Scrollable','on');

    % top_pos = numel(marker_list)*30;
    top_pos = position(4)-35;
    increment = 30;

    marker_do_normalise_buttons = cell(numel(marker_list),1);

if numel(marker_list)>0
    for i = 1:numel(marker_list)
        marker_do_normalise_buttons{i} = uibutton(bg,'state','Position',[11 (top_pos-increment*(i-1)) position(3)-22 22],'Text',string(marker_list{i}));
    end

end

end
