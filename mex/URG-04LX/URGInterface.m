%CLASS_INTERFACE Example MATLAB class wrapper to an underlying C++ class
classdef URGInterface < handle
    properties %(SetAccess = private, Hidden = true)
        objectHandle; % Handle to the underlying C++ class instance
    end
    methods
        %% Constructor - Create a new C++ class instance 
        function this = class_interface(varargin)
            this.objectHandle = class_interface_mex('new', varargin{:});
        end
        
        %% Destructor - Destroy the C++ class instance
        function delete(this)
            class_interface_mex('delete', this.objectHandle);
        end
        
        %% Connect - Connect the device at [port]
        function success = connect(this, port)
            success = class_interface_mex('connect', this.objectHandle, port);
        end
        
        %% Disconnect - Connect the device at [port]
        function success = disconnect(this)
            success = class_interface_mex('disconnect', this.objectHandle);
        end

        %% GetScan - Get [range] data from the lidar in mm
        function range = getScan(this, varargin)
            range = class_interface_mex('getScan', this.objectHandle);
        end


    end
end