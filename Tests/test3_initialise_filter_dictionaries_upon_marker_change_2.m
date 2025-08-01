classdef test3_initialise_filter_dictionaries_upon_marker_change_2 < matlab.unittest.TestCase
    methods (Test)
        function testOutput(testCase)

            file_types_supported = [".txt"	".csv"	".xls"	".xlsb"	".xlsm"	".xlsx"	".dat"	".xltm"	".xltx"	".ods"];
            inputdata_dir = fullfile('..','Development', 'Input Data');

            datasets_dictionary_original = {};
            app = {};
            result = import_data_sets(file_types_supported,inputdata_dir, datasets_dictionary_original,'startup',app);

            marker_list = cell(0,1);
            new2old_column_names = dictionary({}, {});
            datasets_dictionary_original = result;
            dataset_dictionary_marker_absolute_limits = configureDictionary("string","dictionary");
            dataset_dictionary_marker_absolute_filter_bounds = configureDictionary("string","dictionary");
            dataset_dictionary_marker_quantile_filter_bounds = configureDictionary("string","dictionary");
            dataset_dictionary_marker_polygon_filter = configureDictionary("string","dictionary");
            [dataset_dictionary_marker_absolute_limits,...
                dataset_dictionary_marker_absolute_filter_bounds, ...
                dataset_dictionary_marker_quantile_filter_bounds, ...
                dataset_dictionary_marker_polygon_filter] = ...
                initialise_filter_dictionaries_upon_marker_change_2( ...
                marker_list, new2old_column_names, ...
                datasets_dictionary_original, ...
                dataset_dictionary_marker_absolute_limits,...
                dataset_dictionary_marker_absolute_filter_bounds, ...
                dataset_dictionary_marker_quantile_filter_bounds, ...
                dataset_dictionary_marker_polygon_filter);

            all_keys = ["23Dec22_compensated_singlet"];

            % Initialize flag
            missing_key = 0;
            
            % Loop to check for missing keys
            for k = 1:length(all_keys)
                if ~isKey(dataset_dictionary_marker_absolute_filter_bounds, all_keys(k))
                    missing_key = 1;
                    break;  % exit early if any key is missing
                end
            end

            for k = 1:length(all_keys)
                if ~isKey(dataset_dictionary_marker_absolute_limits, all_keys(k))
                    missing_key = 1;
                    break;  % exit early if any key is missing
                end
            end

            for k = 1:length(all_keys)
                if ~isKey(dataset_dictionary_marker_quantile_filter_bounds, all_keys(k))
                    missing_key = 1;
                    break;  % exit early if any key is missing
                end
            end
            for k = 1:length(all_keys)
                if ~isKey(dataset_dictionary_marker_polygon_filter, all_keys(k))
                    missing_key = 1;
                    break;  % exit early if any key is missing
                end
            end

            expected = 0; % example
            testCase.verifyEqual(missing_key, expected);


        end
    end
end
