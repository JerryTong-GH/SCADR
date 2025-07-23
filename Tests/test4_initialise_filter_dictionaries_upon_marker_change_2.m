classdef test4_initialise_filter_dictionaries_upon_marker_change_2 < matlab.unittest.TestCase
    methods (Test)
        function testOutput(testCase)
            
            initialise_filter_dictionaries_upon_marker_change_2




            file_types_supported = [".txt"	".csv"	".xls"	".xlsb"	".xlsm"	".xlsx"	".dat"	".xltm"	".xltx"	".ods"];
            inputdata_dir = fullfile('..','Development', 'Input Data');
            outputdata_dir = fullfile('..','Development', 'Output Data')
            outputplot_dir = fullfile('..','Development', 'Output Plot')

            datasets_dictionary_original = {};
            app = {};
            datasets_original = import_data_sets(file_types_supported,inputdata_dir, datasets_dictionary_original,'startup',app);
            dataset_list = keys(datasets_original);
            available_markers = {'FSC-A', 'SSC-A'};


            [datasets_dictionary_processed,~] = master_process_library_of_packs( ...
                    datasets_original,dataset_list, ... %import variables
                    outputdata_dir,outputplot_dir,".csv",  ... %saving directories and data filetype
                    app.new2old_column_names, ... %which channels to rename
                    available_markers, ... which channels are relevant markers
                    app.dataset_dictionary_marker_absolute_filter_bounds, ... lower and upper absolute marker filters
                    app.dataset_dictionary_marker_quantile_filter_bounds, ... lower and upper quantile marker filters
                    app.dataset_dictionary_marker_polygon_filter, ... %marker polygon filter
                    normalising_channel, app.marker_do_normalise, ... normalising channel name and which channels to normalise
                    app.LogDataListListBox.ItemsData, ...
                    app.Zero_adjust_switch.Value, ..., ...
                    filter_order, ...
                    "app",app);

            NewExpected = {'FSC-A', 'SSC-A'};
            expected = isequal(OriginalcolumnnamesListBox,OriginalExpected) & isequal(NewcolumnnamesListBox,NewExpected); % example
            testCase.verifyEqual(true, expected);
        end
    end
end
