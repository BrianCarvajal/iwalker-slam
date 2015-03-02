classdef (ConstructOnLoad) iWalkerEventData < event.EventData
    %IWALKEREVENTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Data
    end
    
    methods
        function ed = iWalkerEventData(data)
           ed.Data = data; 
        end
    end
    
end

