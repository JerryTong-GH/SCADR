function [marker_do_normalise] = register_do_normalise_markers_from_buttons(marker_do_normalise_buttons)
%REGISTER_DO_NORMALISE_MARKERS_FROM_BUTTONS Summary of this function goes here
%   Detailed explanation goes here

marker_do_normalise = dictionary();
if numel(marker_do_normalise_buttons)>0
    for i = 1:numel(marker_do_normalise_buttons)
        marker_do_normalise(string(marker_do_normalise_buttons{i}.Text)) = marker_do_normalise_buttons{i}.Value;
    end
end
end

