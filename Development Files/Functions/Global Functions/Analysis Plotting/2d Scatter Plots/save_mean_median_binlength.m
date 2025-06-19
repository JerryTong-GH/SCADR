function save_mean_median_binlength(num_bins, data_dict, selected_cell_lines, group_column, binning_column)
    % Validate inputs
    if ~isa(data_dict, 'dictionary')
        error('Input must be a dictionary.');
    end
    if ~ischar(group_column) && ~isstring(group_column)
        error('Group column name must be a string.');
    end
    if ~ischar(binning_column) && ~isstring(binning_column)
        error('Binning column name must be a string.');
    end

    % Ask user to select output folder
    output_folder = uigetdir(pwd, 'Select Output Folder to Save Result Files');
    if isequal(output_folder, 0)
        msgbox('No output folder selected. Exiting.', 'Error', 'error');
        return;
    end

    % Loop through each selected cell line
    for i = 1:length(selected_cell_lines)
        % Retrieve the table for the selected cell line
        cell_line = selected_cell_lines(i);
        
        if ~isKey(data_dict, cell_line)
            warning('Selected cell line "%s" not found in dictionary.', cell_line);
            continue;
        end
        
        % Get the table for the current cell line
        data_table = data_dict(cell_line);
        if iscell(data_table)
            data_table = data_table{1}; % Unwrap if it's inside a cell
        end

        % Validate the table has necessary columns
        if ~ismember(binning_column, data_table.Properties.VariableNames)
            error('Column "%s" not found in table.', binning_column);
        end
        if ~ismember(group_column, data_table.Properties.VariableNames)
            error('Column "%s" not found in table.', group_column);
        end

        % Ensure column names are strings
        binning_column = char(binning_column);
        group_column = char(group_column);

        % Clean and sanitize cell line name
        cell_line_str = strtrim(cell_line); % Remove leading/trailing spaces
        cell_line_str = regexprep(cell_line_str, '[^\w\s]', ''); % Remove non-alphanumeric characters

        % Extract the binning and group values from the table
        bin_values = data_table.(binning_column);
        group_values = data_table.(group_column);

        if all(bin_values == bin_values(1)) || ~isnumeric(bin_values)
            warning("Skipping cell line %s: Binning column invalid or constant.", cell_line_str);
            continue;
        end

        % Create bins
        bin_edges = linspace(min(bin_values), max(bin_values), num_bins + 1);
        bin_indices = discretize(bin_values, bin_edges);
        data_table.Bin = bin_indices;

        % Sanitize the filename
        safe_cell_line = matlab.lang.makeValidName(cell_line_str); % Sanitize cell line name
        safe_binning_column = matlab.lang.makeValidName(binning_column); % Sanitize column name

        % Construct the file name for this cell line
        out_file = fullfile(output_folder, ...
            sprintf('%s_binned_by_%s_%dbins.csv', safe_cell_line, safe_binning_column, num_bins));

        % Test if the file can be written
        if exist(out_file, 'file')
            [fid_test, errmsg] = fopen(out_file, 'a');
            if fid_test == -1
                warning('Skipping cell line %s: File "%s" is already open or not writable.\nReason: %s', ...
                    cell_line_str, out_file, errmsg);
                continue;
            else
                fclose(fid_test);
            end
        end

        % Open file for writing
        [fid, errmsg] = fopen(out_file, 'w');
        if fid == -1
            warning('Skipping cell line %s: Failed to open "%s" for writing.\nReason: %s', ...
                cell_line_str, out_file, errmsg);
            continue;
        end

        % Write header
        fprintf(fid, 'Group: %s\n', group_column);
        fprintf(fid, 'Bin Range,Bin Length,Mean,Median\n');

        % Write the data for each bin
        for b = 1:num_bins
            bin_rows = data_table(data_table.Bin == b, :);
            if ~isempty(bin_rows)
                bin_start = bin_edges(b);
                bin_end = bin_edges(b + 1);
                bin_range = sprintf('%.2f to %.2f', bin_start, bin_end);
                bin_length = bin_end - bin_start;
                mean_val = mean(bin_rows.(group_column), 'omitnan');
                median_val = median(bin_rows.(group_column), 'omitnan');

                fprintf(fid, '%s,%.2f,%.4f,%.4f\n', ...
                    bin_range, bin_length, mean_val, median_val);
            end
        end

        % Close the file after writing
        fclose(fid);
        fprintf('Saved: %s\n', out_file);
    end

    msgbox('All files processed successfully.', 'Success');
end
