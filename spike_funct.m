% Author: Navami Shenoy
% Helper functions for SpikeApp

% totalIntervals: calculates total number of intervals 
function totalIntervals(app)
    % uses total duration and the duration of each interval
    % to calculate the total number of intervals
    app.Num_intervals = ceil(app.Rectime/app.Interval_length);
end

% createCellArray: prepares spike data for plotting
function [spk_times,spks_cluster] = createCellArray(app, cluster_num)
    % create a cell array with spike times grouped into 5-second intervals
    totalIntervals(app); 
    cluster             = app.Clusters{cluster_num};       % get selected cluster from cell array
    spk_times           = cluster(:,1);                    % get spikes from the cluster   
    
    % group spike times by intervals
    for i=1:app.Num_intervals
        lower           = (i-1)*app.Interval_length;
        upper           = i*app.Interval_length;
        spks_cluster{i} = spk_times(spk_times > lower & ...
                                    spk_times <= upper) - lower;
    end
end

% plotSpikeRaster: generates a spike raster plot for the cluster
function plotSpikeRaster(app, spks_cluster)
    % set axes ticks and limits 
    app.UIAxes.XLim      = [0 app.Interval_length];
    app.UIAxes.YLim      = [1 app.Num_intervals];
    app.UIAxes.XTick     = 0 : app.Interval_length;
    app.UIAxes.YTick     = 1 : app.Num_intervals;

    % Plot spike times from each interval
    for i = 1:length(spks_cluster)     
        spikes           = spks_cluster{i}';    % Get all spike times for the interval   
        x            = repmat(spikes,3,1);  % Duplicate the array 
        y      	     = nan(size(x));    % Create empty array of the same size as x
        
        if ~isempty(y)
            y(1,:)   = i;    % offset spikes for each interval by 1 unit              
            y(2,:)   = i+1;  % along the y-axis
        end
        plot(app.UIAxes, x, y, 'Color', 'k')  % plot the interval 
        hold(app.UIAxes,'on');
    
    end
    set(app.UIAxes, 'YDir','reverse') % reverse y-axis 
    hold(app.UIAxes,'off');
end


%plotPSTH: generates a peristimulus time histogram for the cluster
function plotPSTH(app, spks_cluster)
    % collect spikes from all trials
    spk = [];
    for i = 1:length(spks_cluster)
        spk  = [spk; spks_cluster{i}];            
    end
    
    % plot histogram, adjust axes parameters
    bins               = 1000;
    app.UIAxes2.XLim   = [0  app.Interval_length];
    app.UIAxes2.XTick  = 0 : app.Interval_length;
    h                  = histogram(app.UIAxes2, spk, bins);
    y_vals             = max(h.Values) + round(max(h.Values)*.1);
    app.UIAxes2.YLim   = [0  y_vals];
    h.FaceColor        = 'black';

    % Convert spikes/bin (y-axis values) into spikes/second
    bin_length         = app.Interval_length/bins;                  % the duration of each bin
    bins_sec           = bins/app.Interval_length;                  % Number of bins/second
    new_y              = strings(length(app.UIAxes2.YTickLabel),1);
    for i = 1:length(app.UIAxes2.YTickLabel)
        spike          = str2num(app.UIAxes2.YTickLabel{i});
        spks_sec       = (spike / length(spks_cluster)) * bins_sec; % avg spikes/bin * bins/sec = avg spikes/sec
        new_y{i}       = num2str(round(spks_sec));                  % Change y-axis labels
    end

    app.UIAxes2.YTickLabel  = new_y;


end


% refreshWorkspace: clear variables when we import a new file
function refreshWorkspace(app)
    evalin('base','clearvars *');
end

