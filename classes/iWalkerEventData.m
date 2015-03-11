classdef (ConstructOnLoad) iWalkerEventData < event.EventData
    %IWALKEREVENTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Data
        Timestamp
        DeltaTime
    end
    
    methods
        function ed = iWalkerEventData(data, ts, dt)
           ed.Data = data; 
           ed.Timestamp = ts;
           ed.DeltaTime = dt;
        end
    end
    
end

