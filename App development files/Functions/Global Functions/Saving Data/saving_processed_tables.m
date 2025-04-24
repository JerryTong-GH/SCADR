function saving_processed_tables(total_data_sets,cell_line_names,outputdata_dir,save_file_type,data_set_name,do_log_table)
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
    do_log_table {mustBeVector(do_log_table)}
end

%% Function Starts

switch class(total_data_sets)

    case 'cell'
        for i = 1:numel(cell_line_names)
            writetable(total_data_sets{i},fullfile(outputdata_dir,data_set_name,strcat(cell_line_names(i),save_file_type)))
        end

    case 'dictionary'
    % Ensure output directory exists
    % Ensure output directory exists
    output_path = fullfile(outputdata_dir, data_set_name);
    if ~exist(output_path, 'dir')
        mkdir(output_path);
    end
    
    % Fix file extension
    save_file_type = "." + strip(save_file_type, "left", ".");

    
    % Loop through dictionary
    keys = total_data_sets.keys;
    values = total_data_sets.values;
    
    for i = 1:numel(keys)
        key = keys{i};
        tbl = values{i};
    
        if ~istable(tbl)
            warning("Skipping key '%s': not a table.", key);
            continue;
        end
    
        % Check log table length matches table width
        if width(tbl) ~= numel(do_log_table)
            warning("Size mismatch at key '%s': table has %d columns, log table has %d entries.", ...
                key, width(tbl), numel(do_log_table));
            continue;
        end
    
        % Select only columns to keep
        tbl_filtered = tbl(:, do_log_table);
    
        % Save filtered table
        [~, clean_key] = fileparts(key);  % strips any extension
        filename = fullfile(output_path, strcat(clean_key, save_file_type));
        writetable(tbl_filtered, filename);
    end

end

end

