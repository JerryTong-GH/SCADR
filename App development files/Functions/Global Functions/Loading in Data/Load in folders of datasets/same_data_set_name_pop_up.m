function [answer] = same_data_set_name_pop_up(temp_dataset_name,dataset_dictionary,options)
%SAME_DATA_SET_NAME_POP_UP Summary of this function goes here
%   Detailed explanation goes here
%% Arguments
arguments (Input)
    temp_dataset_name
    dataset_dictionary
end

arguments
    options.position
end
%% Start Function

% delete(findall(0));

%create popup figure
fig = uifigure("Name","Rename Data Set", ...
    "CloseRequestFcn",@(~,~) close_fig());

if isfield(options,'position')
    fig.Position(1:2) = options.position(1:2);
end

fig.Position(3:4) = [500,170];

butt_height = 80;

%% Children
% enter data set name label
lbl = uilabel(fig, ...
    'Position',[10,butt_height,140,20], ...
    'Text',"Rename dataset", ...
    'WordWrap','on','FontSize',14);

% Create edit field
dataset_field = uieditfield(fig, ...
    'Position',[160,butt_height,270,20],...
    'Value',temp_dataset_name, ...
    'ValueChangingFcn',@(~,~) check_name(), ...
    'FontSize',14);

% rename button
btn_rename = uibutton(fig, ...
    'Text','', ...
    "Icon",'success', ...
    'Position',[440,butt_height,20,20], ...
    'Tooltip',"Save name", ...
    'ButtonPushedFcn',@(~,~) confirm_name());

btn_cancel = uibutton(fig, ...
    'Text','', ...
    "Icon",'Cancel.png', ...
    'Position',[470,butt_height,20,20], ...
    'Tooltip',"Cancel and skip dataset", ...
    'ButtonPushedFcn',@(~,~) close_fig());

%% Functions
invalid_chars = ["<",">",":","""","/","\","|","?","*"];

editbox_timer = timer("Period",0.5,"TimerFcn",@(~,~) check_name(),'ExecutionMode','fixedRate');

start(editbox_timer);
answer = [];

uiwait(fig)

    function check_name()
        if contains(dataset_field.Value,invalid_chars)
            dataset_field.Value = erase(dataset_field.Value,invalid_chars);
        end
    end

    function close_fig()
        answer = [];
        stop(editbox_timer);
        delete(editbox_timer);
        clear editbox_timer
        delete(fig)
    end

    function confirm_name()
        check_name()
        %check if new name exists already
        switch class(dataset_dictionary)
            case 'dictionary'
                if isKey(dataset_dictionary,dataset_field.Value)
                    message = {'Data set name already exists'};
                    uialert(fig,message,'WARNING','Icon','warning');
                    return
                end
            case 'string'
                overlap_names = intersect(dataset_dictionary,string(dataset_field.Value));
                if numel(overlap_names)>0
                    message = {'Data set name already exists'};
                    uialert(fig,message,'WARNING','Icon','warning');
                    return
                end
        end
        answer = dataset_field.Value;
        stop(editbox_timer);
        delete(editbox_timer);
        clear editbox_timer
        delete(fig)
    end

end

