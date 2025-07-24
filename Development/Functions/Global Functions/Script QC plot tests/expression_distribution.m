function [] = expression_distribution(total_data_sets,cell_line_names,expression_channel_name,binwidth,upperlim,lowerlim,name)
%EXPRESSION_DISTRIBUTION Summary of this function goes here
%   Detailed explanation goes here

%% plot hish %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
longest_read = nan;
for i = 1:numel(total_data_sets)
    longest_read = max(longest_read,numel(total_data_sets{i}.(expression_channel_name)));
end

haspread = nan(longest_read,numel(total_data_sets));

for i = 1:numel(total_data_sets)
    haspread(1:numel(total_data_sets{i}.(expression_channel_name)),i) = total_data_sets{i}.(expression_channel_name);
end

figure('Name',name)
hold on
for i = 1:numel(total_data_sets)
    histogram(haspread(:,i),'binwidth', binwidth,'facealpha',.5,'edgecolor','none')
end

legend(cell_line_names)
legend boxoff
xlim([prctile(haspread,lowerlim,"all"),prctile(haspread,upperlim,"all")])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

