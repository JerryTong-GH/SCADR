function [value] = settings_popup_edit(position,title,label,value,options)
%SETTINGS_POPUP_EDIT Summary of this function goes here
%   Detailed explanation goes here
%% Function arguments
% required inputs
arguments (Input)
    position
    title {mustBeA(title,{'string','char'})}
end

% repeating inputs
arguments (Input,Repeating)
    label {mustBeA(label,{'string','char'})}
    value
    options
end

% output arguments repeating
arguments (Output,Repeating)
    value
end

%% Function begins
%% Create figure in specified position
master_panel = uifigure('Position',position,'Name',title,'Scrollable','on', ...
    "CloseRequestFcn",@(~,~) close());
% master_panel = uipanel('Parent',master_fig,'Position',[0,0,master_fig.Position(3:4)],'Scrollable','on');

%% Initialise making objects
% load up values
loadup_values = value;

%initialise starting postion
leftpos = 15;
rightpos = master_panel.Position(3)-15;
bottompos = 10;

%initialise edit objects and labels
object_text = cell(numel(label),1);
edit_objects = cell(numel(value),1);

%initialise button settings (subject to change with structure)
vertical_seperation = 20;
depth = 20;

edit_object_width = 70;
text_width = 200;

%% Add save and cancel button

% %'apply' button
% apply_button = uibutton(fig, ...
%     'Position',[320 100 100 22],...
%     "Text","Apply settings", ...
%     'ButtonPushedFcn',@(~,~) add_old_name_to_marker_list());

save_button_width = 100;
save_button_depth = 22;

%'save' button
save_button = uibutton(master_panel, ...
    'Position',[(master_panel.Position(3)/4)-(save_button_width/2), (bottompos), save_button_width, save_button_depth],...
    "Text","Save settings", ...
    'ButtonPushedFcn',@(~,~) save_settings());

cancel_button_width = 100;
cancel_button_depth = 22;

%'Cancel' button
revert_change_button = uibutton(master_panel, ...
    "Text","Revert changes",...
    'Position',[(master_panel.Position(3)/4)*3-(cancel_button_width/2), (bottompos), cancel_button_width, cancel_button_depth],...    "Text","Cancel", ...
    'ButtonPushedFcn',@(~,~) revert_changes());

bottompos = bottompos+max(cancel_button_depth,save_button_depth)+vertical_seperation;

%% Create edit objects and labels
for i = 1:numel(label)
    %% register settings from options structure
    % Determine which edit field type to create
    switch isfield(options{i},"type")
        case 1
            fieldtype = options{i}.type;

        case 0
            fieldtype = "number_edit";
    end

    %% Start creating edit objects
    %create text label
    object_text{i} = uilabel(master_panel,"Text",label{i}, ...
        "WordWrap","on", ...
        'Position',[leftpos,bottompos,text_width,depth]);
    %create edit field
    switch fieldtype
        case "number_edit"
    edit_objects{i} = uieditfield(master_panel,"numeric", ...
        'Value',value{i}, ...
        "Position",[rightpos-edit_object_width,bottompos,edit_object_width,depth]);
    end
    
    %% Update offset bottom position
    bottompos = bottompos+vertical_seperation+depth;
end



% uiwait(master_panel);

%% Button Functions
    function close()
        delete(master_panel)
    end

    function save_settings()
        %save values
        for j = 1:numel(edit_objects)
            value{j} = edit_objects{j}.Value;
        end
    end

    function revert_changes()
        %save values
        for j = 1:numel(edit_objects)
            edit_objects{j}.Value = loadup_values{j};
        end
        save_settings()
    end

end

