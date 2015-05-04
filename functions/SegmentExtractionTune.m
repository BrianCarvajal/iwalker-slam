function SegmentExtractionTune( filename )
    %% Data Initialization
    if nargin < 1
        [filename, ~, ~] = uigetfile('*.mat', 'Load datalog');
        if filename == 0
            return;
        end
    end
%     try
        fd = load(filename);
        dlog = DataLog(fd.iWalkerLog);

%     catch
%         return;
%     end

    lid = LIDAR();
    ext = FeatureExtractor();


    %% GUI Initialization
    f = figure('MenuBar', 'none', ...
        'NumberTitle', 'off', ...
        'Name',  'Feature Extractor Tune');
    %whitebg(f,[0.2 0.2 0.2]);
    set(f, 'renderer', 'opengl');
    set(f,'DefaultLineLineSmoothing','on');
    set(f,'DefaultPatchLineSmoothing','on');

    radPlot = RadarAxes('Parent', f, 'radius', 5);
    radPlot.hAxes.Position =  [0 0.05 0.7 0.95];

    slider = handle(uicontrol('Parent', f, ...
        'style', 'slider',...
        'Units','normalized', ...
        'Position', [0 0 0.7 0.05], ...
        'callback', @update));

    uicontrol('Parent', f, ...
        'style', 'pushbutton',...
        'String', 'Update', ...
        'Units','normalized', ...
        'Position', [0.7 0 0.3 0.05], ...
        'callback', @update);
    slider.min = 1;
    slider.max = length(dlog.lidar.range.Data);
    slider.value = 1;
    slider.SliderStep = [1/slider.max 1/slider.max*10];

    properties = [];
    % Plots properties
    properties = [ ...
        properties, ...
        PropertyGridField('DrawPoints', true, ...
        'Category', 'Plot', ...
        'DisplayName', 'Points', ...
        'Description', 'Plot lidar points'), ...
        PropertyGridField('DrawRays', true, ...
        'Category', 'Plot', ...
        'DisplayName', 'Rays', ...
        'Description', 'Plot lidar rays')
        ];

    % Feature extraction properties
    properties = [ ...
        properties, ...
        PropertyGridField('MinValidRange', 0.01, ...
        'Category', 'Segment extraction', ...
        'DisplayName', 'Min Valid Range', ...
        'Description', ''), ...
        PropertyGridField('MaxValidRange', 5.5, ...
        'Category', 'Segment extraction', ...
        'DisplayName', 'Max Valid Range', ...
        'Description', ''), ...
        PropertyGridField('MaxClusterDist', 0.3, ...
        'Category', 'Segment extraction', ...
        'DisplayName', 'Max Cluster Distance', ...
        'Description', ''), ...
        PropertyGridField('MinClusterPoints', 3, ...
        'Category', 'Segment extraction', ...
        'DisplayName', 'Min Cluster Points', ...
        'Description', ''), ...
        PropertyGridField('SplitDist', 0.15, ...
        'Category', 'Segment extraction', ...
        'DisplayName', 'Split Distance', ...
        'Description', ''), ...
        PropertyGridField('MinLength', 0.5, ...
        'Category', 'Segment extraction', ...
        'DisplayName', 'Min Length', ...
        'Description', ''), ...
        ];

    g = PropertyGrid(f, ...            % add property pane to figure
        'Properties', properties, ...  % set properties explicitly
        'Position', [0.7 0.05 0.3 0.95]);


    update();
    %% User interaction, wait to figure close
    uiwait(f);


    %% Private nested functions
    function update(varargin)
        props = g.GetPropertyValues();
        ext.validRange = [props.MinValidRange props.MaxValidRange];
        ext.maxClusterDist = props.MaxClusterDist;
        ext.minClusterPoints = props.MinClusterPoints;
        ext.splitDist = props.SplitDist;
        ext.lengthSegmentThresh = props.MinLength;
        
        lid.validRange = ext.validRange;
        
        step = floor(slider.value);
        range = dlog.lidar.range.Data(step, :);
        angle = dlog.lidar.angle.Data(step, :);
        lid.newScan(range/1000, angle);
        
        p = lid.pw(:, ~lid.outliers & ~lid.inDeadAngle);
        r = lid.range(~lid.outliers & ~lid.inDeadAngle);
        a = lid.angle(~lid.outliers & ~lid.inDeadAngle);
        ext.extract(r, a, p);
        

        %% Plots
        radPlot.init();
        if props.DrawPoints
            radPlot.drawPoints('ScanPoints.Valid', lid.p(:,lid.valid), 10, [0.00   1.00    1.00], '.');
        end
        if props.DrawRays
            radPlot.drawRays('ScanRays.Valid', lid.p(:,lid.valid), [0.00   1.00    1.00]/2, 1, '-');
        end        
        radPlot.drawSegments('Segments', ext.output.segments, [1 0 0], 3, '-');
        radPlot.drawHough('SegmentsH', ext.output.segments, [1 0 1], 1, '--');
        S1 = ext.output.segments;
        for i = 1:length(S1)
           S1(i).id = i;
           radPlot.writeText(['txt' num2str(i)], S1(i).a,num2str(S1(i).id), [1 0 1], 20);
        end
        
        
        if step-1 > 0
            range = dlog.lidar.range.Data(step-1, :);
            angle = dlog.lidar.angle.Data(step-1, :);
            lid.newScan(range/1000, angle);

            p = lid.pw(:, ~lid.outliers & ~lid.inDeadAngle);
            r = lid.range(~lid.outliers & ~lid.inDeadAngle);
            a = lid.angle(~lid.outliers & ~lid.inDeadAngle);
            ext.extract(r, a, p);
            
            S2 = ext.output.segments;
            
           
            for s2 = S2
                minND = 5;
                minDD = 0.3;
                for s1 = S1
                   nd = abs(s1.n - s2.n);
                   dd = abs(s1.d - s2.d);
                    
                  if nd < minND && dd < minDD
                      minND = nd;
                      minDD = dd;
                      s2.id = s1.id;
                  end
                end
            end
            
            radPlot.drawSegments('Segments-1', S2, [1 1 0], 3, '--');
            radPlot.drawHough('SegmentsH-1', S2, [0 1 1], 1, '--');
            for i = 1:length(S2)
               radPlot.writeText(['txt2' num2str(i)], S2(i).a - [0 0.5], num2str(S2(i).id), [1 0.5 0], 20);
            end
        end
        
        
    end
end

