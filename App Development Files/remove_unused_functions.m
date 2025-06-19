function remove_unused_functions(mainFilePath, folderPath)
% REMOVE_UNUSED_FUNCTIONS Delete unused .m files in a folder
%
%   remove_unused_functions('MyApp.mlapp', 'C:\MyProject\Functions')
%
%   Inputs:
%       - mainFilePath: path to the .mlapp or .m main file
%       - folderPath: folder containing .m functions to check
%
%   This function compares all .m files in the folder to those used
%   by the main file, and deletes the unused ones after confirmation.

    % Validate input
    if ~isfile(mainFilePath)
        error('Main file not found: %s', mainFilePath);
    end
    if ~isfolder(folderPath)
        error('Folder not found: %s', folderPath);
    end

    % Find all .m files in the folder
    allFilesStruct = dir(fullfile(folderPath, '**', '*.m'));
    allFilePaths = fullfile({allFilesStruct.folder}, {allFilesStruct.name});

    % Find required files used by the main file
    fprintf('Analyzing dependencies for: %s\n', mainFilePath);
    usedFiles = matlab.codetools.requiredFilesAndProducts(mainFilePath);
    
    % Convert to absolute paths (normalize)
    usedFiles = cellfun(@(f) char(java.io.File(f).getCanonicalPath()), usedFiles, 'UniformOutput', false);
    allFilePaths = cellfun(@(f) char(java.io.File(f).getCanonicalPath()), allFilePaths, 'UniformOutput', false);

    % Identify unused files
    unusedFiles = setdiff(allFilePaths, usedFiles);

    if isempty(unusedFiles)
        fprintf('No unused functions detected in "%s".\n', folderPath);
        return;
    end

    % List unused files
    fprintf('Found %d unused .m file(s):\n', numel(unusedFiles));
    for i = 1:numel(unusedFiles)
        fprintf('  %s\n', unusedFiles{i});
    end

    % Ask for confirmation
    prompt = sprintf('\nDelete these %d unused file(s)? [y/N]: ', numel(unusedFiles));
    reply = lower(strtrim(input(prompt, 's')));
    if startsWith(reply, 'y')
        for i = 1:numel(unusedFiles)
            delete(unusedFiles{i});
            fprintf('Deleted: %s\n', unusedFiles{i});
        end
        fprintf('All unused files deleted.\n');
    else
        fprintf('Aborted. No files were deleted.\n');
    end
end
