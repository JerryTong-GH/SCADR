function [marker_do_normalise_buttons,bg] = toggle_do_normalise_markers_2(master_fig,marker_list,options)
%TOGGLE_DO_NORMALISE_MARKERS Summary of this function goes here
%   Detailed explanation goes here
arguments
    master_fig
    marker_list
end

arguments
    options.position
end

%% Function starts

options = namedargs2cell(options);

switch class(master_fig)
    case 'matlab.ui.container.Panel'
        position = [0,0,master_fig.Position(3:4)];
        bg = uibuttongroup(master_fig,'Position',[0,0,master_fig.Position(3:4)],'Scrollable','on');
end


    left_indent = 11;
    nbuttons = numel(marker_list);
    button_depth = 22;
    button_width = position(3)-left_indent*2;
    increment = 10;
    top_pos = nbuttons*(button_depth+increment)+increment;
    top_pos = max(top_pos,position(4));

    marker_do_normalise_buttons = cell(nbuttons,1);

if nbuttons>0
    for i = 1:nbuttons
        marker_do_normalise_buttons{i} = uibutton(bg,'state', ...
            'Position',[left_indent, (top_pos-(increment+button_depth)*(i)), button_width, button_depth], ...
            'Text',string(marker_list{i}));
    end

end

end
