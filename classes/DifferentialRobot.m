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
        w_hist;     % w history
        
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
            % 'dt',T          Time interval
            % 'rdim',R        Robot size as fraction of plot window (default 0.2)
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
            opt.rdim = 0.2;
            opt.dt = 0.01; %seconds
            opt.x0 = zeros(3,1);
            
            %%Parse optionals arguments
            opt = tb_optparse(opt, varargin);
            
            this.x = zeros(3,1);
            this.V = V;
            this.dt = opt.dt;
            this.alphalim = (2*opt.vmax)/opt.S;
            this.maxwspeed = opt.vmax;
            this.S = opt.S;
            this.r = opt.r;
            this.x0 = opt.x0(:);
            this.rdim = opt.rdim;
            this.verbose = opt.verbose;
            this.w = [0 0];
            
            this.x_hist = [];
            
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
            this.x_hist = [];
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
            
            dd = odo(1) + w(1);
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
        
        function odo = update(this, u, w)
            %DifferentialRobot.update Update the vehicle state
            %
            % ODO = rob.update(U) is the true odometry value for
            % motion with U=[speed,steer].
            %
            % ODO = rob.update(U, W) the same, but with computed wheels
            % velocities W = [leftAngularSpeed, rightAngularSpeed]
            % Notes::
            % - Appends new state to state history property x_hist.
            % - Odometry is also saved as property odometry.
            if nargin < 3
                this.w(1) = (u(1) + (u(2)*this.S/2)) / this.r; % right wheel
                this.w(2) = (u(1) - (u(2)*this.S/2)) / this.r; % left wheel
            else
                this.w = w;
            end
            
            xp = this.x; % previous state
            this.x(1) = xp(1) + u(1)*this.dt*cos(xp(3));
            this.x(2) = xp(2) + u(1)*this.dt*sin(xp(3));
            this.x(3) = xp(3) + u(2)*this.dt;
            
            odo = [colnorm(this.x(1:2)-xp(1:2)) this.x(3)-xp(3)];
            
            % If speed is negative, the odometry must be negative also
            if u(1) < 0
                odo(1) = -odo(1);
            end
            this.odometry = odo;
            
            this.x_hist = [this.x_hist; this.x'];   % maintain history
            this.w_hist = [this.w_hist; this.w];
        end
        
        function odo = updateDifferential(this, w)
            %DifferentialRobot.update Update the vehicle state
            %
            % ODO = rob.update(U) is the true odometry value for
            % motion with U=[leftAngularSpeed, rightAngularSpeed] in rad/s.
            %
            % Notes::
            % - Appends new state to state history property x_hist.
            % - Odometry is also saved as property odometry.
            
            %u(1) = min(u(1), veh.maxwspeed);
            %u(2) = min(u(2), veh.maxwspeed);
            
%             rps = rph/3600;
%             vL = rps(1) * rob.r;
%             vR = rps(2) * rob.r;
%             speed = (vR + vL) / 2;
%             steer = (vR - vL) / rob.S; 
%             odo = rob.update([speed, steer], rph);
            vL = w(1) * this.r;
            vR = w(2) * this.r;
           
            speed = (vR + vL) / 2;
            steer = (vR - vL) / this.S;
            
            odo = this.update([speed steer], w);            
%             dx = speed * cos(rob.x(3)) * rob.dt;
%             dy = speed * sin(rob.x(3)) * rob.dt;
%             dth = steer * rob.dt;
%             
%             xp = rob.x;
%             rob.x(1) = rob.x(1) + dx;
%             rob.x(2) = rob.x(2) + dy;
%             rob.x(3) = rob.x(3) + dth;
%             
%             odo = [colnorm(rob.x(1:2)-xp(1:2)) rob.x(3)-xp(3)];
%             % If speed is negative, the odometry must be negative too
%             if w(1)+w(2) < 0
%                 odo(1) = -odo(1);
%             end
%             rob.odometry = odo;
%             
%             rob.x_hist = [rob.x_hist; rob.x'];   % maintain history
        end
        
        function odo = updateOdometry(this, odo)
            %DifferentialRobot.updateOdometry Update the vehicle state
            %
            % ODO = rob.update(ODO) updates the robot state and mantain the
            % history with the given odometry ODO.
            %
            % Notes::
            % - Appends new state to state history property x_hist.
            % - Odometry is also saved as property odometry.
            this.x = this.f(this.x', odo)';          
            this.odometry = odo;
            this.w = [0 0];
            this.x_hist = [this.x_hist; this.x'];   % maintain history
            this.w_hist = [this.w_hist; this.w];
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
        
        function odo = step(this, varargin)
            %DifferentialRobot.step Advance one timestep
            %
            % ODO = rob.step(SPEED, STEER) updates the vehicle state for one timestep
            % of motion at specified SPEED and STEER angle, and returns noisy odometry.
            %
            % ODO = rob.step() updates the vehicle state for one timestep of motion and
            % returns noisy odometry.  If a "driver" is attached then its DEMAND() method
            % is invoked to compute speed and steer angle.  If no driver is attached
            % then speed and steer angle are assumed to be zero.
            %
            % Notes::
            % - Noise covariance is the property V.
            %
            % See also DifferentialRobot.control, DifferentialRobot.update
            
            % get the control input to the vehicle from either passed demand or driver
            u = this.control(varargin{:});
            
            % compute the true odometry and update the state
            odo = this.update(u);
            
            % add noise to the odometry
            if ~isempty(this.V) && ~isequal(size(this.V),[2 2])
                odo = this.odometry + randn(1,2)*this.V;
            end
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
        
        
        % TODO run and run2 should become superclass methods...
        
        function p = run2(this, T, x0, speed, steer)
            %DifferentialRobot.run2 Run the vehicle simulation
            %
            % P = rob.run2(T, X0, SPEED, STEER) runs the vehicle model for a time T with
            % speed SPEED and steering angle STEER.  P (Nx3) is the path followed and
            % each row is (x,y,theta).
            %
            %
            % See also DifferentialRobot.run, DifferentialRobot.step.
            this.init(x0);
            
%             if nargout == 0
%                 if ~isempty(rob.driver)
%                     rob.driver.visualize();
%                 end
%                 rob.visualize();
%             end
            
            for i=1:(T/this.dt)
                this.update([speed steer]);
                if nargout == 0
                    % if no output arguments then plot each step
                    this.plot();
                    drawnow
                end
            end
            p = this.x_hist;
        end
        
        function h = plot(this, hg, varargin)
            %DifferentialRobot.plot Plot vehicle
            %
            % rob.plot(OPTIONS) plots the vehicle on the current axes at a pose given by
            % the current state.  If the vehicle has been previously plotted its
            % pose is updated.  The vehicle is depicted as a narrow triangle that
            % travels "point first" and has a length V.rdim.
            %
            % rob.plot(X, OPTIONS) plots the vehicle on the current axes at the pose X.
            
            % H = rob.plotv(X, OPTIONS) draws a representation of a ground robot as an
            % oriented triangle with pose X (1x3) [x,y,theta].  H is a graphics handle.
            %
            % rob.plotv(H, X) as above but updates the pose of the graphic represented
            % by the handle H to pose X.
            %
            % Options::
            % 'scale',S    Draw vehicle with length S x maximum axis dimension
            % 'size',S     Draw vehicle with length S
            % 'color',C    Color of vehicle.
            % 'fill'       Filled
            %
            % See also DifferentialRobot.plotv.
            if nargin < 2 || ~ishghandle(hg)
                hg = gcf;
            end
            
            
            h = findobj(hg, 'Tag', this.plotTag);
            if isempty(h)
                % no instance of vehicle graphical object found
                h = hgtransform();
                set(h, 'Tag', this.plotTag);  % tag it
                
                
                hold on;
                %% TODO: REMOVE  THIS SECTION %%
                %axis([-700 700 -700 700]);
                %axis equal;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                hp = [];
                %% center of robot
                %hp = [hp scatter(0, 0, 50, 'ro')];
                %% wheels
                rx = this.r;
                ry = this.r/4;
                xx = [-rx -rx rx rx -rx];
                yy = [-ry ry ry -ry -ry];
                
                hp = [hp  line( xx, yy + this.S/2)];
                hp = [hp line( xx, yy - this.S/2)];
                
                %% frame
                
                xx = [ 0 this.S 0 0 ];
                yy = [ this.S/2 0 -this.S/2 this.S/2];
                hp = [hp line( xx, yy)];
                
                %% lidar
%                 if ~isempty(rob.lidar)
%                     hp = [hp rob.lidar.plot(hg)];
%                 end
                
                
                for hh=hp
                    set(hh, 'Parent', h);
                    set(hh, 'Tag', 'iWalker');
                end
            end
            
            set(h, 'Matrix', transl([this.x(1:2)' 0]) * trotz (this.x(3)));
        end
    end % method
    
end % classdef
