function [fig_table,base_table,normal_style,non_normal_style,normal_ones,non_normal] = correlation_normality_test_table(total_data_sets, ...
    selected_cell_lines,selected_markers,options)
%2D_SCATTER_PLOT Summary of this function goes here
%   Detailed explanation goes here
%   'axis'    -  target axis to plot

%% Function arguments
% required inputs
arguments (Input)
    total_data_sets {mustBeA(total_data_sets,{'cell','dictionary'})}
    selected_cell_lines {mustBeA(selected_cell_lines,{'string','cell'})}
    selected_markers {mustBeA(selected_markers,{'string','char','cell'})}
end

% optional specified
arguments (Input)
    % app plot
    options.app
    options.normality_test_table {mustBeA(options.normality_test_table,{'matlab.ui.control.Table'})}
    options.fig_name {mustBeA(options.fig_name,{'string','char'})} = "";
    % normality test
    options.normality_alpha = 5;
end

arguments (Output)
    fig_table
    base_table
    normal_style
    non_normal_style
    normal_ones
    non_normal
end

%% Function begins
%% If not using an app
fig_table = 0;
if ~isfield(options,'normality_test_table')
    no_app = 1;
    fig_table = figure("Name",options.fig_name);
    options.normality_test_table = uitable(fig_table,'Units','normalized','Position',[0,0,1,1]);
end

%% Data conversions
selected_cell_lines = string(selected_cell_lines);
selected_markers = string(selected_markers);

options.normality_alpha = options.normality_alpha/100;

%% Initial checks
if numel(selected_cell_lines)<1||numel(selected_markers)<1
    return
end

%% Selected data
switch class(total_data_sets)
    case 'dictionary'
        selected_data = total_data_sets(selected_cell_lines);
end

%% Initialise table
n_tests = 7;

base_table = table('Size',[0,2+n_tests],'VariableTypes',repelem({'string'},2+n_tests), ...
    'VariableNames',["Cell Line","Marker","Kolmogorov-Smirnov","Lillefors","Chi-square","Anderson-Darling","Jarque-Bera","Shapiro-Wilk","D'Agostino-Pearson"]);

%% Iterate

total_normality_results_val = zeros(0,n_tests);

for i = 1:numel(selected_cell_lines)
    cell_line_name = selected_cell_lines(i);
    cell_line_data = selected_data{i};
    for j = 1:numel(selected_markers)
        marker_name = selected_markers(j);
        marker_data = cell_line_data.(marker_name);
        %% Do tests
        % Kolmogorov-Smirnov
        [ks_val,ks_p] = kstest(marker_data,"Alpha",options.normality_alpha);
        % Lillefors
        [lf_val,lf_p] = lillietest(marker_data,"Alpha",options.normality_alpha);
        % Chi-square
        [chi_val,chi_p] = chi2gof(marker_data,"Alpha",options.normality_alpha);
        % Anderson-Darling
        [ad_val,ad_p] = adtest(marker_data,"Alpha",options.normality_alpha);
        % Jarque-Bera
        [jb_val,jb_p] = jbtest(marker_data,options.normality_alpha);
        % Shapiro-Wilk
        [sw_val,sw_p] = swtest(marker_data,options.normality_alpha);
        % D'Agostino-Pearson
        [dp_val,dp_p] = DagosPtest(marker_data,options.normality_alpha);
       
        normality_results_val = [ks_val,lf_val,chi_val,ad_val,jb_val,sw_val,dp_val];
        normality_p = [ks_p,lf_p,chi_p,ad_p,jb_p,sw_p,dp_p];

        %% Create string array
        total_normality_results_val(end+1,:) = normality_results_val;

        normality_results = string(normality_results_val);
        normality_results(normality_results=="1") = "Not normal, P: ";
        normality_results(normality_results=="0") = "Normal, P: ";

        normality_p = string(normality_p);
        normality_p(ismissing(normality_p)) = "NA";

        test_entries = strcat(normality_results,normality_p);

        table_row_entry = [cell_line_name,marker_name,test_entries];

        base_table(end+1,:) = cellstr(table_row_entry);
    end
end

options.normality_test_table.Data = base_table;

non_normal = [zeros(numel(selected_cell_lines)*numel(selected_markers),2),total_normality_results_val];
normal_ones = [zeros(numel(selected_cell_lines)*numel(selected_markers),2),~total_normality_results_val];

[non_normal_rows,non_normal_cols] = find(non_normal);
non_normal = [non_normal_rows,non_normal_cols];

[normal_ones_rows,normal_ones_cols] = find(normal_ones);
normal_ones = [normal_ones_rows,normal_ones_cols];

normal_style = uistyle('Icon','success','IconAlignment','right');
non_normal_style = uistyle('Icon','warning','IconAlignment','right');

addStyle(options.normality_test_table,normal_style,'cell',normal_ones);
addStyle(options.normality_test_table,non_normal_style,'cell',non_normal);

end
