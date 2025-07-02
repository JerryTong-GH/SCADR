function [newpath] = concatenate_data(temp_file,temp_path,title,save_dir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% combined_data = readtable(strcat(temp_path,temp_file{1}),"VariableNamingRule","preserve");
combined_data = [];
if class(temp_file)=='cell'
    for i = 1:numel(temp_file)
        temp_data = readtable(strcat(temp_path,temp_file{i}),"VariableNamingRule","preserve");
        combined_data = [combined_data;temp_data];
    end
else
    combined_data = readtable(strcat(temp_path,temp_file),"VariableNamingRule","preserve");
end

newpath = strcat(title,".csv");
newpath = fullfile(save_dir,newpath);
writetable(combined_data,newpath);

end

