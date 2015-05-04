function s = manualSegments( n, noise, sep, lims )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    if nargin < 4
       lims = [-10 10 -10 10];
    end
    
    if nargin < 3
       sep = 0.1; 
    end
    if nargin < 2
        noise = 0.1;
    end
    if nargin < 1
       n = 1; 
    end
    s = [];
    h = figure('MenuBar', 'none', 'Name', 'Segment editor');
    set(h, 'renderer', 'opengl');
    set(h,'DefaultLineLineSmoothing','on');
    set(h,'DefaultPatchLineSmoothing','on');
    closeclbk = get(h, 'CloseRequestFcn');
    set(h, 'CloseRequestFcn', '');  
    hold on;
    grid on;
    axis equal;
    axis(lims);
    for i = 1:n
       [x1, y1] = ginput(1);
       plot(x1,y1, 'r+');
       [x2, y2] = ginput(1);
       plot(x2,y2, 'r+');
       isHorizontal = abs(x1-x2) > abs(y1-y2);
       
       dist = sqrt( ((x1-x2)^2)+((y1-y2)^2));
       np = abs(dist/sep);
       if isHorizontal
          [m, c] = estimateLine([x1 x2], [y1 y2]);
          x = linspace(x1,x2, np);
          y = m * x + c;
       else
          [m, c] = estimateLine([y1 y2], [x1 x2]);
          y = linspace(y1,y2, np);
          x = y*m + c;
       end
       x = x+rand(size(x))*noise;
       y = y+rand(size(y))*noise;
%        if isHorizontal
%             plot(x,y,'.g');
%        else
%            plot(x,y,'.b');
%        end
       s = [s Segment([x; y])];
       s.plot;
    
    end  
    set(h, 'CloseRequestFcn', closeclbk);
end

