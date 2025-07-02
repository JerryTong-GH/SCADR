classdef test1_import_data_sets < matlab.unittest.TestCase
    methods (Test)
        function testOutput(testCase)
            file_types_supported = [".txt"	".csv"	".xls"	".xlsb"	".xlsm"	".xlsx"	".dat"	".xltm"	".xltx"	".ods"],
            result = import_data_sets(file_types_supported,app.inputdata_dir,app.datasets_dictionary_original,"app",app);
            expected = 9; % example
            testCase.verifyEqual(result, expected);
        end
    end
end
