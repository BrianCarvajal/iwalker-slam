%CANUSBInterface MATLAB class wrapper to an underlying C++ class
classdef CANUSBInterface < handle
    properties (SetAccess = private, Hidden = true)
        objectHandle; % Handle to the underlying C++ class instance
    end
    methods
        %% Constructor - Create a new C++ class instance and connect the device
        function this = CANUSBInterface()
            this.objectHandle = CANUSBInterface_mex('new');
        end
        
        %% Destructor - Destroy the C++ class instance and disconnect the device
        function delete(this)
            CANUSBInterface_mex('delete', this.objectHandle);
        end
        
        function success = connect(this)
            success = CANUSBInterface_mex('connect', this.objectHandle);
        end
        
        function success = disconnect(this)
            success = CANUSBInterface_mex('disconnect', this.objectHandle);
        end
        
        %% Read - Read the frame with the given [id]
        function data = read(this, id)
            data = CANUSBInterface_mex('read', this.objectHandle, uint32(id));
        end
        
        %% Write - Write to frame [id] the first [dlc] bytes in [data]
        function write(this, id, dlc, data)
            CANUSBInterface_mex('write', this.objectHandle, ...
                                uint32(id), uint8(dlc), uint8(data));
        end
    end
end