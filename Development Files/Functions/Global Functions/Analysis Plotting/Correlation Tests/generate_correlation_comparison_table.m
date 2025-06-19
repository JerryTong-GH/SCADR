function [corr_table] = generate_correlation_comparison_table(total_data_sets,selected_cell_lines, ...
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
    options.comparison_method {mustBeMember(options.comparison_method,{'Percentile Bootstrap','Fisher-z'})} = 'Percentile Bootstrap';    % adjust plot data
    options.correlation_method {mustBeMember(options.correlation_method,{'Pearson','Kendall','Spearman'})} = 'Kendall';    % adjust plot data
    % Bootstrap settings
    options.bootstrap_repeat_samples = 1000;
    options.bootstrap_sample_size = 100; %in percent of datapoints
    options.bootstrap_replace = 1;
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
n_cell_lines = numel(selected_cell_lines);
selected_markers = string(selected_markers);
n_markers = numel(selected_markers);

if isequal(options.comparison_method,'Fisher-z')
    options.correlation_method = 'Pearson';
end
comparison_method = options.comparison_method;
correlation_method = options.correlation_method;
bootstrap_replace = options.bootstrap_replace==1;

%% Generate correlation table for each cell line, each marker
cell_line_corrmat = dictionary(string.empty,cell.empty);
cell_line_cell_count = dictionary(string.empty,[]);

for i = 1:n_cell_lines
    sample_data = selected_data{i};
    corr_mat = cell(n_markers);

    for j = 1:n_markers
        yvar = sample_data.(selected_markers(j));
        cell_line_cell_count(selected_cell_lines(i)) = numel(yvar);

        for k = 1:numel(selected_markers)
            xvar = sample_data.(selected_markers(k));

            if k==j
                corr_mat{j,k} = 1;
            elseif k>j


                switch comparison_method
                    case 'Percentile Bootstrap'
                        %% Bootstrap comparison

                        number_of_samples = ceil(numel(yvar)*(options.bootstrap_sample_size/100));
                        rho = nan(options.bootstrap_repeat_samples,1);

                        % Parfor bootstrap sampling
                        parfor l = 1:options.bootstrap_repeat_samples
                            [sample_x,sample_y] = datasample(xvar,number_of_samples,'Replace',bootstrap_replace);
                            sample_y = yvar(sample_y);

                            switch correlation_method
                                case {'Pearson','Kendall','Spearman'}
                                    rho(l) = corr(sample_x,sample_y,"type",correlation_method);
                            end
                        end

                        corr_mat{j,k} = rho;

                    case 'Fisher-z'
                        %% Fisher z comparison
                        switch correlation_method
                            case {'Pearson','Kendall','Spearman'}
                                corr_mat{j,k} = corr(xvar,yvar,"type",correlation_method);
                        end
                end
            else
                corr_mat{j,k} = corr_mat{k,j};
            end

        end
    end

    corr_mat = {corr_mat};
    cell_line_corrmat(selected_cell_lines(i)) = corr_mat;
end



%% Do optional plot table of correlation vals
%     fig = uifigure("Units","normalized","Name",selected_cell_lines(i));
%     pnl = uipanel(fig,"Units","normalized","Position",[0,0,1,1]);
%     display_table = uitable(pnl,"Data",corr_mat,"ColumnName",selected_markers,"RowName",selected_markers, ...
%         "Units","normalized","Position",[0,0,1,1]);






%% Compare correlations between cell lines
for a = 1:n_cell_lines
    a_corr_mat_data = cell_line_corrmat(selected_cell_lines(a));
    a_corr_mat_data = a_corr_mat_data{1};
    a_n_cells = cell_line_cell_count(selected_cell_lines(a));

    for b = (a+1):n_cell_lines
        title = strjoin([selected_cell_lines(a),selected_cell_lines(b)]," x ");
        compare_mat = nan(n_markers);

        b_corr_mat_data = cell_line_corrmat(selected_cell_lines(b));
        b_corr_mat_data = b_corr_mat_data{1};
        b_n_cells = cell_line_cell_count(selected_cell_lines(b));

        for j = 1:numel(selected_markers)
            for k = 1:numel(selected_markers)
                if k==j
                    compare_mat(j,k) = nan;
                elseif k>j
                    switch comparison_method
                        case 'Percentile Bootstrap'
                            %% Bootstrap comparison
                            cor_dist_difference = a_corr_mat_data{j,k}-b_corr_mat_data{j,k};
                            pval = sum(cor_dist_difference<0)/numel(cor_dist_difference);
                            pval = min(pval,sum(cor_dist_difference>0)/numel(cor_dist_difference));

                            compare_mat(j,k) = pval;
                        case 'Fisher-z'
                            %% Fisher z comparison
                            ra = a_corr_mat_data{j,k};
                            rb = b_corr_mat_data{j,k};

                            z_vals = atanh([ra,rb]);
                            z_obs = (z_vals(1)-z_vals(2))/sqrt(1/(a_n_cells-3) + 1/(b_n_cells-3));

                            compare_mat(j,k) = 2*normcdf(-abs(z_obs));
                    end
                else
                    compare_mat(j,k) = compare_mat(k,j);
                end
            end
        end

        fig = figure("Units","normalized","Name",title);
        hm = heatmap(fig,selected_markers,selected_markers,compare_mat);
        hm.ColorLimits = [0,1];
        hm.Colormap = flip(hot);
        hm.MissingDataColor = "b";
    end
end

end

