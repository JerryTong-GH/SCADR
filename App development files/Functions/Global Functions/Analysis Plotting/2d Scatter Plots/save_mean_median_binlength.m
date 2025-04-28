function save_mean_median_binlength(num_bins, data_table, binning_column)
    % Validate inputs
    if ~istable(data_table)
        error('Second input must be a table.');
    end
    if ~ischar(binning_column) && ~isstring(binning_column)
        error('Binning column name must be a string.');
    end
    if ~ismember(binning_column, data_table.Properties.VariableNames)
        error('Column "%s" not found in table.', binning_column);
    end
    if ~isnumeric(data_table.(binning_column))
        error('Binning column "%s" must be numeric.', binning_column);
    end

    % Ask for output folder
    output_folder = uigetdir(pwd, 'Select Output Folder to Save Result');
    if isequal(output_folder, 0)
        msgbox('No output folder selected. Exiting.', 'Error', 'error');
        return;
    end

    % Binning logic
    bin_col_data = data_table.(binning_column);
    bin_edges = linspace(min(bin_col_data), max(bin_col_data), num_bins + 1);
    bin_indices = discretize(bin_col_data, bin_edges);
    data_table.Bin = bin_indices;

    % Get other columns
    remaining_columns = setdiff(data_table.Properties.VariableNames, binning_column);

    % Prepare output file
    timestamp = datestr(now, 'yyyymmdd_HHMMSS');
    out_file = fullfile(output_folder, ...
        sprintf('binned_by_%s_%dbins_%s.csv', binning_column, num_bins, timestamp));
    fid = fopen(out_file, 'w');

    % Write stats for each group
    for i = 1:length(remaining_columns)
        group = remaining_columns{i};
        if ~isnumeric(data_table.(group))
            continue;
        end

        fprintf(fid, 'Group: %s\n', group);
        fprintf(fid, 'Bin Range,Bin Length,Mean,Median\n');

        for bin_idx = 1:num_bins
            rows = data_table(data_table.Bin == bin_idx, :);
            if ~isempty(rows)
                bin_start = bin_edges(bin_idx);
                bin_end = bin_edges(bin_idx + 1);
                bin_range = sprintf('%.2f to %.2f', bin_start, bin_end);
                bin_length = bin_end - bin_start;
                mean_val = mean(rows.(group), 'omitnan');
                median_val = median(rows.(group), 'omitnan');

                fprintf(fid, '%s,%.2f,%.4f,%.4f\n', bin_range, bin_length, mean_val, median_val);
            end
        end
        fprintf(fid, '\n');  % Blank line between groups
    end

    fclose(fid);
    fprintf('Saved result to: %s\n', out_file);
end
