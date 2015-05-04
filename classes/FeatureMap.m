classdef FeatureMap < hgsetget
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        features
        segments
        corners     
    end
    
    properties (Access = private)
       nextID; 
    end
    
    methods
        
        function this = FeatureMap()
            this.nextID = 1;
        end
        
        function addFeature(this, feature)
           if ~isa(feature, 'AbstractFeature')
              error('feature must be an AbstractFeature'); 
           end
           
           feature.id = this.nextID;
           this.nextID = this.nextID + 1;
           this.features = [this.features feature];
           
           if isa(feature, 'CornerFeature')
               this.corners = [this.corners feature];
           else
               this.segments = [this.segments feature];
           end
        end
        
        function deleteFeature(this, feature)
            feature.delete();
            if ~isempty(this.features)
                this.features = this.features(isvalid(this.features));
            end
            if ~isempty(this.segments)
                this.segments = this.segments(isvalid(this.segments));
            end
            if ~isempty(this.corners)
                this.corners = this.corners(isvalid(this.corners)); 
            end
        end
        
    end
    
end

