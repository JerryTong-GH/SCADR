function [object] = property_change(property_name,value,object)
%PROPERTY_ASSIGNER Summary of this function goes here
%   Detailed explanation goes here

%% Function arguments
% required inputs
arguments (Input)
    property_name {mustBeA(property_name,{'string'})}
    value
end

% repeating inputs
arguments (Input,Repeating)
    object
end

% output arguments repeating
arguments (Output,Repeating)
    object
end

%% Function begins
for i = 1:numel(object)
    for j = 1:numel(property_name)
        set(object{i},property_name(j),value);
    end
end
end

