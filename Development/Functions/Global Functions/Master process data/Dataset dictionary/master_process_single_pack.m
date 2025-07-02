function [pack] = master_process_single_pack( ...
    pack,... %import variables
    new2old_column_names, ... %which channels to rename
    marker_list, ... which channels are relevant markers
    absolute_filter_bounds_pack, ... lower and upper absolute marker filters
    quantile_filter_bounds_pack, ... lower and upper quantile marker filters
    marker_polygon_filter_pack, ... %polygon filter
    Normalisingchannelname, marker_do_normalise, ... normalising channel name and which channels to normalise
    do_log_data, ... %whether to log data
    do_zero_adjust, ... %zero adjust
    filter_order) %filter order

%MASTER_PROCESS_SINGLE_TABLE Summary of this function goes here
%   Detailed explanation goes here

%% Define arguments
arguments
    %import variables
    pack {mustBeA(pack,{'dictionary'})}
    %which channels to rename
    new2old_column_names {mustBeA(new2old_column_names,'dictionary')}
    %which channels are relevant markers
    marker_list {mustBeA(marker_list,{'string','cell'})}
    %lower and upper absolute marker filters
    absolute_filter_bounds_pack {mustBeA(absolute_filter_bounds_pack,'dictionary')}
    %lower and upper quantile marker filters
    quantile_filter_bounds_pack {mustBeA(quantile_filter_bounds_pack,'dictionary')}
    %polygon filter
    marker_polygon_filter_pack {mustBeA(marker_polygon_filter_pack,'dictionary')}
    %normalising channel name and which channels to normalise
    Normalisingchannelname {mustBeA(Normalisingchannelname,{'string','char'})}
    marker_do_normalise {dictionary}
    %decide whether to log data
    do_log_data {double,logical}
    %decide whether to zero adjust
    do_zero_adjust
    %filter order
    filter_order {string}
end

%% Function Starts
%% Preprocess data
%rename columns
pack = channel_name_change(pack,new2old_column_names);

%% Filter data
for i = 1:3
    switch filter_order(i)
        case 'Absolute'
            % channel filter
            pack = absolute_channel_filter(pack,marker_list, absolute_filter_bounds_pack);
        case 'Quantile'
            % quantile filter
            pack = quantile_channel_filter_2(pack,marker_list, ...
                quantile_filter_bounds_pack);
        case 'Scatter'
            % polygon filter
            [pack] = polygon_scatter_filter( ...
                pack, marker_list, ...
                marker_polygon_filter_pack);
    end
end

%% Manipulate data for analysis
%shift all data relatively upwards
[pack,~] = zero_adjust(pack,marker_list,do_zero_adjust,"set_lowest_val",1);

% Decide whether to normalise against another channel or not, and which
% channels to normalise.
[pack] = channel_normaliser_2(pack,marker_list,Normalisingchannelname,marker_do_normalise);

% log data
pack = channel_logger(pack,marker_list,do_log_data);

end

