classdef Trajectory < handle & matlab.mixin.Copyable & MetaTrajectory
    % Trajectory - represents a (straight line) trajectory by two Point3D (entry and target) objects
    %
    % Parameters:
    %
    %    Something:     

    properties
       String = ''; % A Property of String
    end

    properties (SetObservable = true)
        entryPoint3D = Point3D.empty; % A property of entrypoint3D
        targetPoint3D = Point3D.empty; % A property of targetpoint3D
    end

    properties (Access = public, Dependent = true); 
        entryPoint = NaN(3,1); % A property of entryPoint
        targetPoint = NaN(3,1); % A property of targetPoint
        direction = NaN(3,1); % A property of direction
    end
    
    methods
       function str = toString(this)
        % --Description of the function goes here
        %
        % Parameters:
        %
        %    this:      
        %
        % Returns:
        %
        %    str:       
        %
            if(isempty(this.String))
                str = ['Trajectory Object with target ' num2str(this.targetPoint')];
            else
                str = this.String;
            end
        end
        
        function set.entryPoint3D(this, point3DObj)
        % --Description of the function goes here
        %
        % Parameters:
        %
        %    this:          
        %    point3DObj:    
        %
        % Returns:
        %
        %    output goes here
        %
            if(isa(point3DObj, 'Point3D'))
                this.entryPoint3D = point3DObj;
                this.notify('trajectoryChanged');
            end
        end
        
        function set.targetPoint3D(this, point3DObj)
        % --Description of the function goes here
        %
        % Parameters:
        %
        %    this:          
        %    point3DObj:    
        %
        % Returns:
        %
        %    output goes here
        %
            if(isa(point3DObj, 'Point3D'))
                this.targetPoint3D = point3DObj;
                this.notify('trajectoryChanged');
            end
        end
        
        function value = get.entryPoint(this)
        % --Description of the function goes here
        %
        % Parameters:
        %
        %    this:      
        %
        % Returns:
        %
        %    value:     
        %
            value = this.entryPoint3D.point;
        end
        
        function value = get.targetPoint(this)
        % --Description of the function goes here
        %
        % Parameters:
        %
        %    this:      
        %
        % Returns:
        %
        %    value:     
        %
            value = this.targetPoint3D.point;
        end
        
        function set.entryPoint(this, point)
        % --Description of the function goes here
        %
        % Parameters:
        %
        %    str:   
        %
        % Returns:
        %
        %    output goes here
        %
            if(isempty(this.entryPoint3D))
                this.entryPoint3D = Point3D();
            end
            this.entryPoint3D.point = point;  
            this.notify('trajectoryChanged');
        end
        
        function set.targetPoint(this, point)
        % --Description of the function goes here
        %
        % Parameters:
        %
        %    this:      
        %    point:     
        %
        % Returns:
        %
        %    output goes here
        %
            if(isempty(this.targetPoint3D))
                this.targetPoint3D = Point3D();
            end
            this.targetPoint3D.point = point;
            this.notify('trajectoryChanged');
        end
        
        function direction = get.direction(this)
        % Normalized vector from entry to destination
        %
        % Parameters:
        %
        %    this:          
        %
        % Returns:
        %
        %    direction:     
        %
            direction = -((this.entryPoint3D.point - this.targetPoint3D.point) / norm(this.entryPoint3D.point - this.targetPoint3D.point));
        end
    end
end

% .. AUTHORS:
%       - Andreas Husch, Original File
%       - Daniel Duarte Tojal, Documentation