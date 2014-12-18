classdef EKFSLAM < handle
    
    properties
        % STATE:
        % the state vector is [x_vehicle x_map] where
        % x_vehicle is 1x3 and
        % x_map is 1x(2N) where N is the number of map features
        x_est           % estimated state
        P_est           % estimated covariance
        
        % Features keeps track of features we've seen before.
        % Each column represents a feature.  This is a fixed size
        % array, indexed by feature id.
        % row 1: the start of this feature's state in the feature
        %        part of the state vector, initially NaN
        % row 2: the number of times we've sighted the feature
        features        % map state
        
        V_est           % estimate of covariance V
        W_est           % estimate of covariance W
        
        robot           % reference to the robot vehicle
        sensor          % reference to the sensor
        
        % FLAGS:
        %   withMap    estMap       mode
        %        0          0     dead reckoning
        %        x          1     SLAM
        %        1          0     localization
        
        mode
        estMap          % flag: estimating map
        
        joseph          % flag: use Joseph form to compute p
        verbose
        keepHistory     % keep history
        P0              % passed initial covariance
        map             % passed map
        
        % HISTORY:
        % vector of structs to hold EKF history
        % .x_est estimated state
        % .odo   vehicle odometry
        % .P     estimated covariance matrix
        % .innov innovation
        % .S
        % .K     Kalman gain matrix
        history
        dim          % robot workspace dimensions
    end
    
    methods
        function ekf = EKFSLAM(robot, V_est, P0, varargin)
            
            %% mandatory parameters valdiation
            if nargin < 3
                error('robot, V_est and P0 are mandatory parameters');
            end
            
            if ~isempty(robot) && ~(isa(robot, 'DifferentialRobot')  || isa(robot, 'Vehicle'))
                error('expecting DifferentialRobot object');
            end
            
            %% optional parameters validation
            p = inputParser();
            p.addOptional('joseph', true, @islogical);
            p.addOptional('estMap', false, @islogical);
            p.addOptional('history', true, @islogical);
            p.addOptional('verbose', false, @islogical);
            p.addOptional('W', []);
            p.addOptional('map', []);
            
            p.parse(varargin{:});
            opt = p.Results;
            
            if ~isempty(opt.map) && ~isa(opt.map, 'LandmarkMap')
                error('expecting LandmarkMap object');
            end          
            
            %% copy params to class properties
            ekf.robot = robot;
            ekf.V_est = V_est;
            ekf.P0 = P0;
            ekf.W_est = opt.W;
            ekf.verbose = opt.verbose;
            ekf.keepHistory = opt.history;
            ekf.joseph = opt.joseph;
            ekf.map = opt.map;
            ekf.estMap = opt.estMap;
            
            %% figure mode
            
            if ekf.estMap
                ekf.mode = 'SLAM';
                if isempty(ekf.map)
                    error('Slam mode needs an inital map (can be empty)');
                end
            elseif isempty(ekf.map)
                ekf.mode = 'dead reckoning';
            else
                ekf.mode = 'localization';
            end
            
            ekf.init();
        end
        
        function init(ekf)
            %EKF.init Reset the filter
            %
            % E.init() resets the filter state and clears the history.
            ekf.robot.init();
            
            % clear the history
            ekf.history = [];
            
            ekf.x_est = ekf.robot.x(:);   
            ekf.P_est = ekf.P0;               
        end
        
        function ekf = prediction(ekf, odo)
            % split the state vector and covariance into chunks for
            % vehicle and map
            xv_est = ekf.x_est(1:3);
            xm_est = ekf.x_est(4:end);
            
            Pvv_est = ekf.P_est(1:3,1:3);
            Pmm_est = ekf.P_est(4:end,4:end);
            Pvm_est = ekf.P_est(1:3,4:end);
            
            % evaluate the state update function and the Jacobians
            % and predict its covariance
            xv_pred = ekf.robot.f(xv_est', odo)';
            
            Fx = ekf.robot.Fx(xv_est, odo);
            Fv = ekf.robot.Fv(xv_est, odo);
            Pvv_pred = Fx*Pvv_est*Fx' + Fv*ekf.V_est*Fv';
            
            % compute the correlations
            Pvm_pred = Fx*Pvm_est;
            
            Pmm_pred = Pmm_est;
            xm_pred = xm_est;
            
            % put the chunks back together again
            x_pred = [xv_pred; xm_pred];
            P_pred = [ Pvv_pred Pvm_pred; Pvm_pred' Pmm_pred];
            
            % no update phase, estimate is same as prediction
            x_est = x_pred;
            P_est = P_pred;
            innov = [];
            S = [];
            K = [];
            
            % update the state and covariance for next time
            ekf.x_est = x_est;
            ekf.P_est = P_est;
                                   
            % record time history
            if ekf.keepHistory
                hist = [];
                hist.xv_est = x_est(1:3);
                hist.odo = odo;
                hist.P = P_est;
                hist.innov = innov;
                hist.S = S;
                hist.K = K;
                ekf.history = [ekf.history hist];
            end

            
        end
        
        %z : feature position
        %js: feature id
        %z2: feature range-angle
        function innovation(ekf, lan)
            
            switch ekf.mode
                case 'dead reckoning'
                    return;
                
                case 'localization'
                     % compute the innovation                                    
                    x_pred = ekf.x_est;
                    P_pred = ekf.P_est;
                    
                    xv_pred = x_pred(1:3);
                                       
                    % get landmark map
                    lan_pred = ekf.map.landmarks(lan.id);
                    
                    % innovation in range-bearing form
                    z = lan.h(xv_pred');
                    z_pred = lan_pred.h(xv_pred');
                    innov(1) = z(1) - z_pred(1);
                    innov(2) = angdiff(z(2), z_pred(2));
                    
                    Hx = lan_pred.Hx(xv_pred');
                    Hw = lan_pred.Hw(xv_pred');
                    
                    % Update
                    % compute innovation covariance
                    S = Hx*P_pred*Hx' + Hw*ekf.W_est*Hw';

                    % compute the Kalman gain
                    K = P_pred*Hx' / S;

                    % update the state vector
                    x_est = x_pred + K*innov';
                
                    % wrap heading state for a vehicle
                    x_est(3) = angdiff(x_est(3));
                
                    % update the covariance
                    if ekf.joseph
                        % we use the Joseph form
                        I = eye(size(P_pred));
                        P_est = (I-K*Hx)*P_pred*(I-K*Hx)' + K*ekf.W_est*K';
                    else
                        P_est = P_pred - K*S*K';
                    end
                    
                    % enforce P to be symmetric
                    P_est = 0.5*(P_est+P_est');
                    % update the state and covariance for next time
                    ekf.x_est = x_est;
                    ekf.P_est = P_est;
                case 'SLAM'
                    % compute the innovation                                    
                    x_pred = ekf.x_est;
                    P_pred = ekf.P_est;

                    % split the state vector and covariance into chunks for
                    % vehicle and map
                    xv_pred = x_pred(1:3);
                    xm_pred = x_pred(4:end);
                    
                    z = lan.h(xv_pred');
                    
                    if ekf.seenBefore(lan.id)
                        % get landmark map
                        lan_pred = ekf.map.landmarks(lan.id);
                        jx = ekf.features(1,lan.id);
                        
                        % innovation in range-bearing form  
                        z_pred = lan_pred.h(xv_pred');
                        innov(1) = z(1) - z_pred(1);
                        innov(2) = angdiff(z(2), z_pred(2));
                        
                        % compute Jacobian for this particular feature
                        Hx_k = lan_pred.Hxf(xv_pred');
                        
                        % create the Jacobian for all features
                        Hx = zeros(2, length(xm_pred));
                        Hx(:,jx:jx+1) = Hx_k;
                        Hw = lan_pred.Hw(xv_pred);
                        
                        % concatenate Hx for for vehicle and map
                        Hxv = lan_pred.Hx(xv_pred');
                        Hx = [Hxv Hx];
                        
                        % compute innovation covariance
                        S = Hx*P_pred*Hx' + Hw*ekf.W_est*Hw';
                        
                        % compute the Kalman gain
                        K = P_pred*Hx' / S;

                        % update the state vector
                        x_est = x_pred + K*innov';

                        % wrap heading state for a vehicle
                        x_est(3) = angdiff(x_est(3));

                        % update the covariance
                        if ekf.joseph
                            % we use the Joseph form
                            I = eye(size(P_pred));
                            P_est = (I-K*Hx)*P_pred*(I-K*Hx)' + K*ekf.W_est*K';
                        else
                            P_est = P_pred - K*S*K';
                        end

                        % enforce P to be symmetric
                        P_est = 0.5*(P_est+P_est');
                        
                        % update landmarks in map
                        xm_est = x_est(4:end);
                        for i = 1: length(ekf.map.landmarks)
                            j = i*2;
                            ekf.map.landmarks(i).update([xm_est(j-1); xm_est(j)]);
                        end

                    else
                        [x_pred, P_pred] = ekf.extendMap(P_pred, xv_pred, xm_pred, lan, z');
                        x_est = x_pred;
                        P_est = P_pred;
                        innov = [];
                        S = [];
                        K = [];
                    end
                    % update the state and covariance for next time
                    ekf.x_est = x_est;
                    ekf.P_est = P_est;
                otherwise
                    error('incorrect mode');
            end
            
            %record time history
             if ekf.keepHistory
                hist = [];
                hist.xv_est = x_est(1:3);
                hist.odo = [];
                hist.P = P_est;
                hist.innov = innov;
                hist.S = S;
                hist.K = K;
                ekf.history = [ekf.history hist];
            end
            return;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % compute the innovation                                    
            x_pred = ekf.x_est;
            P_pred = ekf.P_est;
            
            % split the state vector and covariance into chunks for
            % vehicle and map
            xv_pred = x_pred(1:3);
            xm_pred = x_pred(4:end);
            
            if ekf.seenBefore(js)
                % get previous estimate of its state
                jx = ekf.features(1,js);
                xf = xm_pred(jx:jx+1);
                
                % transform feature position to polar form
                %z_pred = cartesian2polar(xf', xv_pred(1:2)', xv_pred(3));
                
                % innovation in range-bearing form
                %innov(1) = z2(1) - z_pred(1);
                %innov(2) = angdiff(z2(2), z_pred(2));
                
                % innovation in (x,y) form
                innov = z - xf';
                
                % get previous estimate of its state
                jx = ekf.features(1,js);
                xf = xm_pred(jx:jx+1);
                
                % compute Jacobian for this particular feature
                Hx_k = ekf.sensor.Hxf(xv_pred', xf);
                
                % create the Jacobian for all features
                Hx = zeros(2, length(xm_pred));
                Hx(:,jx:jx+1) = Hx_k;
                
                Hw = ekf.sensor.Hw(xv_pred, xf);
                
                % concatenate Hx for for vehicle and map
                Hxv = ekf.sensor.Hx(xv_pred', xf);
                Hx = [Hxv Hx];
                
                % compute innovation covariance
                S = Hx*P_pred*Hx' + Hw*ekf.W_est*Hw';
                
                % compute the Kalman gain
                K = P_pred*Hx' / S;
                
                % update the state vector
                x_est = x_pred + K*innov';
                
                % wrap heading state for a vehicle
                x_est(3) = angdiff(x_est(3));
                
                % update the covariance
                if ekf.joseph
                    % we use the Joseph form
                    I = eye(size(P_pred));
                    P_est = (I-K*Hx)*P_pred*(I-K*Hx)' + K*ekf.W_est*K';
                else
                    P_est = P_pred - K*S*K';
                end
                
                % enforce P to be symmetric
                P_est = 0.5*(P_est+P_est');
                
            else
                [x_pred, P_pred] = ekf.extendMap(P_pred, xv_pred, xm_pred, z', z2, js);
                x_est = x_pred;
                P_est = P_pred;
                innov = [];
                S = [];
                K = [];
            end
            
            % update the state and covariance for next time
            ekf.x_est = x_est;
            ekf.P_est = P_est;
            
            
            
            % record time history
            if ekf.keepHistory
                hist = [];
                hist.x_est = x_est;
                hist.odo = ekf.history(end).odo;
                hist.P = P_est;
                hist.innov = innov;
                hist.S = S;
                hist.K = K;
                ekf.history = [ekf.history hist];
            end
            
        end
        
        %% Plot methods
        
        function plot_xy(ekf, varargin)
            %EKF.plot_xy Plot vehicle position
            %
            % E.plot_xy() overlay the current plot with the estimated vehicle path in
            % the xy-plane.
            %
            % E.plot_xy(LS) as above but the optional line style arguments
            % LS are passed to plot.
            %
            % P = E.plot_xy() returns the estimated vehicle pose trajectory
            % as a matrix (Nx3) where each row is x, y, theta.
            %
            % See also EKF.plot_error, EKF.plot_ellipse, EKF.plot_P.
            
                       
               xyt = zeros(length(ekf.history), 3);
                for i=1:length(ekf.history)
                    h = ekf.history(i);
                    xyt(i,:) = h.x_est(1:3)';
                end
 
                plot(xyt(:,1), xyt(:,2), varargin{:}); 
        end
        
        function out = plot_error(ekf, varargin)
            %EKF.plot_error Plot vehicle position
            %
            % E.plot_error(OPTIONS) plot the error between actual and estimated vehicle
            % path (x, y, theta).  Heading error is wrapped into the range [-pi,pi)
            %
            % OUT = E.plot_error() is the estimation error versus time as a matrix (Nx3)
            % where each row is x, y, theta.
            %
            % Options::
            % 'bound',S         Display the S sigma confidence bounds (default 3).
            %                   If S =0 do not display bounds.
            % 'boundcolor',C    Display the bounds using color C
            % LS                Use MATLAB linestyle LS for the plots
            %
            % Notes::
            % - The bounds show the instantaneous standard deviation associated
            %   with the state.  Observations tend to decrease the uncertainty
            %   while periods of dead-reckoning increase it.
            % - Ideally the error should lie "mostly" within the +/-3sigma
            %   bounds.
            %
            % See also EKF.plot_xy, EKF.plot_ellipse, EKF.plot_P.
            opt.bounds = 3;
            opt.boundcolor = 'r';
            
            [opt,args] = tb_optparse(opt, varargin);
            
            
                err = zeros(length(ekf.history), 3);
                for i=1:length(ekf.history)
                    h = ekf.history(i);
                    % error is true - estimated
                    err(i,:) = ekf.robot.x_hist(i,:) - h.x_est(1:3)';
                    err(i,3) = angdiff(err(i,3));
                    P = diag(h.P);
                    pxy(i,:) = opt.bounds*sqrt(P(1:3));
                end
                if nargout == 0
                    clf
                    t = 1:numrows(pxy);
                    t = [t t(end:-1:1)]';
                    
                    subplot(311)
                    if opt.bounds
                        edge = [pxy(:,1); -pxy(end:-1:1,1)];
                        h = patch(t, edge ,opt.boundcolor);
                        set(h, 'EdgeColor', 'none', 'FaceAlpha', 0.3);
                        hold on
                        plot(err(:,1), args{:});
                        hold off
                    end
                    grid
                    ylabel('x error')
                    
                    subplot(312)
                    edge = [pxy(:,2); -pxy(end:-1:1,2)];
                    h = patch(t, edge, opt.boundcolor);
                    set(h, 'EdgeColor', 'none', 'FaceAlpha', 0.3);
                    hold on
                    plot(err(:,2), args{:});
                    hold off
                    grid
                    ylabel('y error')
                    
                    subplot(313)
                    edge = [pxy(:,3); -pxy(end:-1:1,3)];
                    h = patch(t, edge, opt.boundcolor);
                    set(h, 'EdgeColor', 'none', 'FaceAlpha', 0.3);
                    hold on
                    plot(err(:,3), args{:});
                    hold off
                    grid
                    xlabel('time (samples)')
                    ylabel('\theta error')
                else
                    out = pxy;
                end
            
        end
        
        
    end % public methods
    
    methods (Access=protected)
        function s = seenBefore(ekf, jf)
            if  size(ekf.features, 2) >= jf && ekf.features(1,jf) > 0
                %% we have seen this feature before, update number of sightings
                if ekf.verbose
                    fprintf('feature %d seen %d times before, state_idx=%d\n', ...
                        jf, ekf.features(2,jf), ekf.features(1,jf));
                end
                ekf.features(2,jf) = ekf.features(2,jf)+1;
                s = true;
            else
                s = false;
            end
        end
        
        
        function [x_ext, P_ext] = extendMap(ekf, P, xv, xm, lan, z)% xf, z, jf)
            
            %% this is a new feature, we haven't seen it before
            % estimate position of feature in the world based on
            % noisy sensor reading and current vehicle pose
            
            if ekf.verbose
                fprintf('feature %d first sighted\n', lan.id);
            end
            
            xf = lan.pos;
            
            % estimate its position based on observation and vehicle state
            %xf = ekf.sensor.g(xv, z)';
            
            % append this estimate to the state vector
            x_ext = [xv; xm; xf];

            
            % get the Jacobian for the new feature
            Gz = lan.Gz(xv, z);
            
            % extend the covariance matrix           
            Gx = lan.Gx(xv, z);
            n = length(ekf.x_est);
            M = [eye(n) zeros(n,2); Gx zeros(2,n-3) Gz];
            P_ext = M*blkdiag(P, ekf.W_est)*M';
 
            
            % record the position in the state vector where this
            % feature's state starts
            jf = lan.id;
            ekf.features(1,jf) = length(xm)+1;
            %ekf.features(1,jf) = length(ekf.x_est)-1;
            ekf.features(2,jf) = 1;        % seen it once
            
            if ekf.verbose
                fprintf('extended state vector\n');
            end
            
            % plot an ellipse at this time
            %                jx = features(1,jf);
            %                plot_ellipse(x_est(jx:jx+1), P_est(jx:jx+1,jx:jx+1), 5);
            
        end
    end
    
end

