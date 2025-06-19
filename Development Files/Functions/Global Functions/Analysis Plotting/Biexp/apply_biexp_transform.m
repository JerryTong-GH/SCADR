function transformed = apply_biexp_transform(data, width, maxRange, neg)
% APPLY_BIEXP_TRANSFORM Realistic biexponential transform with adaptive defaults.
%
%   transformed = APPLY_BIEXP_TRANSFORM(data, width, maxRange, neg)
%
% Parameters (all optional):
%   - data: numeric array
%   - width: linear region width in decades (auto if empty)
%   - maxRange: dynamic range upper bound (auto if empty)
%   - neg: number of negative decades (auto if empty)

    arguments
        data {mustBeNumeric}
        width double = []       % adaptive
        maxRange double = []    % adaptive
        neg double = []         % adaptive
    end

    data = double(data);
    abs_data = abs(data(:));
    
    % Auto maxRange: use 95th percentile (robust to outliers)
    if isempty(maxRange)
        maxRange = prctile(abs_data, 95);
    end

    % Auto neg: estimate based on min value (avoid log of 0)
    if isempty(neg)
        min_val = max(min(abs_data(abs_data > 0)), eps);
        neg = ceil(abs(log10(min_val / maxRange)));
    end

    % Auto width: 1/10 of dynamic range in decades
    if isempty(width)
        data_decades = log10(maxRange / max(min(abs_data(abs_data > 0)), eps));
        width = max(0.2, data_decades / 10);  % enforce minimum
    end

    % Compute total transform span in decades
    total_decades = log10(maxRange) + neg;
    
    % Perform the transformation
    log_base = 10;
    scaled_data = abs(data) / maxRange * total_decades;
    transformed = sign(data) .* log10(1 + log_base.^scaled_data) / total_decades;

    % Optional: rescale
    transformed = transformed * maxRange;
end
