function [cell_line_names] = input_data_folder_check(inputdata_dir)
%INPUT_DATA_FOLDER_CHECK Checks if there are files in input data folder
%   Detailed explanation goes here
cell_line_names = dir(inputdata_dir);
cell_line_names = {cell_line_names.name};
cell_line_names = string(cell_line_names);

if(numel(cell_line_names)>0)
    cell_line_names(1:2) = [];
    for i = 1:numel(cell_line_names)
        [~,cell_line_names(i),~] = fileparts(cell_line_names(i));
    end
else
    cell_line_names = {};
%     msgbox("No files found in 'Input Data' folder")
end

end

