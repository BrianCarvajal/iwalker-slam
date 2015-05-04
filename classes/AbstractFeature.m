classdef AbstractFeature < hgsetget & matlab.mixin.Heterogeneous
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Abstract)
        Xf       % feature state
        Vf       % covariance matrix
        id       % feature identifier. -1 = Anonymous
        updates  % count of updates made with this feature
    end
    
    methods (Abstract)
        z = h(this, Xr)         % observation from robot pose
        J = Hxr(this, Xr)       % jacobian dh/dxr
        J = Hxf(this, Xr)       % jacobian dh/dxf
        J = Hw(this, Xr)        % jacobian dh/dw
        
        J = Gx(this, Xr, z)     % jacobian dg/dxr
        J = Gz(this, Xr, z)     % jacobian dg/dz
        
        d = distance(f1, f2);
    end
    
    methods
        function b = isAnonymous(this)
            b = this.id < 0;
        end
    
    end
    
end

