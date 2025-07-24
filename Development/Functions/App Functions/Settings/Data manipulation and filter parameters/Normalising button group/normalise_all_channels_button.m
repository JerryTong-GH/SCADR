function [marker_do_normalise_buttons] = normalise_all_channels_button(marker_do_normalise_buttons)
%NORMALISE_ALL_CHANNELS_BUTTON Summary of this function goes here
%   Detailed explanation goes here

if numel(marker_do_normalise_buttons)>0
    for i = 1:numel(marker_do_normalise_buttons)
        marker_do_normalise_buttons{i}.Value = 1;
    end
end

end

