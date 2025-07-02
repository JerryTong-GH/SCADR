function [] = min_max_pop_out_box(min,max,marker)
%MIN_MAX_POP_OUT_BOX Summary of this function goes here
%   Detailed explanation goes here
marker = string(marker);

if isempty(min)
    min = nan;
end

if isempty(max)
    max = nan;
end

fig = uifigure;

fig.Position(3:4) = [400,100];

max_text = strcat("Maximum ",marker," segment:");
min_text = strcat("Minimum ",marker," segment:");

max_label = uilabel(fig,"Text",max_text, ...
    "Position",[5,70,250,20]);
min_label = uilabel(fig,"Text",min_text, ...
    "Position",[5,20,250,20]);

max_field = uieditfield(fig,"numeric", ...
    "Value",max, ...
    "Position",[260,70,135,20]);

min_field = uieditfield(fig,"numeric", ...
    "Value",min, ...
    "Position",[260,20,135,20]);

end

