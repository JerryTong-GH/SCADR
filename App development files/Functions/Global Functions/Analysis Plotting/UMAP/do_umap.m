function [UMAP_output,umap_obj,tiles,fig,master_table] = do_umap(total_data_sets,selected_cell_lines,selected_markers,options,umap_options)
%TSNE_LIVE_UPDATE Summary of this function goes here
%   Detailed explanation goes here
%% Function arguments
% required inputs
arguments (Input)
    total_data_sets {mustBeA(total_data_sets,{'cell','dictionary'})}
    selected_cell_lines {mustBeA(selected_cell_lines,{'string','cell'})}
    selected_markers {mustBeA(selected_markers,{'string','char'})}
end

% optional specified
arguments (Input)
    % app plot
    options.app
    options.panel {mustBeA(options.panel,{'matlab.ui.container.Panel'})}
    % app buttons
    options.stop_button = struct('Value',0,'Enable',"off",'Text',"");
    options.pause_button = struct('Value',0,'Enable',"off",'Text',"");
    options.inspect_selection = struct('Value',0,'Enable',"off",'Text',"");
    options.status_lamp = struct('Color','r');
    options.status_lamp_label = struct('Text','hel');
    % Run settings
    options.umap_label_dir = ".\Temp"
    options.show_live_update = 1;
    options.do_supervised_umap = 1;
    % Plot settings
    options.show_training_divergence = 0;
    options.do_legend = 1;
end

% UMAP options
arguments (Input)
    umap_options.n_components = 2;
    % Parameters
    umap_options.min_dist = 0.3;
    umap_options.spread = 1;
    umap_options.n_neighbors = 15;
    % Distance calculation
    umap_options.metric {mustBeMember(umap_options.metric,{'euclidean','seuclidean','cityblock','chebychev','minkowski','mahalanobis','cosine','correlation','spearman','hamming','jaccard'})} = 'euclidean'
    umap_options.P = 2;
    % Nearest neighbour search
    umap_options.NSMethod {mustBeMember(umap_options.NSMethod,{'kdtree','exhaustive','nn_descent'})} = 'nn_descent'
    umap_options.IncludeTies = 0;
    umap_options.BucketSize = 50;

    % UMAP app
    umap_options.verbose = 'graphic';
    umap_options.see_training = 0;
    % Cluster Scan
    umap_options.cluster_method_2D {mustBeMember(umap_options.cluster_method_2D,{'dbscan','dbm'})} = 'dbm';
    umap_options.dbscan_distance {mustBeMember(umap_options.dbscan_distance,{'precomputed','euclidean','squaredeuclidean','seuclidean','cityblock','chebychev','minkowski','mahalanobis','cosine','correlation','spearman','hamming','jaccard'})} = 'euclidean';
    umap_options.epsilon = 0.6;
    umap_options.minpts = 5;
    % Plot options
    umap_options.contour_percent = 0; %0-25
end

%% Function begins
%% If not using an app
fig = 0;
master_table = [];
if ~isfield(options,'panel')
    fig = figure;
    options.panel = uipanel(fig);
end

if isfield(options,'app')
    progbar = uiprogressdlg(options.app.UIFigure,"Indeterminate","on","Message","Preparing data for UMAP...");
else
    progbar = waitbar(0.5,"Preparing data for UMAP...");
end

%% Initial checks
if numel(selected_cell_lines)<1
    UMAP_output = table([],string.empty,'VariableNames',["Position","Category"]);
    umap_obj = [];
    tiles = [];
    return
end

if umap_options.spread<umap_options.min_dist
    UMAP_output = table([],string.empty,'VariableNames',["Position","Category"]);
    umap_obj = [];
    tiles = [];
    msgbox("Min dist needs to be less than spread");
    return
end

%% Initialise variables
selected_cell_lines = string(selected_cell_lines);
selected_markers = string(selected_markers);
% UMAP options
umap_options.see_training = logical(umap_options.see_training);
umap_options.IncludeTies = logical(umap_options.IncludeTies);
if isequal(umap_options.metric,'euclidean')
    umap_options = rmfield(umap_options,'P');
end

options.pause_button.Enable = "on";
options.pause_button.Value = 0;
options.pause_button.Text = "Pause";

%% Selected data
switch class(total_data_sets)
    case 'cell'
        index_for_data = array_of_array(cell_line_names,selected_cell_lines);
        selected_data = total_data_sets(index_for_data);
    case 'dictionary'
        selected_data = total_data_sets(selected_cell_lines);
