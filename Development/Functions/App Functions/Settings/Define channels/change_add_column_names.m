function [old_column_names_list,new_column_names_list] = change_add_column_names(old_column_names_list,new_column_names_list,total_data_sets)
%change_add_column_names Create popup ui to select old column name and write new column name
%   Detailed explanation goes here

%create popup figure
fig = uifigure("Name","Add channel name to change", ...
    "CloseRequestFcn",@(~,~) change_add_column_names_cancel());
fig.Position(3:4) = [430,180];

%old column drop down text
old_column_label = uilabel(fig, ...
    'Position',[10,90,200,20], ...
    'Text',"Select old column name", ...
    'WordWrap','on','FontSize',14);

%new column drop down text
old_column_label = uilabel(fig, ...
    'Position',[220,90,200,20], ...
    'Text',"Write new column name", ...
    'WordWrap','on','FontSize',14);

%pick out column names from first dataset loaded in
old_column_names = total_data_sets.values{1}.Properties.VariableNames;
overlap = intersect(string(old_column_names),string(old_column_names_list));

if numel(overlap)>0
    for i = 1:numel(overlap)
        old_column_names(string(old_column_names)==overlap(i)) = [];
    end
end

% old_column_names = old_column_names(old_column_names~=old_column_names_list);

%create dropdown of old columns to choose from
dd = uidropdown(fig,...
    'Position',[10 70 200 22],...
    'Items',old_column_names);

%create editfield to add in new column name
newname = uieditfield(fig,...
    'Position',[220 70 200 22],...
    'Value',"e.g. protein 1");

%'Add' button
add_button = uibutton(fig, ...
    'Position',[100 10 100 22],...
    "Text","Add", ...
    'ButtonPushedFcn',@(~,~) change_add_column_names_add());

%'Cancel' button
cancel_button = uibutton(fig, ...
    'Position',[230 10 100 22],...
    "Text","Cancel", ...
    'ButtonPushedFcn',@(~,~) change_add_column_names_cancel());


uiwait(fig);

    function change_add_column_names_cancel()
        delete(fig)
    end



    function change_add_column_names_add()
        %check if new name exists already
        for i = 1:numel(new_column_names_list)
            if string(new_column_names_list{i})==string(newname.Value)

                message = {'New channel name already exists'};
                uialert(fig,message,'WARNING','Icon','warning');

                return
            end
        end

        %if the channel name is new, add and save to dictionary
        old_column_names_list{end+1} = dd.Value;
        new_column_names_list{end+1} = newname.Value;

        delete(fig)
    end

end


