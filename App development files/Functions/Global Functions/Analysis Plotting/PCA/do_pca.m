function [PCA_output, coeff, tiles, fig, master_table] = do_pca(total_data_sets, selected_cell_lines, selected_markers, options)
%% Function arguments
arguments (Input)
    total_data_sets {mustBeA(total_data_sets, {'cell', 'dictionary'})}
    selected_cell_lines {mustBeA(selected_cell_lines, {'string', 'cell'})}
    selected_markers {mustBeA(selected_markers, {'string', 'char'})}
end

arguments (Input)
    % App panel
    options.app
    options.panel {mustBeA(options.panel, {'matlab.ui.container.Panel'})}
    % Buttons
    options.stop_button = struct('Value', 0, 'Enable', "off", 'Text', "");
    options.inspect_selection = struct('Value', 0);
    options.status_lamp = struct('Color', 'r');
    options.status_lamp_label = struct('Text', '');
    % Plot settings
    options.do_legend = 1;
end

%% Initialization
fig = 0;
master_table = [];
if ~isfield(options, 'panel')
    fig = figure;
    options.panel = uipanel(fig);
end

if isfield(options, 'app')
    progbar = uiprogressdlg(options.app.UIFigure, "Indeterminate", "on", "Message", "Preparing data for PCA...");
else
    progbar = waitbar(0.5, "Preparing data for PCA...");
end

if numel(selected_cell_lines) < 1
    errordlg('No cell lines selected. Please select at least one cell line to proceed.', 'Selection Error');
    error('PCA aborted due to empty cell line selection.');
end

selected_cell_lines = string(selected_cell_lines);
selected_markers = string(selected_markers);

%% Filter dictionary if needed
if isa(total_data_sets, "containers.Map") || isa(total_data_sets, "dictionary")
    filtered_data_sets = dictionary;
    for i = 1:numel(selected_cell_lines)
        key = selected_cell_lines(i);
        if isKey(total_data_sets, key)
            filtered_data_sets(key) = total_data_sets(key);
        else
            errordlg("Selected cell line '" + key + "' not found in the data set.", "Invalid Selection");
            error("Missing key: " + key);
        end
    end
else
    filtered_data_sets = total_data_sets;
end

%% Load and concatenate data
[master_table, variant_ID, variant_ID_num, num_cells] = ...
    dataset_selection_2_table(filtered_data_sets, selected_cell_lines, selected_markers);

clr = hsv(numel(selected_cell_lines));

%% PCA
waitbar(0.8, progbar, "Running PCA...");
data_matrix = master_table{:, selected_markers};  % This should be 5296 × 2
[coeff, score] = pca(data_matrix,'NumComponents', 2);  

PCA_output = score(:, 1:2);

%% Plot
if isvalid(progbar)
    close(progbar);
end

tiles = tiledlayout(options.panel, 1, 1);
tiles.Padding = 'compact';

ax = nexttile(tiles, 1);
tsp = [];
start = 1;
for i = 1:numel(selected_cell_lines)
    idx = start:sum(num_cells(1:i));
    sp = scatter(ax, PCA_output(idx, 1), PCA_output(idx, 2), 15, ...
        clr(repelem(i, num_cells(i))', :), 'filled', 'MarkerFaceAlpha', 0.4);
    start = sum(num_cells(1:i)) + 1;
    hold(ax, "on");
    tsp = [tsp, sp];
end

title_str = sprintf('PCA of Cell Lines: %s | Markers: %s', ...
    strjoin(selected_cell_lines, ', '), strjoin(selected_markers, ', '));
title(ax, title_str, 'Interpreter', 'none');

if options.do_legend
    legend(ax, tsp, selected_cell_lines, 'Location', 'bestoutside');
end

hold(ax, "off");
drawnow;

if options.inspect_selection.Value
    selection_inspection(ax, PCA_output, variant_ID, master_table);
    options.inspect_selection.Value = 0;
end

options.status_lamp.Color = 'g';
options.status_lamp_label.Text = 'Ready';

end

