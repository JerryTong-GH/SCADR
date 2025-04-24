function [dataset_dictionary,process_settings] = master_process_library_of_packs( ...
    dataset_dictionary, data_set_list,... %import variables
    outputdata_dir,outputplot_dir, Datafiletype, ... %saving directories and data filetype
    new2old_column_names, ... %which channels to rename
    marker_list, ... which channels are relevant markers
    dataset_absolute_filter_bounds, ... lower and upper absolute marker filters
    dataset_quantile_filter_bounds, ... lower and upper quantile marker filters
    dataset_marker_polygon_filter, ... % polygon scatter filter
    Normalisingchannelname, marker_do_normalise, ... normalising channel name and which channels to normalise
    do_log_data, ... %whether to log data
    do_zero_adjust, ... %zero adjust
    filter_order, ... %filter order
    options)
%MASTER_PROCESS_ALL_DATA Processes all data with inputted parameters
%   Detailed explanation goes here

%% Define arguments
arguments
    %import variables
    dataset_dictionary {mustBeA(dataset_dictionary,{'cell','dictionary'})}
    data_set_list {mustBeA(data_set_list,{'string','char'})}
    %saving directories and data filetype
    outputdata_dir {mustBeA(outputdata_dir,{'string','char'})}
    outputplot_dir {mustBeA(outputplot_dir,{'string','char'})}
    Datafiletype {mustBeA(Datafiletype,{'string','char'})}
    %which channels to rename
    new2old_column_names {mustBeA(new2old_column_names,'dictionary')}
    %which channels are relevant markers
    marker_list {mustBeA(marker_list,{'string','cell'})}
    %lower and upper absolute marker filters
    dataset_absolute_filter_bounds {mustBeA(dataset_absolute_filter_bounds,'dictionary')}
    %lower and upper quantile marker filters
    dataset_quantile_filter_bounds {mustBeA(dataset_quantile_filter_bounds,'dictionary')}
    %polygon filter
    dataset_marker_polygon_filter {mustBeA(dataset_marker_polygon_filter,'dictionary')}
    %normalising channel name and which channels to normalise
    Normalisingchannelname {mustBeA(Normalisingchannelname,{'string','char'})}
    marker_do_normalise {dictionary}
    %decide whether to log data
    do_log_data {mustBeVector(do_log_data)}
    %decide whether to zero adjust
    do_zero_adjust
    %filter order
    filter_order
end

%Optional arguments
arguments
    options.app
end

%% Function Starts
%% Initialise
if ~isfield(options,'app') %check whether figure was specified for progress bar
    options.app = uifigure("WindowStyle","alwaysontop","Name",strcat("Progress for: ",data_set_name),"Position",[500,500,600,200]);
    close_app_fig = 1;
else %if specified, don't close figure
    options.app = options.app.UIFigure;
    close_app_fig = 0;
end

%% Ensure data of right type
%ensure it's string
marker_list = string(marker_list);
data_set_list = string(data_set_list);

%% Start processing each dataset pack
for j = 1:numel(data_set_list)
    data_set_name = data_set_list(j);
    loadbar = uiprogressdlg(options.app,'Title',strcat("Loading ",data_set_name),...
        'Indeterminate','on');

    %% Pick out packs
    % Pick out dataset name's variant pack
    variant_pack = dataset_dictionary(data_set_name);
    % Pick out dataset pack features
    cell_line_names = variant_pack.keys;
    num_cell_lines = numel(cell_line_names);
    % Pick out dataset pack filters
    variant_pack_absolute_filter_bounds = dataset_absolute_filter_bounds(data_set_name);
    variant_pack_quantile_filter_bounds = dataset_quantile_filter_bounds(data_set_name);
    variant_pack_polygon_filter = dataset_marker_polygon_filter(data_set_name);

    % Initialise plot and data save directories
    dataset_outputdata_dir = fullfile(outputdata_dir,data_set_name);
    dataset_outputplot_dir = fullfile(outputplot_dir,data_set_name);

    initialise_plot_save_dirs(outputdata_dir,outputplot_dir,cell_line_names,data_set_name)

    %% Process data for each cell line in the data set pack
    loadbar.Message = strcat("Processing ",data_set_name);

    [variant_pack] = master_process_single_pack( ...
    variant_pack,... %import variables
    new2old_column_names, ... %which channels to rename
    marker_list, ... which channels are relevant markers
    variant_pack_absolute_filter_bounds, ... lower and upper absolute marker filters
    variant_pack_quantile_filter_bounds, ... lower and upper quantile marker filters
    variant_pack_polygon_filter, ... %polygon filter
    Normalisingchannelname, marker_do_normalise, ... normalising channel name and which channels to normalise
    do_log_data(j), ... %whether to log data
    do_zero_adjust, ...
    filter_order);  %zero adjust

    %% Save pack to dataset
    dataset_dictionary(data_set_name) = variant_pack;

    %Loadbar
    loadbar.Message = "Saving Data...";
    loadbar.Indeterminate = 'on';
    %% Write variant pack into tables
    saving_processed_tables(variant_pack,cell_line_names,outputdata_dir,Datafiletype,data_set_name,do_log_data);

    %% Save variant pack process settings
    %process_settings
    %import variables
    process_settings.cell_line_names = cell_line_names;
    %saving directories and data filetype
    process_settings.outputdata_dir = dataset_outputdata_dir;
    process_settings.outputplot_dir = dataset_outputplot_dir;
    process_settings.Datafiletype = Datafiletype;
    process_settings.data_set_name = data_set_name;
    %which channels to rename
    process_settings.new2old_column_names = new2old_column_names;
    %which channels are relevant markers
    process_settings.marker_list = marker_list;
    %lower and upper absolute marker filters
    process_settings.variant_absolute_filter_bounds = variant_pack_absolute_filter_bounds;
    %lower and upper quantile marker filters
    process_settings.variant_quantile_filter_bounds = variant_pack_quantile_filter_bounds;
    %marker polygon filter
    process_settings.variants_marker_polygon_filter = variant_pack_polygon_filter;
    %normalising channel name and which channels to normalise
    process_settings.Normalisingchannelname = Normalisingchannelname;
    process_settings.marker_do_normalise = marker_do_normalise;
    %decide whether to log data
    process_settings.do_log_data = do_log_data(j);

    save(fullfile(dataset_outputdata_dir,'Settings.mat'),'process_settings')

    % save(strcat(outputdata_dir,data_set_name,"\",'Settings.mat'),'process_settings')
end

pause(1)
close(loadbar)

if close_app_fig
    delete(options.app)
end

end