end

%% Concatenate all tables from selected variants
num_markers = numel(selected_markers);
num_cell_lines = numel(selected_cell_lines);

[master_table,variant_ID,variant_ID_num,num_cells] = dataset_selection_2_table(total_data_sets,selected_cell_lines,selected_markers);

clr = hsv(num_cell_lines);

%% Initiate UMAP

umap_options.progress_callback = @umap_live_update;

umap_options_args = namedargs2cell(umap_options);

if options.show_training_divergence
    tiles = tiledlayout(options.panel,2,1);
else
    tiles = tiledlayout(options.panel,1,1);
end
tiles.Padding = 'compact';

%% Initialise UMAP
%Create label file
label_file_dir = fullfile(options.umap_label_dir,'umap_label_file.properties');
fid = fopen(label_file_dir,'w+');
% label file
label_names = string.empty;
for i = 1:numel(selected_cell_lines)
    label_names(i) = strcat(string(i),"=",selected_cell_lines(i),"\n");
    fprintf(fid,label_names(i));
end
fclose(fid);

if options.do_supervised_umap
    [UMAP_output,umap_obj] = run_umap(master_table(:,[selected_markers;"variant_ID_num"]).Variables, ...
        'parameter_names',cellstr(selected_markers),'label_column','end', ...
        'label_file',char(label_file_dir), ...
        umap_options_args{:});
else
    [UMAP_output,umap_obj] = run_umap(master_table(:,selected_markers).Variables, ...
        'parameter_names',cellstr(selected_markers), ...
        'label_file',char(label_file_dir), ...
        umap_options_args{:});
end

% [UMAP_output,umap_obj] = run_umap(master_table(:,selected_markers).Variables, ...
%     'parameter_names',cellstr(selected_markers), ...
%     umap_options_args{:});

%% Finish UMAP
plot_the_umap(UMAP_output);

UMAP_output = table(UMAP_output,variant_ID','VariableNames',["Position","Category"]);

closing_cleanup;

    function status = umap_live_update(umap_status)
        status = true;

        if options.pause_button.Value
            pausing_check
        end

        if options.stop_button.Value
            options.stop_button.Enable = 0;
            status = false;
            return
        end

        %% Check if initialising
        if isequal(class(umap_status),'char')
            if isfield(options,'app')
                progbar.Message = umap_status;
            else
                waitbar(0.5,progbar,umap_status);
            end
            options.status_lamp.Color = 'r';
            options.status_lamp_label.Text = 'Running UMAP...';
            drawnow;
            return
        else
            close(progbar)
        end

        %% Give live update if requested
        if options.show_live_update
            plot_the_umap(umap_status.getEmbedding)
        end

    end

    function plot_the_umap(plotdata)
        temp_ax = nexttile(tiles,1);
        switch umap_options.n_components
            case 2
                gscatter(temp_ax,plotdata(:,1),plotdata(:,2),variant_ID',clr);
                if ~options.do_legend
                    legend(temp_ax,'hide');
                end
                drawnow;
            case 3
                tsp = [];
                start = 1;
                for i = 1:numel(selected_cell_lines)
                    idx = start:sum(num_cells(1:i));
                    sp = scatter3(temp_ax,plotdata(idx,1),plotdata(idx,2),plotdata(idx,3),15, ...
                        clr(repelem(i,num_cells(i))',:),'filled');
                    start = sum(num_cells(1:i))+1;
                    hold(temp_ax,"on");
                    tsp = [tsp,sp];
                end
                if options.do_legend
                    legend(temp_ax,tsp,selected_cell_lines);
                end
                drawnow;
                hold(temp_ax,"off");
        end

        if options.inspect_selection.Value
            selection_inspection(temp_ax,plotdata,variant_ID,master_table);
            options.inspect_selection.Value = 0;
        end
    end

    function closing_cleanup
        options.pause_button.Text = "";
        options.pause_button.Value = 0;
        options.pause_button.Enable = "off";

        options.stop_button.Value = 0;
        options.stop_button.Enable = 0;

        options.status_lamp.Color = 'g';
        options.status_lamp_label.Text = 'Ready';
    end

    function pausing_check
        options.pause_button.Enable = 'on';
        options.pause_button.Text = "Resume...";
        options.pause_button.Value = 1;

        options.status_lamp.Color = 'y';
        options.status_lamp_label.Text = 'UMAP Paused...';

        uiwait(options.app.UIFigure);
    end

end
