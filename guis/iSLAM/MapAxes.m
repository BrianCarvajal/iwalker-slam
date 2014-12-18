classdef MapAxes < hgsetget
    
    properties
        Parent
        hAxes
        plotter
        sim
    end
    
    methods
        function obj = MapAxes(varargin)
            % Set default property values
            obj.Parent = [];
            obj.sim = [];
            
            % Set user-supplied property values
            if nargin > 0
                set( obj, varargin{:} );  
            end
            
            if isempty(obj.Parent)
                obj.hAxes = axes();
            else
                obj.hAxes = axes('Parent', obj.Parent);
            end
            
            set(obj.hAxes, 'LooseInset', get(obj.hAxes,'TightInset'));
            
            obj.plotter = Plotter(obj.hAxes);
        end
    end
    
end

