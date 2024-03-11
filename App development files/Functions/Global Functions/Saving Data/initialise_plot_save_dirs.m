function initialise_plot_save_dirs(outputdata_dir,outputplot_dir,cell_line_names,data_set_name)
%INITIALISE_PLOT_SAVE_DIRS Create folders to save generated plots in
%   Detailed explanation goes here

%Define arguments
arguments
    %import variables
    outputdata_dir {mustBeA(outputdata_dir,{'string','char'})}
    outputplot_dir {mustBeA(outputplot_dir,{'string','char'})}
    cell_line_names {mustBeA(cell_line_names,{'string','cell'})}
    data_set_name {mustBeA(data_set_name,{'string','char'})}
end

%% Function begins
%initialise
cell_line_names = string(cell_line_names);

%% Make data output in data set folder name
[~,~,~] = mkdir(fullfile(outputdata_dir,data_set_name));

% %% Make folder for correlation matrix
% mkdir(strcat(outputplot_dir,data_set_name,"\","Correlation Matrix"))
% 
% %% Make folder for expression vs marker plots for each variant
% mkdir(strcat(outputplot_dir,data_set_name,"\","Expression vs Marker Scatter"))
% 
% for i = 1:numel(cell_line_names)
%     mkdir(strcat(outputplot_dir,data_set_name,"\","Expression vs Marker Scatter\",cell_line_names(i)))
% end
% 
% %% Make folder for all combinations of marker plot, with a folder for each variant
% mkdir(strcat(outputplot_dir,data_set_name,"\","Marker Combinations 2D Scatter"))
% 
% for i = 1:numel(cell_line_names)
%     mkdir(strcat(outputplot_dir,data_set_name,"\","Marker Combinations 2D Scatter\",cell_line_names(i)))
% end
% 
% % if multiple data in the set
% if numel(cell_line_names)>1
%     mkdir(strcat(outputplot_dir,data_set_name,"\","Marker Combinations 2D Scatter\","Combined Variants"))
% end

end

