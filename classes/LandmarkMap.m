%LandmarkMap SLAM's map of landmark class
%
%   This class represents the landmark map used in SLAM algorithms.
%
%   Methods:
%
%   Static methods
%
%   Properties

%
%   Examples:

classdef LandmarkMap < handle
    
    properties
        name
        landmarks
    end
    
    methods
        
        function map = LandmarkMap(name)
            if nargin < 1
                error('The map need a name')
            end
            if ~ischar(name)
                error('The name must be a string');
            end
            if nargin < 2
                landmarks = [];
            elseif ~isempty(landmarks) && ~isa(landmarks, 'Landmark')
                error('landmarks must be Lanmdark objects');
            end
            map.name = name;
            %map.landmarks = QuadTreeNode(0, 0, 10);
            map.landmarks = [];

        end
        
        function addLandmarks(map, lans)
           for lan = lans
               n = length(map.landmarks);
               lan.id = n + 1;
               if n == 0
                   map.landmarks = lan;
               else
                   map.landmarks(n+1) = lan;
               end              
           end
        end
        
        function [v, i] = bestMatch(map, lan)
            s = zeros(length(map.landmarks), 1);
            for k = 1: length(map.landmarks)
                
                s(k) = lan.sameness(map.landmarks(k));
            end
            %s = lan.sameness(features);
            [v, i] = min(s);
        end
        
        function b = containsLandmark(map, lan, max_dist)
            if isempty(map.landmarks)
                b = false;
            else
                [dist, id] = map.bestMatch(lan);
                if dist < max_dist
                    lan.id = id;
                    lan.matched_landmark = map.landmarks(id);
                    b = true;
                else
                    b = false;
                end
            end
        end
    end
    
    
    
    
    
    
end

