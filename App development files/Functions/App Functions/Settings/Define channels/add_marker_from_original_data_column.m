function [old_column_names_list,new_column_names_list] = add_marker_from_original_data_column(old_column_names_list,new_column_names_list,total_data_sets)
%change_add_column_names Create popup ui to select old column name and write new column name
%   Detailed explanation goes here

%create popup figure
fig = uifigure("Name","Add marker channel from original channel name", ...
    "CloseRequestFcn",@(~,~) add_marker_from_original_data_column_cancel());
fig.Position(3:4) = [430,180];

%old column drop down text
old_column_label = uilabel(fig, ...
    'Position',[10,160,300,20], ...
    'Text',"Select old column name/s", ...
    'WordWrap','on','FontSize',14);

%pick out column names from first dataset loaded in
old_column_names = total_data_sets.values{1}.Properties.VariableNames; %old column names that may/may not have been taken
overlap = intersect(string(old_column_names),string(old_column_names_list)); %old column names that have been renamed

if numel(overlap)>0
    for i = 1:numel(overlap)
        old_column_names(string(old_column_names)==overlap(i)) = []; %old column names that haven't been renamed yet
    end
end

%create listbox of old columns to choose from
dd = uilistbox(fig,...
    'Position',[10 10 300 135],...
    'Items',old_column_names, ...
    'Multiselect','on');

%'Add' button
add_button = uibutton(fig, ...
    'Position',[320 100 100 22],...
    "Text","Add", ...
    'ButtonPushedFcn',@(~,~) add_old_name_to_marker_list());

%'Cancel' button
cancel_button = uibutton(fig, ...
    'Position',[320 40 100 22],...
    "Text","Cancel", ...
    'ButtonPushedFcn',@(~,~) add_marker_from_original_data_column_cancel());


uiwait(fig);

    function add_marker_from_original_data_column_cancel()
        delete(fig)
    end



    function add_old_name_to_marker_list()
        %add old channel name to marker list
        old_column_names_list = [old_column_names_list, dd.Value];
        new_column_names_list = [new_column_names_list, dd.Value];

        delete(fig)
    end

end


