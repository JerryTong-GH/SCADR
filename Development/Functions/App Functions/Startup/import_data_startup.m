function [cell_line_names,comparison_cell_line_names,...
original_data_sets,processed_data_sets,...
original_comparison_data_sets,processed_comparison_data_sets]...
= import_data_startup( ...
inputdata_dir,input_comparison_data_dir,...
file_types_supported,app)
%IMPORT_ Summary of this function goes here
%   Detailed explanation goes here
%% Function arguments
% required inputs
arguments
    inputdata_dir {mustBeA(inputdata_dir,{'string','char'})}
    input_comparison_data_dir {mustBeA(input_comparison_data_dir,{'string','char'})}
    file_types_supported {mustBeA(file_types_supported,{'string','char','cell'})}
    app
end

%% Start Function

%Initialise load pages by automatically trying to load in data
%from input folder
progbar = uiprogressdlg(app.UIFigure,"Indeterminate","on","Message",'Searching for input data...');

cell_line_names = input_data_folder_check(inputdata_dir);
comparison_cell_line_names = input_data_folder_check(input_comparison_data_dir);

if numel(cell_line_names)<1
    original_data_sets = dictionary(string.empty,cell.empty);
    processed_data_sets = dictionary(string.empty,cell.empty);
    original_comparison_data_sets = dictionary(string.empty,cell.empty);
    processed_comparison_data_sets = dictionary(string.empty,cell.empty);
    uialert(app.UIFigure,'No files found','Loading Files','Icon','warning');
    return
end

if numel(cell_line_names)>0

    %% Load in data into original and processed_data_sets
    progbar.Message = 'Loading in original input data...';

    %load in data
    original_data_sets = import_variant_files(cell_line_names,file_types_supported,inputdata_dir);
    %copy over data to total_data_sets
    processed_data_sets = original_data_sets;

end

if numel(comparison_cell_line_names)>0
    %% Load in data into original and processed_data_sets
    progbar.Message = 'Loading in comparison data...';

    %load in data
    original_comparison_data_sets = import_variant_files(comparison_cell_line_names,file_types_supported,input_comparison_data_dir);
    %copy over data to total_data_sets
    processed_comparison_data_sets = original_comparison_data_sets;

end

close(progbar)


end

