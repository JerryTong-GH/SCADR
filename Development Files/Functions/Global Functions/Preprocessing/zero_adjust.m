function [total_data_sets,zero_adjust_reference] = zero_adjust(total_data_sets,marker_list)
%ZERO_ADJUST Summary of this function goes here

%% Define arguments
arguments
    %import variables
    total_data_sets {mustBeA(total_data_sets,{'table','cell','dictionary'})}
    %which channels are relevant markers
    marker_list {mustBeA(marker_list,{'string','cell'})}
end

%% Function Starts
switch string(class(total_data_sets))
    case "dictionary"
        cell_line_names = total_data_sets.keys;
        total_data_sets = total_data_sets.values;

        zero_adjust_reference = 0;
        for i = 1:numel(total_data_sets)
            %find lowest value in table
            lowest_read = min(table2array(total_data_sets{i}(:,marker_list)),[],'all');
            zero_adjust_reference = min(zero_adjust_reference,lowest_read);
        end

        zero_adjust_reference = abs(zero_adjust_reference)*1.00000001;

        for i = 1:numel(total_data_sets)

            for j = 1:numel(marker_list)
                total_data_sets{i}.(marker_list(j)) = total_data_sets{i}.(marker_list(j))+zero_adjust_reference;
            end
        end
        total_data_sets = dictionary(cell_line_names,total_data_sets); 

    case "cell"
        zero_adjust_reference = 0;

        for i = 1:numel(total_data_sets)
            %find lowest value in table
            lowest_read = min(table2array(total_data_sets{i}(:,marker_list)),[],'all');
            zero_adjust_reference = min(zero_adjust_reference,lowest_read);
        end

        zero_adjust_reference = abs(zero_adjust_reference)*1.00000001;

        for i = 1:numel(total_data_sets)

            for j = 1:numel(marker_list)
                total_data_sets{i}.(marker_list(j)) = total_data_sets{i}.(marker_list(j))+zero_adjust_reference;
            end
        end

    case "table"
        zero_adjust_reference = 0;
        %find lowest value in table
        lowest_read = min(table2array(total_data_sets(:,marker_list)),[],'all');
        zero_adjust_reference = min(zero_adjust_reference,lowest_read);

        zero_adjust_reference = abs(zero_adjust_reference)*1.00000001;

        for j = 1:numel(marker_list)
            total_data_sets.(marker_list(j)) = total_data_sets.(marker_list(j))+zero_adjust_reference;
        end
end

end

