function [PCA_output,coeff,tiles,fig,master_table] = do_pca(total_data_sets,selected_cell_lines,selected_markers,options)
%% Function arguments
arguments (Input)
    total_data_sets {mustBeA(total_data_sets,{'cell','dictionary'})}
    selected_cell_lines {mustBeA(selected_cell_lines,{'string','cell'})}
    selected_markers {mustBeA(selected_markers,{'string','char'})}
end

arguments (Input)
    % app plot
    options.app
    options.panel {mustBeA(options.panel,{'matlab.ui.container.Panel'})}
    % app buttons
    options.stop_button = struct('Value',0,'Enable',"off",'Text',"");
    % Plot settings
    options.do_legend = 1;
end

%% Initialization
fig = 0;
master_table = [];
if ~isfield(options,'panel')
    fig = figure;
    options.panel = uipanel(fig);
end

if isfield(options,'app')
    progbar = uiprogressdlg(options.app.UIFigure,"Indeterminate","on","Message","Preparing data for PCA...");
else
    progbar = waitbar(0.5,"Preparing data for PCA...");
end

if numel(selected_cell_lines) < 1
    PCA_output = table([],string.empty,'VariableNames',["Position","Category"]);
    coeff = [];
    tiles = [];
    return
end

selected_cell_lines = string(selected_cell_lines);
selected_markers = string(selected_markers);

%% Load and concatenate data
[master_table,variant_ID,variant_ID_num,num_cells] = dataset_selection_2_table(total_data_sets,selected_cell_lines,selected_markers);

clr = hsv(numel(selected_cell_lines));

%% PCA
waitbar(0.8,progbar,"Running PCA...");

[coeff,score,~,~,explained] = pca(master_table{:,selected_markers});
PCA_output = score(:,1:3);

%% Plot
if isvalid(progbar)
    close(progbar);
end

tiles = tiledlayout(options.panel,1,1);
tiles.Padding = 'compact';

ax = nexttile(tiles,1);
tsp = [];
start = 1;
for i = 1:numel(selected_cell_lines)
    idx = start:sum(num_cells(1:i));
    sp = scatter3(ax,PCA_output(idx,1),PCA_output(idx,2),PCA_output(idx,3),15, ...
        clr(repelem(i,num_cells(i))',:),'filled');
    start = sum(num_cells(1:i))+1;
    hold(ax,"on");
    tsp = [tsp,sp];
end

if options.do_legend
    legend(ax,tsp,selected_cell_lines);
end

hold(ax,"off");
drawnow;

if options.inspect_selection.Value
    selection_inspection(ax,PCA_output,variant_ID,master_table);
    options.inspect_selection.Value = 0;
end

options.status_lamp.Color = 'g';
options.status_lamp_label.Text = 'Ready';

end
