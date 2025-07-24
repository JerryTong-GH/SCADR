function [total_data_sets,zero_adjust_reference] = zero_adjust(total_data_sets,marker_list,do_zero_adjust,options)
%ZERO_ADJUST Summary of this function goes here

%% Define arguments
arguments
    %import variables
    total_data_sets {mustBeA(total_data_sets,{'table','cell','dictionary'})}
    %which channels are relevant markers
    marker_list {mustBeA(marker_list,{'string','cell'})}
    do_zero_adjust
end

arguments
    options.set_lowest_val
end

%% Function Starts
zero_adjust_reference = 0;
if ~do_zero_adjust
    return
end

switch string(class(total_data_sets))
    case "dictionary"
        cell_line_names = total_data_sets.keys;
        total_data_sets = total_data_sets.values;

        for i = 1:numel(total_data_sets)
            %find lowest value in table
            lowest_read = min(table2array(total_data_sets{i}(:,marker_list)),[],'all');
            if isempty(lowest_read)
                continue
            end
            zero_adjust_reference = min(zero_adjust_reference,lowest_read);
        end

        if isfield(options,'set_lowest_val')
            zero_adjust_reference = options.set_lowest_val-zero_adjust_reference;
        else
            zero_adjust_reference = abs(zero_adjust_reference)*1.00000001;
        end

        for i = 1:numel(total_data_sets)
            for j = 1:numel(marker_list)
                total_data_sets{i}.(marker_list(j)) = total_data_sets{i}.(marker_list(j))+zero_adjust_reference;
            end
        end
        total_data_sets = dictionary(cell_line_names,total_data_sets);

    case "cell"
        for i = 1:numel(total_data_sets)
            %find lowest value in table
            lowest_read = min(table2array(total_data_sets{i}(:,marker_list)),[],'all');
            if isempty(lowest_read)
                continue
            end
            zero_adjust_reference = min(zero_adjust_reference,lowest_read);
        end

        if isfield(options,'set_lowest_val')
            zero_adjust_reference = options.set_lowest_val-zero_adjust_reference;
        else
            zero_adjust_reference = abs(zero_adjust_reference)*1.00000001;
        end

        for i = 1:numel(total_data_sets)

            for j = 1:numel(marker_list)
                total_data_sets{i}.(marker_list(j)) = total_data_sets{i}.(marker_list(j))+zero_adjust_reference;
            end
        end

    case "table"
        %find lowest value in table
        lowest_read = min(table2array(total_data_sets(:,marker_list)),[],'all');
        if ~isempty(lowest_read)
            zero_adjust_reference = min(zero_adjust_reference,lowest_read);
        end

        if isfield(options,'set_lowest_val')
            zero_adjust_reference = options.set_lowest_val-zero_adjust_reference;
        else
            zero_adjust_reference = abs(zero_adjust_reference)*1.00000001;
        end

        for j = 1:numel(marker_list)
            total_data_sets.(marker_list(j)) = total_data_sets.(marker_list(j))+zero_adjust_reference;
        end

        %% Delete cells with negative values
%         idx = zeros(numel(total_data_sets.(marker_list(1))),1);
% 
%         for j = 1:numel(marker_list)
%             temp_idx = total_data_sets.(marker_list(j))<0;
%             idx = idx|temp_idx;
%         end
% 
%         total_data_sets(idx,:) = [];

end

end

