function [button_meta] = settings_filler(button_meta)
%SETTINGS_FILLER Summary of this function goes here
%   Detailed explanation goes here
%% Function arguments
% required inputs
arguments
    button_meta
end

% optional specified
% arguments
%     button_meta.label
%     button_meta.type = "numeric"
%     button_meta.vertical_seperation = 20
%     button_meta.depth = 20
%     button_meta.edit_object_width = 70
% end

%% Function begins
if isfield(button_meta,"type")
%     button_meta.type = button_meta.type;
else
    button_meta.type = "numeric";
end

if isfield(button_meta,"vertical_seperation")
%     button_meta.vertical_seperation = button_meta.vertical_seperation;
else
    button_meta.vertical_seperation = 20;
end

if isfield(button_meta,"edit_object_width")
%     button_meta.edit_object_width = button_meta.edit_object_width;
else
    button_meta.edit_object_width = 70;
end

if isfield(button_meta,"text_width")
%     button_meta.text_width = min(rightpos-button_meta.edit_object_width-15,button_meta.text_width);
else
    %     button_meta.text_width = rightpos-button_meta.edit_object_width-15;
%     button_meta.text_width = round(strlength(button_meta.label)*4);
button_meta.text_width = 170;
end

if isfield(button_meta,"depth")
%     button_meta.depth = button_meta.depth;
else
%     button_meta.depth = ceil(strlength(button_meta.label)^0.9/30)*20;
    button_meta.depth = 20;
end

end

