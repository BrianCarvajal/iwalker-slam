%LIDAR sensor class
%
% This class models a Light Detection and Ranging, aka, LIDAR
%
% Methods::
%   newScan    set new range data
%   Hx
%
%
% Properties
%   robot           robot where the LIDAR is attached
%   dis
%   T               Transform matrix to robot frame (3x3)
%   W               measurement covariance matrix (2x2)
%
% Properties (readonly)::
%   data_length     number of points sensed
%   ang           angs of the sensed points
%   range           ranges of the sensed points
%   timestamp       acquisition time, expressed in seconds
%
% See also DifferentialRobot

classdef LIDAR < hgsetget
    
    properties 
       validRange       % [min, max], valid range
       horizon          %
       deadAngle        %
       outlierDist
    end
    
    properties (SetAccess = private)
        robot           % robot where the LIDAR is attached
        T               % transform matrix to robot frame
        angle           % angles of the sensed points
        range           % ranges of the sensed points
        p               % cartesian points in local frame
        pw              % cartesian points in world frame
        
        valid
        outliers
        inDeadAngle
        outRange
        
    end
    
    properties (Dependent = true)
        count           % number of sensed points
        Tw              % transformation matrix to world frame
        x               % location in the world frame
    end
    
    
    methods
        function this = LIDAR()
        %LIDAR object constructor
        %
        % lid = LIDAR(ROB, T) is an object representing a URG-04LX LIDAR.
        %   Rob: an instance of DifferentialRobot class, where the sensor
        %        is attached.
        %   T:   The transform matrix to robot frame.
        %
        % Examples:
        %   A robot with the sensor attached at 50 cm in the x Axis 
        %   from the origin of the robot frame.
        %
        %   rob = DifferentialRobot();
        %   T = se(0.50, 0, 0);
        %   lid = LIDAR(rob, T);
        %
        % See also DifferentialRobot.

            this.robot = [];
            this.T = se2(0,0,0);
            this.angle = [];
            this.range = [];
            this.validRange = [0.2 4];
            this.horizon = 6;
            this.outlierDist = 0.30;
            this.deadAngle = 0;
        end
        
        function c = get.count(this) 
           c = size(this.range,2); 
        end
        
        function x = get.x(this)
            x = pTransform([0;0], this.Tw);
        end
        
        function Tw = get.Tw(this)
            if isempty(this.robot)
              Tw = this.T;
           else
              Tw = this.robot.T * this.T;
            end
        end
        
%         function x = get.x(this)
%             x = pTransform([0;0], this.Tw);
%         end
        
        function attachToRobot(this, rob, x)
            if ~isequal(size(x), [1 3])
                error('x must be a 1x3 vector')
            end
            this.robot = rob;
            this.T = se2(x(1), x(2), x(3));
        end
        
        
        function newScan(this, range, angle)
        %LIDAR.setScan Set new scan data
        %
        % lid.setRangeData(R, A) sets new range data R with timestamp T        
        %   R:  a vector with range data, in m.
        %   A:  a vector with angle data, in degrees.
        

            if size(range,1) ~= size(angle,1)
                error('range and angle musth have the same size');
            end
            range(range == 0 | range > this.validRange(2)) = this.horizon;
            this.range = double(range);
            
            this.angle = double(angle);
            this.p = [this.range .* cosd(this.angle); 
                      this.range .* sind(this.angle)];
                  
            this.pw = pTransform(this.p, this.Tw());
            
            %% Find points in dead angle (behind iwalker)
            z = this.deadAngle/2;
            this.inDeadAngle = (this.angle > 180-z) & (this.angle < 180+z);

            %% Find points too near or too far (just for paint)
            this.outRange = ~this.inDeadAngle & ...
                            (this.range < this.validRange(1) | this.range > this.validRange(2));
 
            %% Find outliers
            pd = pdist2next(this.p);
            this.outliers = false(size(pd));
            for i = 2:length(this.outliers)-1
                this.outliers(i) = pd(i-1) > this.outlierDist && pd(i) > this.outlierDist;
            end
            
            %% Find valid points
            this.valid = ~this.inDeadAngle & ~this.outRange & ~this.outliers;

        end
        
        
    end
end
