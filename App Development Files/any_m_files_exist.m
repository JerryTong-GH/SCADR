function exists = any_m_files_exist(folderPath)
% ANY_M_FILES_EXIST Check if any .m file exists in a folder or subfolders
%
%   exists = any_m_files_exist('C:\MyProject')
%
%   Returns true if any .m file exists anywhere under the specified folder.

    arguments
        folderPath (1, :) char {mustBeFolder}
    end

    % Search recursively for any .m files
    mFiles = dir(fullfile(folderPath, '**', '*.m'));

    % Return true if any are found
    exists = ~isempty(mFiles);
end

% Helper validator
function mustBeFolder(folder)
    if ~isfolder(folder)
        error('The specified path is not a folder: %s', folder);
    end
end
