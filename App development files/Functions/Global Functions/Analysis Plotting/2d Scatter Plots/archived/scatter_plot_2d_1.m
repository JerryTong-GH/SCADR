function [] = scatter_plot_2d_1(xvar,yvar,varargin)
%2D_SCATTER_PLOT Summary of this function goes here
%   Detailed explanation goes here
%   'axis'    -  target axis to plot

%% Function initialise
%Specify default for optional input arguments
default_target_axis = 0;

%Specify parameter requirements
p = inputParser;
addRequired(p,'xvar')
addRequired(p,'yvar')
addParameter(p,'axis',default_target_axis)

%validate inputs
parse(p,xvar,yvar,varargin{:});

%save input variables
xvar = p.Results.xvar;
yvar = p.Results.yvar;
target_axis = p.Results.axis;

%% Function begins

end

