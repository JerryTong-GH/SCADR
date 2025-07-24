function [params] = params_2_args(params)
%PARAMS_2_ARGS Summary of this function goes here
%   Detailed explanation goes here
fields = fieldnames(params);
params = rmfield(params, fields(structfun(@isempty, params)));
params = namedargs2cell(params);
end

