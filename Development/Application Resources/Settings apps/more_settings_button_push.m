function more_settings_button_push(settings_button,daddy,position,title,parameter_set_name,parameters,input_meta,input_settings)
%MORE_SETTINGS_BUTTON_PUSH Summary of this function goes here
%   Detailed explanation goes here

if isempty(position)
    position = daddy.UIFigure.Position;
end

if settings_button.Value
    settings_button.Enable = "off";
    settings_app(daddy, position, title, parameter_set_name, parameters, input_meta, input_settings, settings_button);
end

end

