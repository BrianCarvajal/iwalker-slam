classdef CornerFeature < AbstractFeature
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Xf      % feature state: [x, y]
        Vf
        id      % feature identifier. -1 if Anonymous
        updates % count of updates made with this feature
    end
    
    properties (Dependent = true)
        x
        y
    end
    
    %% Get/Set properties
    methods
        
        %% x
        function value = get.x(this)
            value = this.Xf(1);
        end
        
        function set.x(this, value)
            this.Xf(1) = value;
        end
        
        %% y
        function value = get.y(this)
            value = this.Xf(2);
        end
        
        function set.y(this, value)
            this.Xf(2) = value;
        end
        
    end
    
    methods
        function this = CornerFeature(Xf, Vf)
            if nargin == 0
                % for Segment array preallocation
                return;
            end
            this.Xf = Xf(:);
            this.Vf = Vf;
            this.id = -1;
            this.updates = 0;
        end
        
        function update(this, Xf, Vf)
           this.Xf = Xf;
           this.Vf = Vf;
           this.updates = this.updates + 1;
        end
        
        function d = distance(f1, f2)
            dd = f1.Xf - f2.Xf;
            d = sqrt(dd(1)^2 + dd(2)^2);
        end
        
        function md = mahalanobisDistance(f1, f2, S)
           d = f1.Xf - f2.Xf; 
           md = d'*(S\d); % d'*inv(S)*d;
        end
        
        
        
        function z = h(this, Xr) 
            dx = this.Xf(1) - Xr(:,1);
            dy = this.Xf(2) - Xr(:,2);
            z = [sqrt(dx.^2 + dy.^2) atan2(dy, dx)-Xr(:,3) ];
        end
        
        function J = Hxr(this, Xr)  
            Delta = this.Xf - Xr(1:2)';
            r = norm(Delta);
            J = [
                -Delta(1)/r,    -Delta(2)/r,        0
                Delta(2)/(r^2),  -Delta(1)/(r^2),   -1
                ];
        end
        
        function J = Hxf(this, Xr)
            Delta = this.Xf - Xr(1:2)';
            r = norm(Delta);
            J = [
                Delta(1)/r,         Delta(2)/r
                -Delta(2)/(r^2),    Delta(1)/(r^2)
                ];
        end
        
        function J = Hw(this, Xr)  
            J = eye(2,2);
        end
        
        function J = Gx(this, Xr, z)
            theta = Xr(3);
            r = z(1);
            bearing = z(2);
            J = [
                1,   0,   -r*sin(theta + bearing);
                0,   1,    r*cos(theta + bearing)
                ];
        end
        
        function J = Gz(this, Xr, z)
            theta = Xr(3);
            r = z(1);
            bearing = z(2);
            J = [
                cos(theta + bearing),   -r*sin(theta + bearing);
                sin(theta + bearing),    r*cos(theta + bearing)
                ];
        end
    end
    
end

