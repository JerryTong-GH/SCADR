function [total_data_sets] = channel_logger(total_data_sets,marker_list,do_log_data)
%CHANNEL_LOGGER Summary of this function goes here
%   Detailed explanation goes here

%% Define arguments
arguments
    %import variables
    total_data_sets {mustBeA(total_data_sets,{'table','cell','dictionary'})}
    %which channels are relevant markers
    marker_list {mustBeA(marker_list,{'string','cell'})}
    %decide whether to log data
    do_log_data {double,logical}
end

%% Function Starts
if do_log_data
    switch string(class(total_data_sets))
        case "dictionary"
            cell_line_names = total_data_sets.keys;
            total_data_sets = total_data_sets.values;
            for i = 1:numel(total_data_sets)
                total_data_sets{i}(:,marker_list) = array2table(log10(table2array(total_data_sets{i}(:,marker_list))));
            end
            total_data_sets = dictionary(cell_line_names,total_data_sets);
        case "cell"
            for i = 1:numel(total_data_sets)
                total_data_sets{i}(:,marker_list) = array2table(log10(table2array(total_data_sets{i}(:,marker_list))));
            end
        case "table"
            total_data_sets(:,marker_list) = array2table(log10(table2array(total_data_sets(:,marker_list))));
    end
end

end
