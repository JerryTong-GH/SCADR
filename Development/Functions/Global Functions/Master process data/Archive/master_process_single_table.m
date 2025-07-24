function [table] = master_process_single_table( ...
    table,... %import variables
    new2old_column_names, ... %which channels to rename
    marker_list, ... which channels are relevant markers
    absolute_filter_bounds, ... lower and upper absolute marker filters
    quantile_filter_bounds, ... lower and upper quantile marker filters
    marker_polygon_filter, ... %polygon filter
    Normalisingchannelname, marker_do_normalise, ... normalising channel name and which channels to normalise
    do_log_data, ... %whether to log data
    do_zero_adjust)%zero adjust

%MASTER_PROCESS_SINGLE_TABLE Summary of this function goes here
%   Detailed explanation goes here

%% Define arguments
arguments
    %import variables
    table {mustBeA(table,{'table'})}
    %which channels to rename
    new2old_column_names {mustBeA(new2old_column_names,'dictionary')}
    %which channels are relevant markers
    marker_list {mustBeA(marker_list,{'string','cell'})}
    %lower and upper absolute marker filters
    absolute_filter_bounds {mustBeA(absolute_filter_bounds,'dictionary')}
    %lower and upper quantile marker filters
    quantile_filter_bounds {mustBeA(quantile_filter_bounds,'dictionary')}
    %polygon filter
    marker_polygon_filter {mustBeA(marker_polygon_filter,'dictionary')}
    %normalising channel name and which channels to normalise
    Normalisingchannelname {mustBeA(Normalisingchannelname,{'string','char'})}
    marker_do_normalise {dictionary}
    %decide whether to log data
    do_log_data {double,logical}
    %decide whether to zero adjust
    do_zero_adjust
end

%% Function Starts
%% Preprocess data
%rename columns
table = channel_name_change(table,new2old_column_names);

%% Filter data
% channel filter
table = absolute_channel_filter(table,marker_list, absolute_filter_bounds);

% quantile filter
table = quantile_channel_filter_2(table,marker_list, ...
    quantile_filter_bounds);
% polygon filter
[table] = polygon_scatter_filter( ...
    table, marker_list, ...
    marker_polygon_filter);

%% Manipulate data for analysis
%shift all data relatively upwards
[table,~] = zero_adjust(table,marker_list,do_zero_adjust);

% Decide whether to normalise against another channel or not, and which
% channels to normalise.
[table] = channel_normaliser_2(table,marker_list,Normalisingchannelname,marker_do_normalise);

% log data
table = channel_logger(table,marker_list,do_log_data);

end

