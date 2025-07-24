function [histogram_data,boundaries] = segment_binner(x,y,bins)
%SEGMENT_BINNER Summary of this function goes here
%   Detailed explanation goes here
%% Function arguments
% required inputs
arguments
    x
    y
    bins
end

%% Function starts
%% sort x and y in order
sort_data = sortrows([x,y]);
x = sort_data(:,1);
y = sort_data(:,2);
datapoints = numel(x);

%% determine boundaries
if datapoints<=bins
    bins = 1;
end

histogram_data = cell(1,bins);
boundaries = nan(bins+1,1);
boundaries(1) = min(x);
for i = 1:bins
    boundaries(i+1) = x(round(i/bins*datapoints));
    histogram_data{i} = y(x>boundaries(i)&x<=boundaries(i+1));
end

end

