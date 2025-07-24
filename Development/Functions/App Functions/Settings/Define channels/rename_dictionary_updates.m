function [old2new_column_names,new2old_column_names] = rename_dictionary_updates(old_column_names_list,new_column_names_list)
%RENAME_DICTIONARY_UPDATES Summary of this function goes here
%   Detailed explanation goes here
old2new_column_names = dictionary(old_column_names_list,new_column_names_list);
new2old_column_names = dictionary(new_column_names_list,old_column_names_list);
end

