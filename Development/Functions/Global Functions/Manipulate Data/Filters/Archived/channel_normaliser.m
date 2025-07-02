function [total_data_sets] = channel_normaliser(total_data_sets,new_column_names,expression_channel_name,normalising_channel_name,do_normalise_expression,do_normalise_markers,marker_normalise_options)
%NORMALISE_CHANNELS: decide which channels to normalise against a
%normalising channel
%   Detailed explanation goes here

for i = 1:numel(total_data_sets)
    if do_normalise_expression
        total_data_sets{i}.(expression_channel_name) = total_data_sets{i}.(expression_channel_name)./total_data_sets{i}.(normalising_channel_name);
    end
    
    if do_normalise_markers
        for j = 1:numel(new_column_names)
            if (new_column_names(j)==expression_channel_name)||(new_column_names(j)==normalising_channel_name)
                continue
            end
            if marker_normalise_options(new_column_names(j))
                total_data_sets{i}.(new_column_names(j)) = total_data_sets{i}.(new_column_names(j))./total_data_sets{i}.(normalising_channel_name);
            end
        end
    end
end

end

