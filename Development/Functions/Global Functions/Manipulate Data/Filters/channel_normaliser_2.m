function [total_data_sets] = channel_normaliser_2(total_data_sets,marker_list,normalising_channel_name,marker_normalise_options)
%NORMALISE_CHANNELS: decide which channels to normalise against a
%normalising channel
%   Detailed explanation goes here

%% Define arguments
arguments
    %import variables
    total_data_sets {mustBeA(total_data_sets,{'table','cell','dictionary'})}
    %which channels are relevant markers
    marker_list {mustBeA(marker_list,{'string','cell'})}
    %which channel to normalise against
    normalising_channel_name {mustBeA(normalising_channel_name,{'string','char'})}
    %which channels to normalise
    marker_normalise_options {mustBeA(marker_normalise_options,{'dictionary'})}
end

%% Function Starts
normalising_channel_name = string(normalising_channel_name);
marker_list = string(marker_list);

switch string(class(total_data_sets))

    case "dictionary"
        cell_line_names = total_data_sets.keys;
        total_data_sets = total_data_sets.values;
        for i = 1:numel(total_data_sets)
            for j = 1:numel(marker_list)
                %normalise all other channels first
                if marker_list(j) == normalising_channel_name
                    continue
                end

                if marker_normalise_options(marker_list(j))
                    total_data_sets{i}.(marker_list(j)) = total_data_sets{i}.(marker_list(j))./total_data_sets{i}.(normalising_channel_name);
                end
            end

            % normalise normalising channel at the end if toggled on

            if marker_normalise_options(normalising_channel_name)
                total_data_sets{i}.(normalising_channel_name) = total_data_sets{i}.(normalising_channel_name)./total_data_sets{i}.(normalising_channel_name);
            end

        end
        total_data_sets = dictionary(cell_line_names,total_data_sets);

    case "cell"
        for i = 1:numel(total_data_sets)
            for j = 1:numel(marker_list)
                %normalise all other channels first
                if marker_list(j) == normalising_channel_name
                    continue
                end

                if marker_normalise_options(marker_list(j))
                    total_data_sets{i}.(marker_list(j)) = total_data_sets{i}.(marker_list(j))./total_data_sets{i}.(normalising_channel_name);
                end
            end

            % normalise normalising channel at the end if toggled on

            if marker_normalise_options(normalising_channel_name)
                total_data_sets{i}.(normalising_channel_name) = total_data_sets{i}.(normalising_channel_name)./total_data_sets{i}.(normalising_channel_name);
            end

        end
        
    case "table"
        for j = 1:numel(marker_list)
            %normalise all other channels first
            if marker_list(j) == normalising_channel_name
                continue
            end

            if marker_normalise_options(marker_list(j))
                total_data_sets.(marker_list(j)) = total_data_sets.(marker_list(j))./total_data_sets.(normalising_channel_name);
            end
        end

        % normalise normalising channel at the end if toggled on

        if marker_normalise_options(normalising_channel_name)
            total_data_sets.(normalising_channel_name) = total_data_sets.(normalising_channel_name)./total_data_sets.(normalising_channel_name);
        end
end

end

