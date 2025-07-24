function [available_markers] = consistency_check_channel_names(dataset_dictionaries,options)
%CONSISTENCY_CHECK_CHANNEL_NAMES Summary of this function goes here
%   Detailed explanation goes here


arguments
    dataset_dictionaries
end

arguments
    options.fig
end

%% Function starts
if ~isfield(options,'fig')
    options.fig = uifigure("Name","Warning box");
end


available_markers = string.empty;

if dataset_dictionaries.numEntries<1
    return
end


%% Compare within each dataset pack
dataset_pack_names = cell(dataset_dictionaries.numEntries,1);
dataset_list = dataset_dictionaries.keys;


for i = 1:dataset_dictionaries.numEntries

    dataset_pack = dataset_dictionaries(dataset_list(i));

    if dataset_pack.numEntries<1
        continue
    else
        cell_line_names = dataset_pack.keys;
        pack_data = dataset_pack(cell_line_names(1));
        pack_names = pack_data{1}.Properties.VariableNames;
        do_pack_inconsistency_warning = 0;
    end

    for j = 2:dataset_pack.numEntries
        pack_data = dataset_pack(cell_line_names(j));
        temp_pack_name = pack_data{1}.Properties.VariableNames;

        if ~(numel(pack_names)==numel(temp_pack_name))
            do_pack_inconsistency_warning = 1;
        end

        pack_names = intersect(pack_names,temp_pack_name);
    end

    if do_pack_inconsistency_warning
        message = strcat(dataset_list(i)," has some inconsistent channel names across each data file");
        title = "Channel name inconsistency";
        uialert(options.fig,message,title,...
            'Icon','warning');
    end

    if numel(pack_names)<1
        message = strcat(dataset_list(i)," has no consistent channel names across each data file");
        title = "No channel names found";
        uialert(options.fig,message,title,...
            'Icon','warning');
    end

    dataset_pack_names{i} = pack_names;
end


%% Compare between dataset packs
available_markers = dataset_pack_names{1};
num_available_markers = numel(available_markers);

for i = 2:numel(dataset_pack_names)

    if ~(numel(dataset_pack_names{i})==num_available_markers)
        message = "There are inconsistent channel names between dataset packs";
        title = "Channel name inconsistency";
        uialert(options.fig,message,title,...
            'Icon','warning');
    end

    available_markers = intersect(available_markers,dataset_pack_names{i});
end

if numel(available_markers)<1
    message = "There are no consistent channel names between dataset packs";
    title = "No channel names found";
    uialert(options.fig,message,title,...
        'Icon','warning');
end

end



