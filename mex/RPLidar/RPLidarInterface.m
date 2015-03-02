%CLASS_INTERFACE Example MATLAB class wrapper to an underlying C++ class
classdef RPLidarInterface < handle
    properties (SetAccess = private, Hidden = true)
        objectHandle; % Handle to the underlying C++ class instance
    end
    methods
        %% Constructor - Create a new C++ class instance 
        function this = RPLidarInterface()
            this.objectHandle = rplidar_mex('new');
        end
        
        %% Destructor - Destroy the C++ class instance
        function delete(this)
            rplidar_mex('delete', this.objectHandle);
        end
        
        function success = connect(this, port)
            success = rplidar_mex('connect', this.objectHandle, port);
        end
        
        function [freq, count, range, angle] = getScan(this)
            [freq, count, range, angle] = rplidar_mex('getScan', this.objectHandle);
        end
        
    end
end