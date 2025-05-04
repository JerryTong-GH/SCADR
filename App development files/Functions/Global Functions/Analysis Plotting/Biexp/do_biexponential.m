function [biexp_output, tiles, fig, master_table] = do_biexponential(total_data_sets, selected_cell_lines, selected_markers, dimension, options)
%% Function arguments
arguments (Input)
    total_data_sets {mustBeA(total_data_sets, {'cell', 'dictionary'})}
    selected_cell_lines {mustBeA(selected_cell_lines, {'string', 'cell'})}
    selected_markers {mustBeA(selected_markers, {'string', 'char'})}
    dimension {mustBeTextScalar}  % '2' or '3'
end

arguments (Input)
    options.app
    options.panel {mustBeA(options.panel, {'matlab.ui.container.Panel'})}
    options.stop_button = struct('Value', 0, 'Enable', "off", 'Text', "");
    options.inspect_selection = struct('Value', 0);
    options.status_lamp = struct('Color', 'r');
    options.status_lamp_label = struct('Text', '');
    options.do_legend = 1;
end

%% Convert dimension
dimension = str2double(dimension);
if ~ismember(dimension, [2, 3])
    error('Biexponential plot dimension must be "2" or "3".');
end

fig = 0;
master_table = [];
if ~isfield(options, 'panel')
    fig = figure;
    options.panel = uipanel(fig);
end

if isfield(options, 'app')
    progbar = uiprogressdlg(options.app.UIFigure, "Indeterminate", "on", "Message", "Preparing data...");
else
    progbar = waitbar(0.5, "Preparing data...");
end

if numel(selected_cell_lines) < 1
    errordlg('No cell lines selected.', 'Selection Error');
    error('No cell lines selected.');
end

selected_cell_lines = string(selected_cell_lines);
selected_markers = string(selected_markers);

%% Filter datasets
if isa(total_data_sets, "containers.Map") || isa(total_data_sets, "dictionary")
    filtered_data_sets = dictionary;
    for i = 1:numel(selected_cell_lines)
        key = selected_cell_lines(i);
        if isKey(total_data_sets, key)
            filtered_data_sets(key) = total_data_sets(key);
        else
            errordlg("Missing key: " + key, "Invalid Selection");
            error("Missing key: " + key);
        end
    end
else
    filtered_data_sets = total_data_sets;
end

%% Load and prepare data
[master_table, variant_ID, variant_ID_num, num_cells] = ...
    dataset_selection_2_table(filtered_data_sets, selected_cell_lines, selected_markers);

clr = hsv(numel(selected_cell_lines));

data_matrix = master_table{:, selected_markers};

if width(data_matrix) < dimension
    if isvalid(progbar); close(progbar); end
    errordlg(sprintf('Only %d marker(s) selected for %dD plot.', width(data_matrix), dimension), ...
             'Dimension Error');
    error('Insufficient markers for %dD plot.', dimension);
end

%% Biexponential transform
waitbar(0.8, progbar, "Applying biexponential transform...");
biexp_output = apply_biexp_transform(data_matrix);

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
    points = biexp_output(idx, 1:dimension);
    color = clr(repelem(i, num_cells(i))', :);
    
    if dimension == 3
        sp = scatter3(ax, points(:,1), points(:,2), points(:,3), ...
            15, color, 'filled', 'MarkerFaceAlpha', 0.4);
        xlabel(ax, 'Dim 1'); ylabel(ax, 'Dim 2'); zlabel(ax, 'Dim 3');
    else
        sp = scatter(ax, points(:,1), points(:,2), ...
            15, color, 'filled', 'MarkerFaceAlpha', 0.4);
        xlabel(ax, 'Dim 1'); ylabel(ax, 'Dim 2');
    end

    start = sum(num_cells(1:i)) + 1;
    hold(ax, "on");
    tsp = [tsp, sp];
end

title(ax, sprintf('Biexponential View: %s | Markers: %s', ...
    strjoin(selected_cell_lines, ', '), strjoin(selected_markers, ', ')), ...
    'Interpreter', 'none');

if options.do_legend
    legend(ax, tsp, selected_cell_lines, 'Location', 'bestoutside');
end

hold(ax, "off");
drawnow;

if options.inspect_selection.Value
    selection_inspection(ax, biexp_output, variant_ID, master_table);
    options.inspect_selection.Value = 0;
end

options.status_lamp.Color = 'g';
options.status_lamp_label.Text = 'Ready';

end
