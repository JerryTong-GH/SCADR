function [xz_fit_bin,xz_fit_error,bin_sample_data] = fit_error_2_vars(selected_data,zvar,xvar,zvar_bins,zvar_bin_boundaries,options)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% Arguments
arguments (Input)
    selected_data
    zvar
    xvar
    zvar_bins
    zvar_bin_boundaries
end

% Optional
arguments (Input)
    options.error_bar_type = '95% range';
    options.use_smoothed_data = 0;
    options.smooth_method {mustBeMember(options.smooth_method,{'movmean','movmedian','gaussian','lowess','loess','rlowess','rloess','sgolay'})} = 'rloess';
    options.auto_smooth_span_factor = 0.25;
    options.specify_smooth_span {mustBeMember(options.specify_smooth_span,[1,0])} = 0;
    options.smooth_span = 5;
end

%% Function starts
% Fit xvar to zvar and segment
if options.use_smoothed_data
    if options.specify_smooth_span
    xz_fit = smoothdata(selected_data.(xvar),options.smooth_method,options.smooth_span);
    else
    xz_fit = smoothdata(selected_data.(xvar),options.smooth_method,"SmoothingFactor",options.auto_smooth_span_factor);
    end
end

% plot(selected_data.(zvar),selected_data.(xvar),'*',selected_data.(zvar),xz_fit,'r-')

xz_fit_bin = nan(zvar_bins,1);
xz_fit_error = zeros(zvar_bins,2);
bin_sample_data = cell(zvar_bins,1);

for i = 1:(zvar_bins)
    lower_cond = selected_data.(zvar)>=zvar_bin_boundaries(i);
    upper_cond = selected_data.(zvar)<=zvar_bin_boundaries(i+1);

    if options.use_smoothed_data
        xz_fit_bin(i) = mean(xz_fit(lower_cond&upper_cond));
    else
        xz_fit_bin(i) = mean(selected_data(lower_cond&upper_cond,xvar).Variables);
    end

    sample_data = selected_data((lower_cond&upper_cond),xvar);
    bin_sample_data{i} = selected_data((lower_cond&upper_cond),[zvar,xvar]);
    
    switch options.error_bar_type
        case 'std'
            xz_fit_error(i,:) = [std(sample_data.Variables),std(sample_data.Variables)];
        case '95% range'
            xz_fit_error(i,:) = prctile(sample_data.Variables,[5,95]);
        case 'standard error'
            xz_fit_error(i,:) = [std(sample_data.Variables)/sqrt(numel(sample_data.Variables)),std(sample_data.Variables)/sqrt(numel(sample_data.Variables))];
    end
end

end

