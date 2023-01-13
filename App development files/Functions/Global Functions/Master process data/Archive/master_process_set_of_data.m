function [processed_data_set,process_settings] = master_process_set_of_data( ...
    total_data_sets,cell_line_names, data_set_name,... %import variables
    outputdata_dir,outputplot_dir, Datafiletype, ... %saving directories and data filetype
    new2old_column_names, ... %which channels to rename
    marker_list, ... which channels are relevant markers
    variant_absolute_filter_bounds, ... lower and upper absolute marker filters
    variant_quantile_filter_bounds, ... lower and upper quantile marker filters
    variants_marker_polygon_filter, ... % polygon scatter filter
    Normalisingchannelname, marker_do_normalise, ... normalising channel name and which channels to normalise
    do_log_data, ... %whether to log data
    do_zero_adjust, ... %zero adjust
    appfig) 
%MASTER_PROCESS_ALL_DATA Processes all data with inputted parameters
%   Detailed explanation goes here

%% Define arguments
arguments
    %import variables
    total_data_sets {mustBeA(total_data_sets,{'cell','dictionary'})}
    cell_line_names {mustBeA(cell_line_names,{'string','cell'})}
    data_set_name {mustBeA(data_set_name,{'string','char'})}
    %saving directories and data filetype
    outputdata_dir {mustBeA(outputdata_dir,{'string','char'})}
    outputplot_dir {mustBeA(outputplot_dir,{'string','char'})}
    Datafiletype {mustBeA(Datafiletype,{'string','char'})}
    %which channels to rename
    new2old_column_names {mustBeA(new2old_column_names,'dictionary')}
    %which channels are relevant markers
    marker_list {mustBeA(marker_list,{'string','cell'})}
    %lower and upper absolute marker filters
    variant_absolute_filter_bounds {mustBeA(variant_absolute_filter_bounds,'dictionary')}
    %lower and upper quantile marker filters
    variant_quantile_filter_bounds {mustBeA(variant_quantile_filter_bounds,'dictionary')}
    %polygon filter
    variants_marker_polygon_filter {mustBeA(variants_marker_polygon_filter,'dictionary')}
    %normalising channel name and which channels to normalise
    Normalisingchannelname {mustBeA(Normalisingchannelname,{'string','char'})}
    marker_do_normalise {dictionary}
    %decide whether to log data
    do_log_data {double,logical}
    %decide whether to zero adjust
    do_zero_adjust
end

%Optional arguments
arguments
    appfig = 1;
end

%% Function Starts
%% Initialise
if isequal(appfig,1) %check whether figure was specified for progress bar
    appfig = uifigure("WindowStyle","alwaysontop","Name",strcat("Progress for: ",data_set_name),"Position",[500,500,600,200]);
    close_app_fig = 1;
else %if specified, don't close figure 
    close_app_fig = 0;
end

loadbar = uiprogressdlg(appfig,'Title',strcat("Processing: ",data_set_name),...
    'Indeterminate','on');

%ensure it's string
marker_list = string(marker_list);
cell_line_names = string(cell_line_names);

%convert to cell
if isequal(class(total_data_sets),'dictionary')
    to_dictionary = 1;
    total_data_sets = total_data_sets(cell_line_names);
end

%initialise plot and data save directories
initialise_plot_save_dirs(outputdata_dir,outputplot_dir,cell_line_names,data_set_name)

%processed data set
processed_data_set = cell(numel(total_data_sets),1);

%% Process data for each variant in the data set
loadbar.Indeterminate = 'off';

for i = 1:numel(cell_line_names)
    %Loadbar
    loadbar.Message = strcat("Processing: ",cell_line_names(i));
    loadbar.Value = i/numel(cell_line_names);

    absolute_filter_bounds = variant_absolute_filter_bounds(cell_line_names(i));
    quantile_filter_bounds = variant_quantile_filter_bounds(cell_line_names(i));
    marker_polygon_filter = variants_marker_polygon_filter(cell_line_names(i));

    processed_data_set{i} = master_process_single_table( ...
        total_data_sets{i},... %import variables
        new2old_column_names, ... %which channels to rename
        marker_list, ... which channels are relevant markers
        absolute_filter_bounds, ... lower and upper absolute marker filters
        quantile_filter_bounds, ... lower and upper quantile marker filters
        marker_polygon_filter, ... %polygon filter
        Normalisingchannelname, marker_do_normalise, ... normalising channel name and which channels to normalise
        do_log_data, ...
        do_zero_adjust); %whether to log data
end

%revert to dictionary if necessary
if to_dictionary
    processed_data_set = dictionary(cell_line_names,processed_data_set');
end

%% Save data
%Loadbar
loadbar.Message = "Saving Data...";
loadbar.Indeterminate = 'on';

saving_processed_tables(processed_data_set,cell_line_names,outputdata_dir,Datafiletype,data_set_name)

%process_settings
%import variables
process_settings.cell_line_names = cell_line_names;
%saving directories and data filetype
process_settings.outputdata_dir = outputdata_dir;
process_settings.outputplot_dir = outputplot_dir;
process_settings.Datafiletype = Datafiletype;
process_settings.data_set_name = data_set_name;
%which channels to rename
process_settings.new2old_column_names = new2old_column_names;
%which channels are relevant markers
process_settings.marker_list = marker_list;
%lower and upper absolute marker filters
process_settings.variant_absolute_filter_bounds = variant_absolute_filter_bounds;
%lower and upper quantile marker filters
process_settings.variant_quantile_filter_bounds = variant_quantile_filter_bounds;
%marker polygon filter
process_settings.variants_marker_polygon_filter = variants_marker_polygon_filter;
%normalising channel name and which channels to normalise
process_settings.Normalisingchannelname = Normalisingchannelname;
process_settings.marker_do_normalise = marker_do_normalise;
%decide whether to log data
process_settings.do_log_data = do_log_data;

save(strcat(outputdata_dir,data_set_name,"\",'Settings.mat'),'process_settings')

pause(1)
close(loadbar)

if close_app_fig
    delete(appfig)
end

end

