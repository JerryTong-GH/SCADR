function [total_data_sets] = channel_name_change(total_data_sets,column_names)
%CHANNEL_NAME_CHANGE Summary of this function goes here
% rename columns

%% Define arguments
arguments
    %import variables
    total_data_sets {mustBeA(total_data_sets,{'table','cell','dictionary'})}
    %which channels to rename
    column_names {mustBeA(column_names,'dictionary')}
end

%% Function Starts
switch string(class(total_data_sets))
    case "dictionary"
        cell_line_names = total_data_sets.keys;
        total_data_sets = total_data_sets.values;
        for i = 1:numel(total_data_sets)
            total_data_sets{i} = renamevars(total_data_sets{i},values(column_names),keys(column_names));
        end
        total_data_sets = dictionary(cell_line_names,total_data_sets);
    case "cell"
        for i = 1:numel(total_data_sets)
            total_data_sets{i} = renamevars(total_data_sets{i},values(column_names),keys(column_names));
        end
    case "table"
        total_data_sets = renamevars(total_data_sets,values(column_names),keys(column_names));
end

end

