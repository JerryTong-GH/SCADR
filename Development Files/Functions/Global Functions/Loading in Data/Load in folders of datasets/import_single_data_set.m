function [dataset_dictionary] = import_single_data_set(options, ...
    inputdata_dir,temp_dataset_name,folder_path, ...
    dataset_dictionary,file_types_supported, ...
    do_reference_rename,cell_line_rename_dictionary,channel_old_names,channel_new_names)
%IMPORT_SINGLE_DATA_SET Summary of this function goes here
%   Detailed explanation goes here
original_dataset_name = temp_dataset_name;
temp_dataset_path_original = fullfile(folder_path,original_dataset_name);


    if isfolder(temp_dataset_path_original)
        if isKey(dataset_dictionary,temp_dataset_name)
            % rename or overwrite dataset because the name already exists

            msg = strcat("""",temp_dataset_name,""" already exists. How would you like to proceed?");
            figtitle = 'Data set name already exists';

            if isfield(options,'app')
                choice_pick = uiconfirm(options.app.UIFigure,msg,figtitle, ...
                    'Options',["Rename","Overwrite","Skip"], ...
                    'DefaultOption',3,'CancelOption',3, ...
                    'Icon','warning');
            else
                choice_pick = 'Skip';
                fig = uifigure;
                fig.Position(3:4) = [350,220];
                choice_pick = uiconfirm(fig,msg,figtitle, ...
                    'Options',["Rename","Overwrite","Skip"], ...
                    'DefaultOption',3,'CancelOption',3, ...
                    'Icon','warning');
                close(fig)
            end

            % Handle response
            switch choice_pick
                case 'Rename'
                    if isfield(options,'app')
                        temp_dataset_name = same_data_set_name_pop_up(temp_dataset_name,dataset_dictionary,"position",options.app.UIFigure.Position);
                    else
                        temp_dataset_name = same_data_set_name_pop_up(temp_dataset_name,dataset_dictionary);
                    end

                    if isempty(temp_dataset_name)
                        return
                    end
                case 'Overwrite'
                case 'Skip'
                    return
            end
        end

        %% Create data set folder in input data directory
        temp_dataset_dir = fullfile(inputdata_dir,temp_dataset_name);
        [~,~,~] = mkdir(temp_dataset_dir);

        %% Get dictionary of variant name to variant table
        % Check file names of data set folder for matching acceptable file
        % types
        temp_dirfiles = dir(temp_dataset_path_original);
        temp_dirfiles(1:2) = [];

        temp_dataset = dictionary(string.empty,cell.empty);

        if numel(temp_dirfiles)<1
            return
        end

        temp_cell_line_name = strings(numel(temp_dirfiles),1);
        temp_ext = strings(numel(temp_dirfiles),1);

        %% For each file in data set
        for j = 1:numel(temp_dirfiles)
            temp_file_path = fullfile(temp_dataset_path_original,temp_dirfiles(j).name);
            [~,temp_cell_line_name(j),temp_ext(j)] = fileparts(temp_file_path);

            % Save file table to dataset dictionary
            if any(temp_ext(j)==file_types_supported)&&~temp_dirfiles(j).isdir
                %Rename dictionary entry in app
                if do_reference_rename
                    if isKey(cell_line_rename_dictionary,temp_cell_line_name(j))
                        temp_cell_line_name(j) = cell_line_rename_dictionary(temp_cell_line_name(j));
                    end
                end

                %Save table
                temp_table = readtable(temp_file_path,"VariableNamingRule","preserve");
                if do_reference_rename
                    for i = 1:numel(channel_old_names)
                        try
                            temp_table = renamevars(temp_table,channel_old_names(i),channel_new_names(i));
                        end
                    end
                end
                temp_dataset(temp_cell_line_name(j)) = {temp_table};

                %Write input data table
                writetable(temp_table,fullfile(temp_dataset_dir,strcat(temp_cell_line_name(j),temp_ext(j))));
            end
        end

        %% Save individual dataset to dataset dictionary
        dataset_dictionary(temp_dataset_name) = temp_dataset;
    end


end

