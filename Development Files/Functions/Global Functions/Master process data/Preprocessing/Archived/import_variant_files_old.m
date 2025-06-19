function [total_data_sets] = import_variant_files(cell_line_names,file_types_supported)
%% Get file directories
total_data_sets = cell(numel(cell_line_names)+1,1);
filedirs = strings(numel(cell_line_names),1);

for i = 1:numel(cell_line_names)
    % check if file already exists
    for j = 1:numel(file_types_supported)
        if exist(strcat(cd,"\Input Data\",cell_line_names(i),file_types_supported(j)),"file")==2
            filedirs(i) = strcat(cd,"\Input Data\",cell_line_names(i),file_types_supported(j));
            break
        end
    end

    % user will file directory if not found
    if exist(filedirs(i))==0
        [temp_file, temp_path] = uigetfile({'*.csv';'*.xls'},strcat("Select data file/s for: ",cell_line_names(i)),MultiSelect="on");

        if(numel(temp_file)==1)
            filedirs(i) = strcat(temp_path,temp_file);
        else
            combined_data = concatenate_data(temp_file,temp_path,cell_line_names(i));
            filedirs(i) = strcat(temp_path,cell_line_names(i),".csv");
        end
    end

    %% Load in all files into master variable
    total_data_sets{i} = readtable(filedirs(i),"VariableNamingRule","preserve");
end

end

