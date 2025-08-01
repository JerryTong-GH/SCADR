classdef test1_import_data_sets < matlab.unittest.TestCase
    methods (Test)
        function testOutput(testCase)
            file_types_supported = [".txt"	".csv"	".xls"	".xlsb"	".xlsm"	".xlsx"	".dat"	".xltm"	".xltx"	".ods"];
            inputdata_dir = fullfile('..','Development', 'Input Data');

            datasets_dictionary_original = {};
            app = {};
            result = import_data_sets(file_types_supported,inputdata_dir, datasets_dictionary_original,'startup',app);
            
            all_keys = [ ...
                "4A_1", "4A_2", "C124S_1", "C124S_2", ...
                "D268E_1", "D268E_2", "Empty_1", "Empty_2", ...
                "G129E_1", "G129E_2", "P38H_1", "P38H_2", ...
                "Untransfected_1", "Untransfected_2", ...
                "WT_1", "WT_2", "Y138L_1", "Y138L_2" ...
            ];

            % Initialize flag
            missing_key = 0;
            
            % Loop to check for missing keys
            for k = 1:length(all_keys)
                if ~isKey(result("23Dec22_compensated_singlet"), all_keys(k))
                    missing_key = 1;
                    break;  % exit early if any key is missing
                end
            end

            expected = 0; % example
            testCase.verifyEqual(missing_key, expected);
        end
    end
end
