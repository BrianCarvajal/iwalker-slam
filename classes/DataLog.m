%TODO: interrupt mode

classdef DataLog < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        laser
        wheels
    end
    
    properties (Access = private)
        i_wheel
        i_laser
    end
    
    methods
        function dlog =  DataLog(path)
            load(path);
            dlog.laser.data = Laser_d.signals.values;
            dlog.laser.length = size(Laser_d.signals.values, 1);
            dlog.laser.time =  Laser_d.time;
            dlog.laser.dt = Laser_d.time(2) - Laser_d.time(1);
            
            dlog.wheels.data = Wheel_rpm.signals.values;
            dlog.wheels.length = size(Wheel_rpm.signals.values, 1);
            dlog.wheels.time = Wheel_rpm.time;
            dlog.wheels.dt = Wheel_rpm.time(2) - Wheel_rpm.time(1);
            
            dlog.startPolling();
        end
        
        function [data, time] = getData(dlog, source, i)
            switch source
                case 'wheels'
                    if i < 1 || i > dlog.wheels.length
                       error('Index out of bounds'); 
                    end
                    data = dlog.wheels.data(i, :);
                    time = dlog.wheels.time(i);
                case 'laser'
                    if i < 1 || i > dlog.laser.length
                       error('Index out of bounds'); 
                    end
                    data = dlog.laser.data(i, :);
                    time = dlog.laser.time(i);
                otherwise
                    error('Source must be wheels or laser');                    
            end
        end
        
        function startPolling(dlog)
            dlog.i_wheel = 1;
            dlog.i_laser = 1;
        end
        
        function b = availableData(dlog)
            b = dlog.i_wheel <= dlog.wheels.length || ...
                dlog.i_laser <= dlog.laser.length;
        end
        
        function [data, time, source] = nextData(dlog)
            iw = dlog.i_wheel;
            il = dlog.i_laser;
            if iw <= dlog.wheels.length && il <= dlog.laser.length
                if dlog.wheels.time(iw) <= dlog.laser.time(il)
                    source = 'wheels';
                else
                    source = 'laser';
                end
            elseif iw <= dlog.wheels.length
                source = 'wheels';
            elseif il <= dlog.laser.length
                source= 'laser';
            else
                error('No data available');
            end
            
            switch (source)
                case 'wheels'
                    data = dlog.wheels.data(iw,:);
                    time = dlog.wheels.time(iw);
                    dlog.i_wheel = iw + 1;
                case 'laser'
                    data = dlog.laser.data(il,:);
                    time = dlog.wheels.time(il);
                    dlog.i_laser = il + 1;
            end          
        end                
               
    end
    
end

