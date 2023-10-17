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
    app.UIAxes.XLim          = [0 app.Interval_length];
    app.UIAxes.YLim          = [1 app.Num_intervals];
    app.UIAxes.XTick         = 0 : app.Interval_length;
    app.UIAxes.XTickLabel    = 0 : app.Interval_length;
    app.UIAxes.YTick         = 1 : app.Num_intervals;
    app.UIAxes.YTickLabel    = 1 : app.Num_intervals;

    % Plot spike times from each interval
    for i = 1:length(spks_cluster)     
        spikes           = spks_cluster{i}';   % Get all spike times for the interval   
        x            = repmat(spikes,3,1);     % Duplicate the array 
        y      	     = nan(size(x));           % Create empty array of the same size as x
        
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
    bins                     = 1000;
    app.UIAxes2.XLim         = [0  app.Interval_length];
    app.UIAxes2.XTick        = 0 : app.Interval_length;
    app.UIAxes2.XTickLabel   = 0 : app.Interval_length;
    h                        = histogram(app.UIAxes2, spk, bins);
    y_vals                   = max(h.Values) + round(max(h.Values)*.1);
    app.UIAxes2.YLim         = [0  y_vals];
    h.FaceColor              = 'black';

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


% resetAxes: resets X- and Y-axes to default parameters 
function resetAxes(app)
    % reset raster plot axes
    app.UIAxes.XLim = [0 5];
    app.UIAxes.YLim = [0 1];
    app.UIAxes.TickLength = [0.005 0.01];
    app.UIAxes.XTick = [0 1 2 3 4 5 6 7 8 9 10];
    app.UIAxes.XTickLabel = {'0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'; '10'};
    app.UIAxes.YTick = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143];
    app.UIAxes.YTickLabel = {'1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'; '10'; '11'; '12'; '13'; '14'; '15'; '16'; '17'; '18'; '19'; '20'; '21'; '22'; '23'; '24'; '25'; '26'; '27'; '28'; '29'; '30'; '31'; '32'; '33'; '34'; '35'; '36'; '37'; '38'; '39'; '40'; '41'; '42'; '43'; '44'; '45'; '46'; '47'; '48'; '49'; '50'; '51'; '52'; '53'; '54'; '55'; '56'; '57'; '58'; '59'; '60'; '61'; '62'; '63'; '64'; '65'; '66'; '67'; '68'; '69'; '70'; '71'; '72'; '73'; '74'; '75'; '76'; '77'; '78'; '79'; '80'; '81'; '82'; '83'; '84'; '85'; '86'; '87'; '88'; '89'; '90'; '91'; '92'; '93'; '94'; '95'; '96'; '97'; '98'; '99'; '100'; '101'; '102'; '103'; '104'; '105'; '106'; '107'; '108'; '109'; '110'; '111'; '112'; '113'; '114'; '115'; '116'; '117'; '118'; '119'; '120'; '121'; '122'; '123'; '124'; '125'; '126'; '127'; '128'; '129'; '130'; '131'; '132'; '133'; '134'; '135'; '136'; '137'; '138'; '139'; '140'; '141'; '142'; '143'};
    
    % reset histogram axes
    app.UIAxes2.XLim = [0 5];
    app.UIAxes2.YLim = [0 1];
    app.UIAxes2.XTick = 0 : 5;
    app.UIAxes2.XTickLabel = {'0'; '1'; '2'; '3'; '4'; '5'};
    app.UIAxes2.YTick = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100];
    app.UIAxes2.YTickLabel = {'1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'; '10'; '11'; '12'; '13'; '14'; '15'; '16'; '17'; '18'; '19'; '20'; '21'; '22'; '23'; '24'; '25'; '26'; '27'; '28'; '29'; '30'; '31'; '32'; '33'; '34'; '35'; '36'; '37'; '38'; '39'; '40'; '41'; '42'; '43'; '44'; '45'; '46'; '47'; '48'; '49'; '50'; '51'; '52'; '53'; '54'; '55'; '56'; '57'; '58'; '59'; '60'; '61'; '62'; '63'; '64'; '65'; '66'; '67'; '68'; '69'; '70'; '71'; '72'; '73'; '74'; '75'; '76'; '77'; '78'; '79'; '80'; '81'; '82'; '83'; '84'; '85'; '86'; '87'; '88'; '89'; '90'; '91'; '92'; '93'; '94'; '95'; '96'; '97'; '98'; '99'; '100'};
    app.UIAxes2.ZTick = [];
end
end

