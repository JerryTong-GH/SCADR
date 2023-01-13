function [total_data_sets] = polygon_scatter_filter( ...
    total_data_sets, marker_list, ...
    marker_polygon_filter, ...
    cell_line_names)
%ABSOLUTE_CHANNEL_FILTER Summary of this function goes here
%   Detailed explanation goes here

%% Define arguments
arguments
    %import variables
    total_data_sets {mustBeA(total_data_sets,{'table','cell','dictionary'})}
    %which channels are relevant markers
    marker_list {mustBeA(marker_list,{'string','cell'})}
    %lower and upper absolute marker filters
    marker_polygon_filter {mustBeA(marker_polygon_filter,'dictionary')}
end

% Optional arguments
arguments
    cell_line_names {mustBeA(cell_line_names,{'string','cell'})} = ""
end

%% Function Starts
switch string(class(total_data_sets))

    case "dictionary"
        cell_line_names = total_data_sets.keys;
        total_data_sets = total_data_sets.values;
        for i = 1:numel(total_data_sets)
            filter_range = marker_polygon_filter(cell_line_names(i));

            j_range = filter_range.numEntries;

            if j_range>0
                marker_combs = keys(filter_range);

                for j = 1:j_range
                    xvar = marker_combs{j}(1);
                    yvar = marker_combs{j}(2);

                    polyshape = filter_range(marker_combs(j));
                    polyshape = polyshape{1};

                    xpoly = polyshape(:,1);
                    ypoly = polyshape(:,2);

                    index = inpolygon(total_data_sets{i}.(xvar),total_data_sets{i}.(yvar),xpoly,ypoly);

                    total_data_sets{i} = total_data_sets{i}(index,:);
                end
            end
        end
        total_data_sets = dictionary(cell_line_names,total_data_sets);

    case "cell"
        for i = 1:numel(total_data_sets)
            filter_range = marker_polygon_filter(cell_line_names(i));

            j_range = filter_range.numEntries;

            if j_range>0
                marker_combs = keys(filter_range);

                for j = 1:j_range
                    xvar = marker_combs{j}(1);
                    yvar = marker_combs{j}(2);

                    polyshape = filter_range(marker_combs(j));
                    polyshape = polyshape{1};

                    xpoly = polyshape(:,1);
                    ypoly = polyshape(:,2);

                    index = inpolygon(total_data_sets{i}.(xvar),total_data_sets{i}.(yvar),xpoly,ypoly);

                    total_data_sets{i} = total_data_sets{i}(index,:);
                end
            end
        end

    case "table"
        filter_range = marker_polygon_filter;

        j_range = filter_range.numEntries;

        if j_range>0
            marker_combs = keys(filter_range);

            for j = 1:j_range
                xvar = marker_combs{j}(1);
                yvar = marker_combs{j}(2);

                polyshape = filter_range(marker_combs(j));
                polyshape = polyshape{1};

                xpoly = polyshape(:,1);
                ypoly = polyshape(:,2);

                index = inpolygon(total_data_sets.(xvar),total_data_sets.(yvar),xpoly,ypoly);

                total_data_sets = total_data_sets(index,:);
            end
        end
end

end

