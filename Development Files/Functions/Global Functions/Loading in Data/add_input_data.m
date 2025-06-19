function [newpath,status] = add_input_data(save_dir)
%ADD_INPUT_DATA Ask user to select files (to concatenate if multiple
%selected) and save as *.csv in save_dir
%   Detailed explanation goes here
[temp_file, temp_path] = uigetfile({'*.csv';'*.xls'},"Select data file/s", MultiSelect="on");

if temp_path == 0
    newpath = [];
    status = 0;
    return
else
    status = 1;
end

if isequal(class(temp_file),"cell") %if multiple files selected
    [~,title,~] = fileparts(temp_file{1});
else %if only one file selected
    [~,title,~] = fileparts(temp_file);
end

title = inputdlg({"Provide a reference name"},"Title additional file",1,{title});

[newpath] = concatenate_data(temp_file,temp_path,string(title),save_dir);

end

