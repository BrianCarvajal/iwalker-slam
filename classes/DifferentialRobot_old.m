%DifferentialRobot Differential robot class
%
% This class models the kinematics of a differential wheeled robot.  For
% given steering and velocity inputs it updates the true vehicle state and returns
% noise-corrupted odometry readings.
%
% Methods::
%   init         initialize vehicle state
%   f            predict next state based on odometry
%   step         move one time step and return noisy odometry
%   control      generate the control inputs for the vehicle
%   update       update the vehicle state
%   run          run for multiple time steps
%   Fx           Jacobian of f wrt x
%   Fv           Jacobian of f wrt odometry noise
%   gstep        like step() but displays vehicle
%   plot         plot/animate vehicle on current figure
%   plot_xy      plot the true path of the vehicle
%   add_driver   attach a driver object to this vehicle
%   display      display state/parameters in human readable form
%   char         convert to string
%
% Static methods::
%   plotv        plot/animate a pose on current figure
%
% Properties (read/write)::
%   x               true vehicle state (3x1)
%   V               odometry covariance (2x2)
%   odometry        distance moved in the last interval (2x1)
%   rdim            dimension of the robot (for drawing)
%   S               separation between wheels
%   alphalim        steering wheel limit <- TODO: Remove?
%   maxspeed        maximum vehicle speed
%   T               sample interval
%   x_hist          history of true vehicle state (Nx3)
%   x0              initial state, restored on init()
%
% Examples::
%
% Create a robot with odometry covariance
%       rob = DifferentialRobot( diag([0.1 0.01].^2 );
% and display its initial state
%       rob
% now apply a speed (0.2m/s) and steer angle (0.1rad) for 1 time step
%       odo = rob.update([0.2, 0.1])
% where odo is the noisy odometry estimate, and the new true vehicle state
%       rob
%
%
% Notes::
% - Subclasses the MATLAB handle class which means that pass by reference semantics
%   apply.

% Copyright (C) 2014, by Brian Carvajal Meza, based in Peter I. Corke code,
% part of The Robotics Toolbox for Matlab (RTB).
%
% This file is part of a master thesis.
%
% RTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% RTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
%
% You should have received a copy of the GNU Leser General Public License
% along with RTB.  If not, see <http://www.gnu.org/licenses/>.

classdef DifferentialRobot < handle
    
    properties
        % state
        x           % true state (x,y,theta)
        x_hist      % x history
        
        % parameters
        S           % separation of the wheels
        r           % radius of the wheels
        maxwspeed   % maximum wheels speed
        alphalim    % maximum angular speed
        dim         % dimension of the world -dim -> +dim in x and y
        rdim        % dimension of the robot
        dt          % sample interval
        V           % odometry covariance        
        w;          % angular velocity of the wheels
    
        odometry    % distance moved in last interval
        
        verbose
        
        
        x0          % initial state
        plotTag     % tag for plots
    end
    properties (SetAccess = private)
        lidar       % LIDAR object
    end
    
    
    properties (Dependent = true)
        T   %transform matrix
    end
    methods
        
        function this = DifferentialRobot(V, varargin)
            %DifferentialRobot object constructor
            %
            % rob = DifferentialRobot(V_ACT, OPTIONS)  creates a DifferentialRobot object with actual odometry
            % covariance V_ACT (2x2) matrix corresponding to the odometry vector [dx dtheta].
            %
            % Options::
            % 'stlim',A       Steering angle limit (default 2 Pi rad)
            % 'vmax',S        Maximum speed (default 5m/s)
            % 'S',S           Wheels separation (default 20cm)
            % 'r',r           Radius of the wheels (default 3cm)
            % 'x0',x0         Initial state (default (0,0,0) )
            % 'verbose'       Be verbose
            %
            % Notes::
            % - Subclasses the MATLAB handle class which means that pass by reference semantics
            %   apply.
            
            
            %%Default values
            if nargin < 1
                V = zeros(2,2);
            elseif ~isnumeric(V)
                error('first arg is V');
            end
            opt.vmax = 5;
            opt.S = 0.52; %m
            opt.r = 0.0947; %m

            opt.x0 = zeros(3,1);
            
            %%Parse optionals arguments
            opt = tb_optparse(opt, varargin);
            
            this.x = zeros(3,1);
            this.V = V;
            this.alphalim = (2*opt.vmax)/opt.S;
            this.maxwspeed = opt.vmax;
            this.S = opt.S;
            this.r = opt.r;
            this.x0 = opt.x0(:);
            this.verbose = opt.verbose;
            this.w = zeros(2,1);
            
            this.x_hist = this.x';
            this.plotTag = 'DifferentialRobot.plot';
        end
        
        function T = get.T(this)
            T = se2(this.x(1), this.x(2), this.x(3));
        end
        
        function T= globalTransform(this)
            T = se2(this.x(1), this.x(2), this.x(3));
        end
        
        function attachLidar(this, lidar, x)
            %DifferentialRobot.attachLidar Set a LIDAR object
            %
            % rob.attachLidar(L, X) sets the lidar pose X (x, y, theta)
            % relative to robot pose
            if isempty(lidar) || (~isa(lidar, 'LIDAR'))
                error('lidar must be a LIDAR object');
            end
            this.lidar = lidar;
            this.lidar.attachToRobot(this, x);
        end
        
        function init(this, x0)
            %DifferentialRobot.init Reset state of vehicle object
            %
            % rob.init() sets the state rob.x := rob.x0, initializes the driver
            % object (if attached) and clears the history.
            %
            % rob.init(X0) as above but the state is initialized to X0.
            if nargin > 1
                this.x = x0(:);
            else
                this.x = this.x0;
            end
            this.w = zeros(2,1);           
            this.x_hist = this.x';
        end
        
        function max = maxspeed(this, angularSpeed)
            %Computes the current maximum speed depending on the angular velocity
            max = this.maxwspeed - (angularSpeed * this.S / 2);
        end
        
        function xnext = f(this, x, odo, w)
            %DifferentialRobot.f Predict next state based on odometry
            %
            % XN = rob.f(X, ODO) predict next state XN (1x3) based on current state X (1x3) and
            % odometry ODO (1x2) is [distance,change_heading].
            %
            % XN = rob.f(X, ODO, W) as above but with odometry noise W.
            %
            % Notes::
            % - Supports vectorized operation where X and XN (Nx3).
            if nargin < 4
                w = [0 0];
            end
            
            dd = odo(1);
            dth = odo(2);
            
            % straightforward code:
            % thp = x(3) + dth;
            % xnext = zeros(1,3);
            % xnext(1) = x(1) + (dd + w(1))*cos(thp);
            % xnext(2) = x(2) + (dd + w(1))*sin(thp);
            % xnext(3) = x(3) + dth + w(2);
            %
            % vectorized code:
            
            thp = x(:,3) + dth;
            xnext = x + [(dd+w(1))*cos(thp)  (dd+w(1))*sin(thp) ones(size(x,1),1)*dth+w(2)];
            %xnext = rob.x';
        end
        
             
        function s = leftSpeed(this)
            s = this.w(1) * this.r;
        end
        
        function s = rightSpeed(this)
           s = this.w(2) * this.r; 
        end
        
        function s = speed(this)
            s = (this.rightSpeed + this.leftSpeed) / 2;
        end
        
        function s = steer(this)
            s = (this.rightSpeed - this.leftSpeed) / this.S;
        end
        
        
        
        function odo = updateOdometry(this, odo, w)
            %DifferentialRobot.updateOdometry Update the vehicle state
            %
            % ODO = rob.update(ODO) updates the robot state and mantain the
            % history with the given odometry ODO.
            %
            % Notes::
            % - Appends new state to state history property x_hist.
            % - Odometry is also saved as property odometry.
            if nargin < 3
               w = zeros(2,1); 
            end
            this.x = this.f(this.x', odo)';
            this.odometry = odo;
            this.w = w;
            this.x_hist = [this.x_hist; this.x'];   % maintain history
        end
        
        
        function odo = updateControl(this, speed, steer, dt)
            %DifferentialRobot.update Update the vehicle state
            %
            % ODO = rob.update(U, DT) is the true odometry value for
            % motion with U=[speed,steer].
            %
            % ODO = rob.update(U, DT, W) the same, but with computed wheels
            % velocities W = [leftAngularSpeed, rightAngularSpeed]
            % Notes::
            % - Appends new state to state history property x_hist.
            % - Odometry is also saved as property odometry.
            if nargin < 5
                this.w(1) = (speed + (steer*this.S/2)) / this.r; % right wheel
                this.w(2) = (speed - (steer*this.S/2)) / this.r; % left wheel
            else
                this.w = w;
            end
            
            u = this.control(speed, steer);
            
            xp = this.x; % previous state
            this.x(1) = xp(1) + u(1)*dt*cos(xp(3));
            this.x(2) = xp(2) + u(1)*dt*sin(xp(3));
            this.x(3) = xp(3) + u(2)*dt;
            
            odo = [colnorm(this.x(1:2)-xp(1:2)) this.x(3)-xp(3)];
            
            % If speed is negative, the odometry must be negative too
            if u(1) < 0
                odo(1) = -odo(1);
            end
            this.odometry = odo;
            
            this.x_hist = [this.x_hist; this.x'];   % maintain history
        end
        
        function odo = updateNoisy(this, speed, steer, dt)
            %u = this.control(u(1), u(2));
            odo =  updateControl(this, speed, steer, dt);
            if ~isempty(this.V)
                odo = odo + randn(1,2)*this.V;
            end
        end
        
        function odo = updateWheels(this, w, dt)
            %DifferentialRobot.upd
            % ODO = rob.update(U) is the true odometry value for
            % motion with U=[leftAngularSpeed, rightAngularSpeed] in rad/s.
            %
            % Notes::
            % - Appends new state to state history property x_hist.
            % - Odometry is also saved as property odometry.
            
            %u(1) = min(u(1), veh.maxwspeed);
            %u(2) = min(u(2), veh.maxwspeed);
            
            vL = w(1) * this.r;
            vR = w(2) * this.r;         
            speed = (vR + vL) / 2;
            steer = (vR - vL) / this.S;
            
            odo = this.updateControl(speed, steer, dt);
        end             
        
        function J = Fx(this, x, odo)
            %DifferentialRobot.Fx  Jacobian df/dx
            %
            % J = V.Fx(X, ODO) is the Jacobian df/dx (3x3) at the state X, for
            % odometry input ODO.
            %
            % See also DifferentialRobot.f, DifferentialRobot.Fv.
            dd = odo(1); dth = odo(2);
            thp = x(3) + dth;
            
            J = [
                1   0   -dd*sin(thp)
                0   1   dd*cos(thp)
                0   0   1
                ];
        end
        
        function J = Fv(this, x, odo)
            %DifferentialRobot.Fv  Jacobian df/dv
            %
            % J = V.Fv(X, ODO) returns the Jacobian df/dv (3x2) at the state X, for
            % odometry input ODO.
            %
            % See also DifferentialRobot.F, DifferentialRobot.Fx.
            dd = odo(1); dth = odo(2);
            thp = x(3) + dth;
            
            J = [
                cos(thp)    -dd*sin(thp)
                sin(thp)    dd*cos(thp)
                0           1
                ];
        end
        
    
        function u = control(this, speed, steer)
            %DifferentialRobot.control Compute the control input to vehicle
            %
            % U = rob.control(SPEED, STEER) returns a control input (speed,steer)
            % based on provided controls SPEED,STEER to which speed and steering
            % angle limits have been applied.
            %
            % See also DifferentialRobot.step
            
            % clip the steering angle
            u(2) = max(-this.alphalim, min(this.alphalim, steer));
            
            % clip the speed
            maxspeed = this.maxspeed(u(2));
            u(1) = min(maxspeed, max(-maxspeed, speed));            
        end
        
    end % method
    
end % classdef
