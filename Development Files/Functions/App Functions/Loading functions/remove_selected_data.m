function [] = remove_selected_data(title,inputdata_dir)
%REMOVE_SELECTED_DATA Summary of this function goes here
%   Detailed explanation goes here

for i = 1:numel(title)
    filename = dir(fullfile(inputdata_dir,strcat(title{i},'.*')));
    filename = filename.name;

    delete(fullfile(inputdata_dir,filename))
end

end

