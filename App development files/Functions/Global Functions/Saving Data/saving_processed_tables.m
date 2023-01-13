function saving_processed_tables(total_data_sets,cell_line_names,outputdata_dir,save_file_type,data_set_name)
%SAVING_PROCESSED_TABLES Save process and filtered tables
%   Detailed explanation goes here
%% Define arguments
arguments
    %import variables
    total_data_sets {mustBeA(total_data_sets,{'cell','dictionary'})}
    cell_line_names {mustBeA(cell_line_names,{'string','cell'})}
    %saving directories and data filetype
    outputdata_dir {mustBeA(outputdata_dir,{'string','char'})}
    save_file_type {mustBeA(save_file_type,{'string','char'})}
    data_set_name {mustBeA(data_set_name,{'string','char'})}
end

%% Function Starts

switch class(total_data_sets)

    case 'cell'
        for i = 1:numel(cell_line_names)
            writetable(total_data_sets{i},strcat(outputdata_dir,data_set_name,"\",cell_line_names(i),save_file_type))
        end

    case 'dictionary'
        cell_line_names = total_data_sets.keys;
        total_data_sets = total_data_sets.values;
        for i = 1:numel(cell_line_names)
            writetable(total_data_sets{i},fullfile(outputdata_dir,data_set_name,strcat(cell_line_names(i),save_file_type)))
        end
end

end

