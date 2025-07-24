function [tsne_output,tsne_loss,tiles,fig] = collate_datasets_into_one_table(total_data_sets,selected_cell_lines,selected_markers,options)
%COLLATE_DATASETS_INTO_ONE_TABLE Summary of this function goes here
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
    options.cell_line_names
end

%% Function begins
if isfield(options,'cell_line_names')
    cell_line_names = options.cell_line_names;
end

%% Selected data
switch class(total_data_sets)
    case 'cell'
        index_for_data = array_of_array(cell_line_names,selected_cell_lines);
        selected_data = total_data_sets(index_for_data);
    case 'dictionary'
        selected_data = total_data_sets(selected_cell_lines);
end

%% Initialise variables
selected_cell_lines = string(selected_cell_lines);
selected_markers = string(selected_markers);

options.pause_button.Enable = "on";
options.pause_button.Value = 0;
options.pause_button.Text = "Pause";

%% Concatenate all tables from selected variants
num_markers = numel(selected_markers);
num_cell_lines = numel(selected_cell_lines);

[master_table,variant_ID,variant_ID_num] = dataset_selection_2_table(total_data_sets,selected_cell_lines,selected_markers);

clr = hsv(num_cell_lines);

%% Initiate TSNE
switch statset_options.UseParallel
    case 1
        statset_options.UseParallel = true;
    case 0
        statset_options.UseParallel = false;
end

tsne_statset = statset(statset_options,'OutputFcn',@tsne_live_update);

tsne_options_args = namedargs2cell(tsne_options);

if options.show_training_divergence
    tiles = tiledlayout(options.panel,2,1);
else
    tiles = tiledlayout(options.panel,1,1);
end
tiles.Padding = 'compact';

%% Initialise tSNE
[tsne_output,tsne_loss] = tsne(master_table(:,selected_markers).Variables, ...
    tsne_options_args{:},'Options',tsne_statset);

%% Finish tSNE
tsne_output = table(tsne_output,variant_ID','VariableNames',["Position","Category"]);

tsne_closing;

%% Sub functions
    function stop = tsne_live_update(optimValues,state)
        %% Startup loop
        persistent kllog

        if options.stop_button.Value
            stop = true;
            options.stop_button.Value = 0;
            return
        else
            stop = false; % do not stop by default
        end

        if options.pause_button.Value
            tsne_pausing;
        end

        switch state
            %% Initialise tSNE
            case 'init'
                kllog = [];

                options.inspect_poly.Enable = "on";
                options.inspect_poly.Value = 0;
                options.inspect_poly.Text = "Inspect Polygon";

                if isfield(options,'app')
                    progbar = uiprogressdlg(options.app.UIFigure,"Indeterminate","on","Message","Initialising tSNE...");
                else
                    waitbar(0.5,progbar,"Initialising tSNE...");
                end

                options.tsne_lamp.Color = 'r';
                options.tsne_lamp_label.Text = 'Running tSNE...';
                
                pause(0.8);
                close(progbar);

                %% Iterate tSNE
            case 'iter'
                if options.show_live_update
                    temp_ax = nexttile(tiles,1);
                    switch tsne_options.NumDimensions
                        case 2
                            gscatter(temp_ax,optimValues.Y(:,1),optimValues.Y(:,2),variant_ID',clr);
                            if ~options.do_legend
                                legend(temp_ax,'hide');
                            end
                            drawnow;
                        case 3
                            tsp = [];
                            start = 1;
                            for i = 1:numel(selected_cell_lines)
                                idx = start:sum(num_cells(1:i));
                                sp = scatter3(temp_ax,optimValues.Y(idx,1),optimValues.Y(idx,2),optimValues.Y(idx,3),15, ...
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

                    if options.show_training_divergence
                        temp_ax = nexttile(tiles,2);

                        kllog = [kllog; optimValues.fval,log(norm(optimValues.grad))];
                        assignin('base','history',kllog)
                        iters = tsne_options.NumPrint:tsne_options.NumPrint:optimValues.iteration;

                        if length(iters) > 1
                            plot(temp_ax,iters,kllog);
                            xlabel(temp_ax,'Iterations')
                            ylabel(temp_ax,'Loss and Gradient')
                            legend(temp_ax,'Divergence','log(norm(gradient))')
                            title(temp_ax,'Divergence and log(norm(gradient))')
                            drawnow;
                        end
                    end

                    if options.inspect_poly.Value
                        tSNE_Selection(nexttile(tiles,1),optimValues.Y,variant_ID);
                        options.inspect_poly.Value = 0;
                    end

                end


                %% tSNE Complete
            case 'done'
                temp_ax = nexttile(tiles,1);
                switch tsne_options.NumDimensions
                    case 2
                        gscatter(temp_ax,optimValues.Y(:,1),optimValues.Y(:,2),variant_ID',clr);
                        if ~options.do_legend
                            legend(temp_ax,'hide');
                        end
                        drawnow;
                    case 3
                        tsp = [];
                        start = 1;
                        for i = 1:numel(selected_cell_lines)
                            idx = start:sum(num_cells(1:i));
                            sp = scatter3(temp_ax,optimValues.Y(idx,1),optimValues.Y(idx,2),optimValues.Y(idx,3),15, ...
                                clr(repelem(i,num_cells(i))',:),'filled');
                            start = sum(num_cells(1:i))+1;
                            hold(temp_ax,"on");
                            tsp = [tsp,sp];
                        end
                        if options.do_legend
                            legend(temp_ax,tsp,selected_cell_lines)
                        end
                        drawnow
                        hold(temp_ax,"off")
                end
        end
    end

    function tsne_closing

        options.pause_button.Text = "";
        options.pause_button.Value = 0;
        options.pause_button.Enable = "off";

        options.tsne_lamp.Color = 'g';
        options.tsne_lamp_label.Text = 'Ready';

    end

    function tsne_pausing
        options.pause_button.Enable = 'on';
        options.pause_button.Text = "Resume...";
        options.pause_button.Value = 1;

        options.tsne_lamp.Color = 'y';
        options.tsne_lamp_label.Text = 'tSNE Paused...';

        uiwait(options.app.UIFigure);
%         waitfor(options.pause_button,'Value',0);
    end

end
