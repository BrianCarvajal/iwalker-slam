%DifferentialRobot vehicle class
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
%   verbose         verbosity
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
%
% Reference::
%
%   Robotics, Vision & Control,
%   Peter Corke,
%   Springer 2011
%
% See also RandomPath, EKF, LIDAR.

% Copyright (C) 2014, by Brian Carvajal Meza, based in Peter I. Corke code,
% part of The Robotics Toolbox for Matlab (RTB).
%
% This file is part of my master thesis.
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

        function rob = DifferentialRobot(V, varargin)
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
            opt.S = 0.520; %m
            opt.r = 0.100; %m
            opt.rdim = 0.2;
            opt.dt = 0.1;
            opt.x0 = zeros(3,1);
            
            %%Parse optionals arguments
            opt = tb_optparse(opt, varargin);
                        
            rob.x = zeros(3,1);
            rob.V = V;
            rob.dt = opt.dt;
            rob.alphalim = (2*opt.vmax)/opt.S;
            rob.maxwspeed = opt.vmax;
            rob.S = opt.S;
            rob.r = opt.r;
            rob.x0 = opt.x0(:);
            rob.rdim = opt.rdim;
            rob.verbose = opt.verbose;
            rob.w = [0 0];

            rob.x_hist = [];
            
            rob.plotTag = 'DifferentialRobot.plot';
        end
        
        function T = get.T(rob)
            T = transl([rob.x(1:2)' 0]) * trotz (rob.x(3));
        end
        
        function attachLidar(rob, lidar, x)
            %DifferentialRobot.setLidar Set a LIDAR object
            %
            % rob.setLidar(L, X) sets the lidar pose X (x, y, alpha)
            % relative to robot pose

           if isempty(lidar) || ~isa(lidar, 'LIDAR')
              error('lidar must be a LIDAR object');
           end
           if ~isequal(size(x), [1 3])
               error('x must be a 1x3 vector')
           end
           rob.lidar = lidar;
           lidar.robot = rob;
           lidar.x = x;
        end

        function init(rob, x0)
            %DifferentialRobot.init Reset state of vehicle object
            %
            % rob.init() sets the state rob.x := rob.x0, initializes the driver 
            % object (if attached) and clears the history.
            %
            % rob.init(X0) as above but the state is initialized to X0.
            if nargin > 1
                rob.x = x0(:);
            else
                rob.x = rob.x0;
            end
            rob.x_hist = [];
        end
        
        function max = maxspeed(rob, angularSpeed) 
            %Compute the current maximum speed depending on the angular velocity
            max = rob.maxwspeed - (angularSpeed * rob.S / 2);
        end


        
        function T = transform_matrix(rob)
           T = se2(rob.x(1), rob.x(2), rob.x(3)); 
        end
        

        function xnext = f(rob, x, odo, w)
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
        end

        function odo = update(rob, u, w)
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
                rob.w(1) = (u(1) + (u(2)*rob.S/2)) / rob.r; % right wheel
                rob.w(2) = (u(1) - (u(2)*rob.S/2)) / rob.r; % left wheel
            else
                rob.w = w;
            end
            
            xp = rob.x; % previous state
            rob.x(1) = xp(1) + u(1)*rob.dt*cos(xp(3));
            rob.x(2) = xp(2) + u(1)*rob.dt*sin(xp(3));
            rob.x(3) = xp(3) + u(2)*rob.dt;
            
            odo = [colnorm(rob.x(1:2)-xp(1:2)) rob.x(3)-xp(3)];
            rob.odometry = odo;

            rob.x_hist = [rob.x_hist; rob.x'];   % maintain history
            rob.w_hist = [rob.w_hist; rob.w];
        end
        
        function odo = updateDifferential(rob, u)
            %DifferentialRobot.update Update the vehicle state
            %
            % ODO = rob.update(U) is the true odometry value for
            % motion with U=[leftAngularSpeed, rightAngularSpeed].
            %
            % Notes::
            % - Appends new state to state history property x_hist.
            % - Odometry is also saved as property odometry.
            
            %u(1) = min(u(1), veh.maxwspeed);
            %u(2) = min(u(2), veh.maxwspeed);
            
            vL = u(1) * rob.r;
            vR = u(2) * rob.r;
            
            speed = (vR + vL) / 2;
            steer = (vR - vL) / rob.S;
                                
            odo = rob.update([speed, steer], u);
        end


        function J = Fx(rob, x, odo)
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

        function J = Fv(rob, x, odo)
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

        function odo = step(rob, varargin)
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
            u = rob.control(varargin{:});

            % compute the true odometry and update the state
            odo = rob.update(u);

            % add noise to the odometry
            if ~isempty(rob.V) && ~isequal(size(rob.V),[2 2])
                odo = rob.odometry + randn(1,2)*rob.V;
            end
        end


        function u = control(rob, speed, steer)
            %DifferentialRobot.control Compute the control input to vehicle
            %
            % U = rob.control(SPEED, STEER) returns a control input (speed,steer)
            % based on provided controls SPEED,STEER to which speed and steering
            % angle limits have been applied.
            %           
            % See also DifferentialRobot.step

            % clip the steering angle
            u(2) = max(-rob.alphalim, min(rob.alphalim, steer));
            
            % clip the speed
            maxspeed = rob.maxspeed(u(2));
            u(1) = min(maxspeed, max(-maxspeed, speed));

        end


        % TODO run and run2 should become superclass methods...

        function p = run2(rob, T, x0, speed, steer)
            %DifferentialRobot.run2 Run the vehicle simulation
            %
            % P = rob.run2(T, X0, SPEED, STEER) runs the vehicle model for a time T with
            % speed SPEED and steering angle STEER.  P (Nx3) is the path followed and
            % each row is (x,y,theta).
            %
            %
            % See also DifferentialRobot.run, DifferentialRobot.step.
            rob.init(x0);
            
            if nargout == 0
                if ~isempty(rob.driver)
                    rob.driver.visualize();
                end
                rob.visualize();
            end
            
            for i=1:(T/rob.dt)
                rob.update([speed steer]);
                if nargout == 0
                    % if no output arguments then plot each step
                    rob.plot();
                    drawnow
                end
            end
            p = rob.x_hist;
        end

        function h = plot(rob, hg, varargin)
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
            
   
            h = findobj(hg, 'Tag', rob.plotTag);
            if isempty(h)
                % no instance of vehicle graphical object found
                h = hgtransform();
                set(h, 'Tag', rob.plotTag);  % tag it
                
                              
                hold on;
                %% TODO: REMOVE  THIS SECTION %%
                %axis([-700 700 -700 700]);
                %axis equal;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                hp = [];
                %% center of robot
                hp = [hp scatter(0, 0, 50, 'ro')];
                %% wheels
                rx = rob.r;
                ry = rob.r/4;
                xx = [-rx -rx rx rx -rx];
                yy = [-ry ry ry -ry -ry];
                
                hp = [hp  line( xx, yy + rob.S/2)];
                hp = [hp line( xx, yy - rob.S/2)];
                
                %% frame
                
                xx = [ 0 rob.S 0 0 ];
                yy = [ rob.S/2 0 -rob.S/2 rob.S/2];
                hp = [hp line( xx, yy)];
  
                %% lidar
                if ~isempty(rob.lidar)
                   hp = [hp rob.lidar.plot(hg)]; 
                end
                      
                              
                for hh=hp
                    set(hh, 'Parent', h);
                    set(hh, 'Tag', 'iWalker');
                end
            end
            
            set(h, 'Matrix', rob.T);           
        end
        
        function plotTrace(rob, hg, varargin)
            if nargin < 2 || ~ishghandle(hg)
                hg = gcf;               
            end
            xyt = rob.x_hist;
             h = findobj(hg, 'Tag', 'rob.plotTrace');
             if isempty(h)
                 h = plot(xyt(:,1), xyt(:,2), varargin{:});
                 set(h, 'Tag', 'rob.plotTrace');
             else
                set(h, 'XData', xyt(:,1), 'YData', xyt(:,2));
             end            
        end

        function plot_xy(rob, varargin)
            %DifferentialRobot.plot_xy Plots true path followed by vehicle
            %
            % rob.plot_xy() plots the true xy-plane path followed by the vehicle.
            %
            % V.plot_xy(LS) as above but the line style arguments LS are passed
            % to plot.
            %
            % Notes::
            % - The path is extracted from the x_hist property.
            
            xyt = rob.x_hist;
            plot(xyt(:,1), xyt(:,2), varargin{:});

        end

        function visualize(rob)
            grid on
        end

        function verbosity(rob, v)
        %DifferentialRobot.verbosity Set verbosity
        %
        % V.verbosity(A) set verbosity to A.  A=0 means silent.
            rob.verbose = v;
        end
            
        function display(rob)
        %DifferentialRobot.display Display vehicle parameters and state
        %
        % rob.display() displays vehicle parameters and state in compact 
        % human readable form.
        %
        % Notes::
        % - This method is invoked implicitly at the command line when the result
        %   of an expression is a DifferentialRobot object and the command has no trailing
        %   semicolon.
        %
        % See also DifferentialRobot.char.

            loose = strcmp( get(0, 'FormatSpacing'), 'loose');
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            disp( char(rob) );
        end % display()

        function s = char(rob)
        %DifferentialRobot.char Convert to a string
        %
        % s = V.char() is a string showing vehicle parameters and state in in 
        % a compact human readable format. 
        %
        % See also DifferentialRobot.display.

            s = 'Differential wheeled robot object';
            s = char(s, sprintf(...
            '  S=%g, r=%g maxwspeed=%g, alphalim=%g, T=%f, nhist=%d', ...
                rob.S, rob.r, rob.maxwspeed, rob.alphalim, rob.dt, ...
                numrows(rob.x_hist)));
            if ~isempty(rob.V)
                s = char(s, sprintf(...
                '  V=(%g,%g)', ...
                    rob.V(1,1), rob.V(2,2)));
            end
            s = char(s, sprintf('  x=%g, y=%g, theta=%g', rob.x)); 
        end

    end % method

end % classdef
