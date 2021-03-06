%DifferentialRobot Differential robot class

classdef DifferentialRobot < hgsetget
    
    properties
        % state
        Xr
        Xr0
        Xr_hist      % x history
        
        % parameters
        S           % separation of the wheels
        r           % radius of the wheels
        maxwspeed   % maximum wheels speed
        alphalim    % maximum angular speed
        Vr          % odometry covariance        
        w;          % angular velocity of the wheels
    
        odometry    % distance moved in last interval
 
    end
    properties (SetAccess = private)
        lidar       % LIDAR object
    end
    
    
    properties (Dependent = true)
        T   %transform matrix
    end
    methods
        
        function this = DifferentialRobot(varargin)
            %DifferentialRobot object constructor
            
            %% Default values
            this.Xr0 = zeros(3,1);
            this.Vr = zeros(2,2);
            this.alphalim = 2*pi; 
            this.maxwspeed = 5;
            this.S = 0.52;
            this.r = 0.0947;
            

            %% Set inputs
            this.set(varargin{:});            
            % TODO: check inputs
            
            this.init();

        end
        
        function T = get.T(this)
            T = se2(this.Xr(1), this.Xr(2), this.Xr(3));
        end
        
%         function T= globalTransform(this)
%             T = se2(this.Xr(1), this.Xr(2), this.Xr(3));
%         end
        
        function attachLidar(this, lidar, Xl)
            %DifferentialRobot.attachLidar Set a LIDAR object
            %
            % rob.attachLidar(L, X) sets the lidar pose X (x, y, theta)
            % relative to robot pose
            if isempty(lidar) || (~isa(lidar, 'LIDAR'))
                error('lidar must be a LIDAR object');
            end
            this.lidar = lidar;
            this.lidar.attachToRobot(this, Xl);
        end
        
        function init(this)
            %DifferentialRobot.init Reset state of vehicle object
            %
            % rob.init() sets the state rob.x := rob.x0, initializes the driver
            % object (if attached) and clears the history.
            %
            % rob.init(X0) as above but the state is initialized to X0.

            this.Xr = this.Xr0;
            this.Xr_hist = this.Xr0';
            this.w = zeros(2,1);                    
        end
        
        function max = maxspeed(this, angularSpeed)
            %Computes the current maximum speed depending on the angular velocity
            max = this.maxwspeed - (angularSpeed * this.S / 2);
        end
        
        function xnext = f(this, Xr, odo, w)
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
            
            thp = Xr(:,3) + dth;
            xnext = Xr + [(dd+w(1))*cos(thp)  (dd+w(1))*sin(thp) ones(size(Xr,1),1)*dth+w(2)];
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
            this.Xr = this.f(this.Xr', odo)';
            this.odometry = odo;
            this.w = w;
            this.Xr_hist = [this.Xr_hist; this.Xr'];   % maintain history
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
            
            xp = this.Xr; % previous state
            this.Xr(1) = xp(1) + u(1)*dt*cos(xp(3));
            this.Xr(2) = xp(2) + u(1)*dt*sin(xp(3));
            this.Xr(3) = xp(3) + u(2)*dt;
            
            odo = [colnorm(this.Xr(1:2)-xp(1:2)) this.Xr(3)-xp(3)];
            
            % If speed is negative, the odometry must be negative too
            if u(1) < 0
                odo(1) = -odo(1);
            end
            this.odometry = odo;
            
            this.Xr_hist = [this.Xr_hist; this.Xr'];   % maintain history
        end
        
        function odo = updateNoisy(this, speed, steer, dt)
            %u = this.control(u(1), u(2));
            odo =  updateControl(this, speed, steer, dt);
            if ~isempty(this.Vr)
                odo = odo + randn(1,2)*this.Vr;
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
