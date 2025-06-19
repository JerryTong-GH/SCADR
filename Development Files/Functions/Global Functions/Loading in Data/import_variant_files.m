function [dataset_dictionary] = import_variant_files(cell_line_names,file_types_supported,input_directory)
%% Get file directories
dataset_dictionary = dictionary(string.empty,cell.empty);
total_data_sets = cell(numel(cell_line_names),1);
filedirs = strings(numel(cell_line_names),1);

for i = 1:numel(cell_line_names)
    % check if file already exists
    for j = 1:numel(file_types_supported)
        if exist(strcat(input_directory,cell_line_names(i),file_types_supported(j)),"file")==2
            filedirs(i) = strcat(input_directory,cell_line_names(i),file_types_supported(j));
            break
        end
    end

    % user will file directory if not found
    if exist(filedirs(i))==0
        [temp_file, temp_path] = uigetfile({'*.csv';'*.xls'},strcat("Select data file/s for: ",cell_line_names(i)),MultiSelect="on");

        if temp_file==0
            continue
        end
        filedirs(i) = concatenate_data(temp_file,temp_path,cell_line_names(i),input_directory);
        
    end

    %% Load in all files into master variable
    total_data_sets{i} = readtable(filedirs(i),"VariableNamingRule","preserve");
end

dataset_dictionary(cell_line_names) = total_data_sets';

end

