classdef Segment < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        orientation     % orientation: 'horizontal' or 'vertical' 
        p               % points of the segment
        a, b            % endpoints of the segment
        mp
        n               % number of points
        d               % distance from point a to b (segment length)
        
        %mp % (rho, theta) point
        sd     
        ed
        
        m, c            % y = m*x + c if horizontal, x = -(m*y + c) if vertical
        rho, theta      % y*sin(theta) = rho - x*cos(theta)        
        
        Cc              % Covariance in cartesian form [var(m),cov(m,c); var(c); cov(c,m)];        
        Cp              % Covariance in polar form [var(rho),cov(rho,theta); var(theta); cov(theta,rho)];
        

    end
    
    properties 
        aOclusor       % true if endpoint a is an oclusor
        bOclusor       % true if endpoint b is an oclusor
        Sa, Sb         % adjecent segments at endpoints. Empty if any
        z
        id
    end
    
    
    methods
        
        function this = Segment(p)
            if nargin == 0
                % for Segment array preallocation
                return;
            end
            this.id = -1;
            if size(p,1) ~= 2
               error('Size of p must be 2 x n');
            end
            
            n_ = size(p,2);
            
            % Determine if the line is horizontal or vertical.
            % We do so to avoid the problem of vertical lines, where the
            % line equation y = m*x + c fails. In case of a vertical line,
            % we rotate the points and use the equation x = m*y + c
            slope = (p(2,end) - p(2,1))/(p(1,end) - p(1,1));
            isVertical = abs(slope) > 1;
            if isVertical
                orientation_ = 'vertical';
                % rotate the points -pi/2 radians
                X = p(2,:);
                Y = -p(1,:); 
            else
                orientation_ = 'horizontal';
                X = p(1,:);
                Y = p(2,:);
            end
            
            % least squares fit to obtains parameters of the
            % slope-intercept equation
            Y = Y';
            M = [X' ones(1,length(X))'];    
            P = (M'*M)\(M'*Y); % = inv(M'*M)*M'*Y
            m_ = P(1);
            c_ = P(2);
            
            % obtain endpoints a and b
            if isVertical
                a_ = [-(X(1)*m_ + c_), X(1)];
                b_ = [-(X(end)*m_ + c_), X(end)];
            else
                a_ = [X(1), X(1)*m_ + c_];
                b_ = [X(end), X(end)*m_ + c_];
            end
            
            % obtain the polar paremeters
            s1 = sqrt(m_^2 + 1);
            
            rho_ = (c_*sign(c_) / s1);
            if rho_ ~= 0
                theta_ = atan2(sign(c_) / s1, (-m_*sign(c_)) / s1);
            else
                % if rho is equal to zero the above formula does not works
                % we can extract the thetha directly from the slope
                
                theta_ = mod(atan(m_) + pi/2, pi);
            end
            
            if isVertical
               % undo the previous rotation
               theta_ = theta_ + pi/2;
            end
            
%             if rho_ == 0
%                 theta_ = theta_ + pi/2;
%             end
%             
%             [m_, theta_]
            
            % Compute sd and ed
            ep = rotz(-theta_) * [[a_ 1]' [b_ 1]'];
            sd_ = min(-ep(2,1:2));
            ed_ = max(-ep(2,1:2));

            mp_ = [rho_*cos(theta_); rho_*sin(theta_)];

            
            % Construct the observation vector z
            z_ = [rho_ theta_ sd_ ed_];
            
            
            % Compute Covariance matrix
            Ye = X'*m_ + c_;
            varY = var(Y-Ye);
            
            Cc_ = varY*inv(M'*M);
            
            varM = Cc_(1,1);
            varC = Cc_(2,2);
            covMC = Cc_(1,2);
            
            Krm = -c_*m_ * sign(c_) / (s1 + (m_^2+1));
            Krc = sign(c_) / s1;
            Ktm = 1 / (m_^2 + 1);
            
            varTh = Ktm^2 * varM;
            varRh = Krm^2 * varM + Krc^2 * varC + 2*Krm*Krc * covMC;
            covTR = Krm * Ktm * varM + Krc*Ktm*covMC;
            
            Cp_ = [varRh, covTR; ...
                  covTR, varTh];
            
            % save properties
            this.d = sqrt(((a_(1)-b_(1))^2) + ((a_(2)-b_(2))^2));
            this.orientation = orientation_;
            this.m = m_;
            this.c = c_;
            this.rho = rho_;
            this.theta = theta_;
            this.p = p;
            this.a = a_;
            this.b = b_;
            this.n = n_;
            this.Cc = Cc_;
            this.Cp = Cp_;
            this.sd = sd_;
            this.ed = ed_;
            this.z = z_;
            this.mp = mp_;
            
%             MX = [p(1,1) p(1,end)];%minmax(p(1,:));
%             MY = [p(2,1) p(2,end)];%(minmax(p(2,:));
%             if abs(MX(2)-MX(1)) > abs(MY(2)-MY(1)) 
%                 orientation = 'horizontal'; % horizontal
%                 
%                 [P, Cov] = LineLeastSquaresFit(p(1,:), p(2,:));
%                 m = P(1);
%                 c = P(2);
%                 [rho, theta] = parametric2hough(m, c, true);
%                 a = [MX(1), m*MX(1) + c];
%                 b = [MX(2), m*MX(2) + c];
%             else
%                 orientation = 'vertical'; % vertical
%                 [P, Cov] = LineLeastSquaresFit(p(2,:), p(1,:));
%                 m = P(1);
%                 c = P(2);
%                 [rho, theta] = parametric2hough(m, c, false);
%                 
%                 a = [MY(1)*m + c, MY(1)];
%                 b = [MY(2)*m + c, MY(2)];
%             end
%             this.d = sqrt(((a(1)-b(1))^2) + ((a(2)-b(2))^2));
%             this.n = size(p, 2); 
%             this.a = a;
%             this.b = b;
%             this.aOclusor = false;
%             this.bOclusor = false;
%             this.orientation = orientation;
%             this.p = p;
%             this.m = m;
%             this.c = c;
%             this.rho = rho;
%             this.theta = theta;
%             this.Cov = Cov;
        end
        
        
        function b = isVertical(this)
            b = strcmp(this.orientation, 'vertical');
        end
        
        function z = h(this, xv)
           r = this.rho - xv(1)*cos(this.theta) - xv(2)*sin(this.theta);
           t = angdiff(this.theta, xv(3));
           z = [r t];
        end
        
        function J = Hx(this, xv)
            J = [
                -cos(this.theta), -sin(this.theta),  0
                0                   0               -1
                ];
        end
        
        function J = Hxf(this, xv)
           J = [
               1 xv(1)*sin(this.theta)-xv(2)*cos(this.theta)
               0                      1
               ];
        end
        
        function J = Gx(this, xv, z)
        % xv: [x,y,t] robot pose
        %  z: [r, a] measurament
           t = z(2) + xv(3);
           J = [
               cos(t), sin(t), -xv(1)*sin(t)+xv(2)*cos(t)
               0       0       1
               ];
        end
        
        function J = Gz(this, xv, z)
        % xv: [x,y,t] robot pose
        %  z: [r, a] measurament
            t = z(2) + xv(3);
            J = [
                1, -xv(1)*sin(t)+xv(2)*cos(t)
                0,  1
                ];
        end
        
        function J = Hw(lan, xv)
            %Landmark.Hx Jacobian dh/dv
            %
            % J = L.Hw(XV) is the Jacobian dh/dv (2x2) at the vehicle
            % state XV (3x1) for the current landmark.
            %
            %  J = L.Hw() as above but take the robot pose from L.robot.
            %
            % See also Landmark.h.
            J = eye(2,2);
        end
        
        function d = euclideanDistance(s1, s2)
            dx = s1.mp(1) - s2.mp(1);
            dy = s1.mp(2) - s2.mp(2);
            d = sqrt(dx^2 + dy^2);
        end
        
        function b = overlap(s1, s2)
            b =  s1.sd <= s2.ed && s1.ed >= s2.sd;
        end
        
        
        function c = collinearity(s, z)
            dr = abs(s.rho-z.rho)/5;
            dt = s.perpendicularity(z);
            c = dr + dt;
            %c = sqrt( (s.rho-z.rho)^2 + (s.theta-z.theta)^2);
        end
        
        function b = isCollinear(s, z)
            b = false;
        end
        
        function update(this, p)
           this.rho = p(1);
           this.theta = p(2);
        end
        
        function c = perpendicularity(s, z)
           c = mod(abs((angdiffd(s.theta,z.theta))),pi/2)/(pi/2);
%            u = [s.a - s.b];
%            v = [z.a - z.b];
%            c = 1 - dot(u,v);
        end
        
        function p = interesection(s, z)
            A = [cos(s.theta) sin(s.theta); cos(z.theta) sin(z.theta)];
            b = [s.rho; z.rho];
            %p = linsolve(A,b);
            p = A\b;
%             f = 1;
%             
%             m = 0.1;
%             
%             if strcmp(s.orientation, 'horizontal')
%                c = 1; 
%             else
%                c = 2;
%             end
%            if p(c) >= s.a(c)-m && p(c) <= s.b(c)+m || ...
%               p(c) >= s.b(c)-m && p(c) <= s.a(c)+m
%                 f = f+1;
%            end
%             if strcmp(z.orientation, 'horizontal')
%                c = 1; 
%             else
%                c = 2;
%             end
%             if p(c) >= z.a(c)-m && p(c) <= z.b(c)+m || ...
%                p(c) >= z.b(c)-m && p(c) <= z.a(c)+m
%                 f = f+1;
%            end
        end
        
        function plot(segments)
            for obj = segments
                
                % Line estimated
                if strcmp(obj.orientation, 'horizontal');
                    xx = [(obj.a(1) - 15) (obj.b(1) + 15)];
                    yy = obj.m*xx + obj.c;
                else
                    yy = [(obj.a(2) - 15) (obj.b(2) + 15)];
                    xx = -(obj.m*yy + obj.c);
                end
%                 line(xx, yy, 'Color', 'c', 'LineStyle', '--');
                % Segment estimated
                line([obj.a(1) obj.b(1)], [obj.a(2) obj.b(2)], 'Color', 'r', 'LineWidth', 1);
                % Naive segment: endpoints
%                 line([obj.p(1,1) obj.p(1,end)], [obj.p(2,1) obj.p(2,end)], 'Color', 'r', 'LineWidth', 1);
                % Hough
%                 x = obj.rho * cos(obj.theta);
%                 y = obj.rho * sin(obj.theta);
%                 line([0 x], [0 y], 'Color', 'b', 'LineStyle', '-.');
                
                % Points
                %plot(obj.p(1,:), obj.p(2,:), 'r*');
            end 
        end
    end
    
end

