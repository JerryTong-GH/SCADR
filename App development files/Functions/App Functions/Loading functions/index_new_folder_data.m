function [] = index_new_folder_data(inputdata_dir)
%INDEX_NEW_FOLDER_DATA Asks for a source folder, and copies over all
%contents from source folder into inputdata_dir
%   Detailed explanation goes here
selpath = uigetdir(cd,'Select data source folder');
copyfile(selpath,inputdata_dir)
end

