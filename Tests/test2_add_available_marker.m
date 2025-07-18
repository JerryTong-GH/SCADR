classdef test2_add_available_marker < matlab.unittest.TestCase
    methods (Test)
        function testOutput(testCase)

            available_markers = {'FSC-A', 'SSC-A'};

            NewcolumnnamesListBox = cell(0,0);
            marker_list = cell(0,1);

            OriginalcolumnnamesListBox = [];
            
            [OriginalcolumnnamesListBox, NewcolumnnamesListBox] = add_marker_from_original_data_column_2( ...
                    OriginalcolumnnamesListBox,NewcolumnnamesListBox,available_markers,marker_list, ...
                    "select_all",1);

            OriginalExpected = {'FSC-A', 'SSC-A'};

            NewExpected = {'FSC-A', 'SSC-A'};
            expected = isequal(OriginalcolumnnamesListBox,OriginalExpected) & isequal(NewcolumnnamesListBox,NewExpected); % example
            testCase.verifyEqual(true, expected);
        end
    end
end
