function [dataset_dictionary] = import_data_sets(file_types_supported,inputdata_dir,dataset_dictionary,options)
%% Arguments
arguments (Input)
    file_types_supported
    inputdata_dir
    dataset_dictionary = dictionary(string.empty,dictionary);
end

arguments(Input)
    options.startup
    options.app
    options.collate_repeat_cell_line_names = 0;
end
%% Select folder
if ~isfield(options,'startup')
    folder_path = uigetdir(cd,'Select folder containing datasets');
    if folder_path == 0
        return
    end
    %% Find well info file
    [info_file,info_path] = uigetfile("*.xlsx","Select the well info file if it exists");
    info_path = fullfile(info_path,info_file);
else
    dataset_dictionary = dictionary(string.empty,dictionary);
    folder_path = inputdata_dir;

    info_dir = dir(inputdata_dir);

    info_file = "Well info.xlsx";

    for i = 1:numel(info_dir)
        if ~info_dir(i).isdir
            temp_file_name = info_dir(i).name;
            [~,~,temp_file_type] = fileparts(temp_file_name);
            if any(temp_file_type==file_types_supported)
                info_file = info_dir(i).name;
            end
        end
    end

    info_path = fullfile(inputdata_dir,info_file);
end

%% If well info file exists
if isfile(info_path)
    sheets = sheetnames(info_path);
    reference_info_data = dictionary(string.empty,cell.empty);
    for i = 1:numel(sheets)
        reference_info_data(sheets(i)) = {readtable(info_path,"VariableNamingRule","preserve","Sheet",sheets(i))};
    end

    cell_line_renames_table = reference_info_data("Variants");
    cell_line_renames_table = cell_line_renames_table{1};
    %% Get old and new names
    old_cell_line_names = string(cell_line_renames_table.("Well export"));
    new_cell_line_names = string(cell_line_renames_table.("Variants"));
    
    %% Add indexing to any repeat names
    [new_cell_line_names] = index_repeat_names(new_cell_line_names);

    cell_line_rename_dictionary = dictionary(old_cell_line_names,new_cell_line_names);

    channel_renames_table = reference_info_data("Antibodies");
    channel_renames_table = channel_renames_table{1};
    % Remove unnamed channels
    channel_renames_table = removevars(channel_renames_table,ismissing(channel_renames_table));
    % Create dictionary from remaining table
    channel_old_names = string(channel_renames_table.Properties.VariableNames);
    channel_new_names = string(channel_renames_table.Variables);
    [channel_new_names] = index_repeat_names(channel_new_names);

    channel_rename_dictionary = dictionary(channel_new_names,channel_old_names);

    do_reference_rename = 1;
else
    cell_line_rename_dictionary = [];
    channel_old_names = [];
    channel_new_names = [];
    do_reference_rename = 0;
end

if isfield(options,'app')
    figure(options.app.UIFigure);
end

%% Index all subfolders within folder
dirfiles = dir(folder_path);

if numel(dirfiles)<3
    return
end

dirfiles(1:2) = [];

dataset_check = extractfield(dirfiles,'isdir');
dataset_check = cell2mat(dataset_check);

if ~any(dataset_check)
    %% Load in single data set
    [folder_path,temp_dataset_name,~] = fileparts(folder_path);

    [dataset_dictionary] = import_single_data_set(options, ...
            inputdata_dir,temp_dataset_name,folder_path, ...
            dataset_dictionary,file_types_supported, ...
            do_reference_rename,cell_line_rename_dictionary,channel_old_names,channel_new_names);
else

    %% For each data set
    for i = 1:numel(dirfiles)
        %% Get data set name
        temp_dataset_name = string(dirfiles(i).name);

        [dataset_dictionary] = import_single_data_set(options, ...
            inputdata_dir,temp_dataset_name,folder_path, ...
            dataset_dictionary,file_types_supported, ...
            do_reference_rename,cell_line_rename_dictionary,channel_old_names,channel_new_names);

    end
end

end

