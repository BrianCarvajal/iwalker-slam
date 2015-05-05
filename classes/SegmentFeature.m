classdef SegmentFeature < AbstractFeature
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Xf      % feature state: [rho, theta, s, e]
        Vf
        id      % feature identifier. -1 if Anonymous
        updates % count of updates made with this feature
        visibleSide
        % extra data, useful for plots
        p       % point [x y] that represents the line in Hough Space
        u       % unit vector along the line
        sp      % start segment point
        ep      % end segment point
    end
    
    properties (Dependent = true)
        rho     % distance from the line to the origin
        theta   % angle betwen the line and the x-axis, in radians
        s       % distance from the line origin to the start segment point
        e       % disntace from the line origin to the end segment point
        len
    end
    
    %% Get/Set properties
    methods
        
        function set.Xf(this, value)
            this.Xf = value;
            this.computeProperties();
        end
        
        %% Rho
        function value = get.rho(this)
            value = this.Xf(1);
        end
        
        function set.rho(this, value)
            this.Xf(1) = value;
        end
        
        %% Theta
        function value = get.theta(this)
            value = this.Xf(2);
        end
        
        function set.theta(this, value)
            this.Xf(2) = value;
        end
        
        %% S
        function value = get.s(this)
            value = this.Xf(3);
        end
        
        function set.s(this, value)
            this.Xf(3) = value;
        end
        
        %% E
        function value = get.e(this)
            value = this.Xf(4);
        end
        
        function set.e(this, value)
            this.Xf(4) = value;
        end
        
        function value = get.len(this)
            value = this.e - this.s;
        end
        
        function computeProperties(this)
            x = this.rho * cos(this.theta);
            y = this.rho * sin(this.theta);
            this.p = [x y];
            %this.u = [y -x]/norm([x y]); problems with rho == 0
            hu = rotz(this.theta) * [0; 1; 1];
            this.u = -hu(1:2)';
            this.sp = this.p + this.u * this.s;
            this.ep = this.p + this.u * this.e;
        end
        
        
        
    end
    
    %% Main methods
    methods
        
        function this = SegmentFeature(Xf, Vf)
            if nargin == 0
                % for Segment array preallocation
                return;
            end
            this.Xf = Xf;
            this.Vf = Vf;
            this.id = -1;
            this.updates = 0;
        end
        
        function update(this, Xf, Vf)
           this.Xf(1:2) = Xf(1:2);
           this.Vf = Vf;
           this.updates = this.updates + 1;
        end
        
        
        function d = distance(f1, f2)
            d = sqrt((f1.rho - f2.rho)^2 + (f1.theta - f2.theta)^2);
        end
        
        function md = mahalanobisDistance(f1, f2, S)
           d = [f1.rho - f2.rho; f1.theta - f2.theta]; 
           md = d'*(S\d); % d'*inv(S)*d;
        end
        
        function b = overlaps(f1, f2, gap)
            b =  (f1.s-gap <= f2.e && f1.e+gap >= f2.s);
        end 
        
        function x = g(this, Xr)
            t = this.theta + Xr(3);
            r =  abs(this.rho + Xr(1)*cos(t) + Xr(2)*sin(t));
            k = -Xr(1)*sin(t) + Xr(2)*cos(t);
            s = this.s + k;
            e = this.e + k;
            x = [r t this.s this.e];
        end
        
        function z = h(this, Xr)
            t = this.Xf(2);
            r = this.Xf(1) - Xr(1)*cos(t) - Xr(2)*sin(t);
            b = angdiff(t, Xr(3));
            z = [r b];
        end
        
        function J = Hxr(this, Xr)
            t = this.Xf(2);
            J = [
                -cos(t), -sin(t),  0
                0,       0,       -1
                ];
        end
        
        function J = Hxf(this, Xr)
            t = this.Xf(2);
            J = [
                1, Xr(1)*sin(t) - Xr(2)*cos(t)
                0, 1
                ];
        end
        
        function J = Hw(this, Xr)
            J = eye(2,2);
        end
        
        function J = Gx(this, Xr, z)
            t = z(2) + Xr(3);
            J = [
                cos(t), sin(t), -Xr(1)*sin(t) + Xr(2)*cos(t)
                0       0       1
                ];
        end
        
        function J = Gz(this, Xr, z)
            t = z(2) + Xr(3);
            J = [
                1, -Xr(1)*sin(t)+Xr(2)*cos(t)
                0,  1
                ];
        end
    end
    
end

