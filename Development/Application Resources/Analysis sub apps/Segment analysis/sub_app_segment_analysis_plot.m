function [] = sub_app_segment_analysis_plot(plot_axes,plot_type,segmentdata,variant_number,segment_number,options)
%SUB_APP_SEGMENT_ANALYSIS_PLOT Summary of this function goes here
%   Detailed explanation goes here
%% Function arguments
% required inputs
arguments
    plot_axes
    plot_type
    segmentdata
    variant_number
    segment_number
    options
end

%% Function begins
%reset axes
reset(plot_axes)
cla(plot_axes)
plot_axes.XLimMode = "auto";
hold(plot_axes,"on")

xvar = segmentdata.tfitsample{variant_number}{segment_number}(:,1);
yvar = segmentdata.tfitsample{variant_number}{segment_number}(:,2);
yci = segmentdata.tyci{variant_number}{segment_number};
ypred = segmentdata.typred{variant_number}{segment_number};
fitoutput = segmentdata.tfitoutput{variant_number}{segment_number};

selected_cell_lines = segmentdata.selected_cell_lines(variant_number);

switch plot_type
    case 'Sample'
        %scatter
        if options.do_scatter
            switch options.scatter_type
                case "scatter"

                    sp = scatter(plot_axes,xvar,yvar,options.scatter_marker);
                case "bin scatter"
                    sp = binscatter(plot_axes,xvar,yvar);
            end
        else
            sp = [];
        end

        %fit
        if options.do_segment_line_fit
            fitp = plot(plot_axes,xvar,ypred,'-','LineWidth',2);
        else
            fitp = [];
        end

        %prediction interval
        if options.do_segment_line_standard_error
            predfitp = plot(plot_axes,xvar,yci(:,1),'m--',xvar,yci(:,2),'m--');
        else
            predfitp = [];
        end

        if options.do_legend
            %legend
            legendlabels = [strcat(selected_cell_lines,": Data"),strcat(selected_cell_lines,": Linear fit"),"Prediction interval"];
            legend(plot_axes,[sp,fitp,predfitp(1)],cellstr(legendlabels));
        end

        %Label
        xlabel(plot_axes,segmentdata.expression_channel);
        ylabel(plot_axes,segmentdata.selected_marker)

    case 'Histogram'
        if ~options.autobins
            histogram(plot_axes,xvar)
        else
            histogram(plot_axes,xvar,options.manualbins)
        end

        xlabel(plot_axes,segmentdata.expression_channel);
        ylabel(plot_axes,"Cell Count")
        legend(plot_axes,'hide')

    case 'Residuals'
        ploth = [];
        residpoints = fitoutput.residuals;

        switch options.residual_type
            case "scatter"
                sp = scatter(plot_axes,xvar,residpoints,options.residual_marker);
            case "bin scatter"
                sp = binscatter(plot_axes,xvar,residpoints);
        end

        ploth = [ploth,sp];

        if options.do_zeroline
            yl = yline(plot_axes,0,'r');
            ploth = [ploth,yl];
        end

        if options.do_residual_legend
            legend(plot_axes,ploth,strcat(selected_cell_lines,": Data"),"Zero Line")
        end
end

end

