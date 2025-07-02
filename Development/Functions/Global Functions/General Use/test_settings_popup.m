%% V1
position = [100,100,300,300];
title = "test";


v1 = 50;
v2 = 45;
v3 = 42;
v4 = 325;
v5 = 134235;

l1 = "first";
l2 = "second";
l3 = "third";
l4 = "fourth";
l5 = "fifth";


[x,y] = settings_popup_edit(position,title, ...
    l1,v1,[], ...
    l2,v2,[], ...
    l3,v3,[], ...
    l4,v4,[], ...
    l5,v5,[]);

% masterfig = uifigure('Position',position,'Name',title);
% master_panel = uipanel('Parent',masterfig,'Position',masterfig.Position,'BorderType','none');

%% V2

position = [100,100,300,300];
title = "test";

v1 = 50;
v2 = 45;
v3 = 42;
v4 = 325;
v5 = 134235;

l1 = "first";
l2 = "second";
l3 = "third";
l4 = "fourth";
l5 = "fifth";


input1 = struct('label',l1,'value',v1,'type',"number_edit");
input2 = struct('label',l1,'value',v1,'type',"number_edit");
input3 = struct('label',l1,'value',v1,'type',"number_edit");
input4 = struct('label',l1,'value',v1,'type',"number_edit");
input5 = struct('label',l1,'value',v1,'type',"number_edit");

[x] = settings_popup_edit_2(position,title, ...
    input1, ...
    input2, ...
    input3, ...
    input4, ...
    input5);

%% V3

expression_marker_parameters = struct('pred_interval',0.95,'segment_bins',30);

expression_marker_input_meta = dictionary(["pred_interval","segment_bins"], ...
    {struct("type","numeric","label","Enter the prediction interval %"), ...
    struct("type","numeric","label","Enter the number of bins to do for each linear segment fit")});

expression_marker_input_settings = dictionary(["pred_interval","segment_bins"], ...
    {struct("Limits",[0,100],"LowerLimitInclusive","off","UpperLimitInclusive","on"), ...
    struct("Limits",[0,Inf],"LowerLimitInclusive","off")});

% app_settings_input = struct("input_meta",expression_marker_input_meta,"input_settings",expression_marker_input_settings);

% expression_marker_app_settings = dictionary(["pred_interval";"segment_bins"], ...
%     {expression_marker_button_settings,expression_marker_value_settings});








