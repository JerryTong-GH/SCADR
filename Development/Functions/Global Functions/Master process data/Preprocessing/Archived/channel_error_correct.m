function [total_data_sets] = channel_error_correct(total_data_sets,error_correction)
%UNTITLED Summary of this function goes here
%apply linear adjustments to dataset
for i = 1:numel(total_data_sets)
    error_channels = keys(error_correction);
    for j = 1:numel(error_channels)
        total_data_sets{i}.(error_channels(j))= total_data_sets{i}.(error_channels(j))-error_correction(error_channels(j));
    end
end

end

