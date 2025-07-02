function [corr_table] = generate_correlation_table(total_data_sets,selected_cell_lines, ...
    selected_markers,options)
%CORRELATION_TABLE Summary of this function goes here
%   Detailed explanation goes here
arguments
    total_data_sets {mustBeA(total_data_sets,{'cell','dictionary'})}
    selected_cell_lines {mustBeA(selected_cell_lines,{'string','cell'})}
    selected_markers {mustBeA(selected_markers,{'string','char','cell'})}
end

% optional
arguments
    % app plot
    options.app
    % Correlation settings
    options.correlation_method {mustBeMember(options.correlation_method,{'Pearson','Kendall','Spearman'})} = 'Kendall';    % adjust plot data
end

%% Function starts
corr_table = 0;

%% If not using an app

%% Initial checks
if numel(selected_cell_lines)<1||numel(selected_markers)<1
    return
end

%% Selected data
switch class(total_data_sets)
    case 'dictionary'
        selected_data = total_data_sets(selected_cell_lines);
end

%% Data conversions
selected_cell_lines = string(selected_cell_lines);
selected_markers = string(selected_markers);

correlation_method = options.correlation_method;

%% Generate table

for i = 1:numel(selected_cell_lines)
    sample_data = selected_data{i};
    corr_mat = zeros(numel(selected_markers));
    p_mat = zeros(numel(selected_markers));
    for j = 1:numel(selected_markers)
        sample_y = sample_data.(selected_markers(j));
        for k = 1:numel(selected_markers)
            sample_x = sample_data.(selected_markers(k));

            if k==j
                corr_mat(j,k) = 1;
                p_mat(j,k) = 1;
            elseif k>j

                switch correlation_method
                    case {'Pearson','Kendall','Spearman'}
                        [corr_mat(j,k),p_mat(j,k)] = corr(sample_x,sample_y,"type",correlation_method);
                end
            else
                corr_mat(j,k) = corr_mat(k,j);
                p_mat(j,k) = p_mat(k,j);
            end
        end

    end

    %% Save correlation
    name = strcat(selected_cell_lines(i),": Correlation Values");

    fig = uifigure("Units","normalized","Name",name);
    pnl = uipanel(fig,"Units","normalized","Position",[0,0,1,1]);
    display_table = uitable(pnl,"Data",corr_mat,"ColumnName",selected_markers,"RowName",selected_markers, ...
        "Units","normalized","Position",[0,0,1,1]);

    fig = figure("Units","normalized","Name",name);
    hm = heatmap(fig,selected_markers,selected_markers,corr_mat);
    hm.ColorLimits = [-1,1];
    hm.Colormap = [flip(hot);hot];

    %% Save p value
    name = strcat(selected_cell_lines(i),": P Values");

    fig = uifigure("Units","normalized","Name",name);
    pnl = uipanel(fig,"Units","normalized","Position",[0,0,1,1]);
    display_table = uitable(pnl,"Data",p_mat,"ColumnName",selected_markers,"RowName",selected_markers, ...
        "Units","normalized","Position",[0,0,1,1]);

    fig = figure("Units","normalized","Name",name);
    hm = heatmap(fig,selected_markers,selected_markers,p_mat);
    hm.ColorLimits = [0,1];
    hm.Colormap = [flip(hot)];
end

end

