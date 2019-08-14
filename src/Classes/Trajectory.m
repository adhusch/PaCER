classdef Trajectory < handle & matlab.mixin.Copyable & MetaTrajectory
% Trajectory - represents a (straight line) trajectory by two Point3D (entry and target) objects

    properties
       String = ''; % An empty starting string
    end

    properties (SetObservable = true)
        entryPoint3D = Point3D.empty; %3D entry point of the trajectory
        targetPoint3D = Point3D.empty; %3D target point of the trajectory
    end

    properties (Access = public, Dependent = true);
        entryPoint = NaN(3,1); % Public entry point property of the class
        targetPoint = NaN(3,1); % Public target point property of the class
        direction = NaN(3,1); % Public direction property of the class
    end
    
    methods
       function str = toString(this)
        % Function that sets the info message for feedback
        %
        % Parameters:
        %
        %    this:      Self-reference
        %
        % Returns:
        %
        %    str:       String that returns text when target point is set
        %               or stays empty if not.

            if(isempty(this.String))
                str = ['Trajectory Object with target ' num2str(this.targetPoint')];
            else
                str = this.String;
            end
        end
        
        function setEntryPoint3D(this, point3DObj)
        %

            if(isa(point3DObj, 'Point3D'))
                this.entryPoint3D = point3DObj;
                this.notify('trajectoryChanged');
            end
        end
        
        function setTargetPoint3D(this, point3DObj)
        %

            if(isa(point3DObj, 'Point3D'))
                this.targetPoint3D = point3DObj;
                this.notify('trajectoryChanged');
            end
        end
        
        function value = getEntryPoint(this)
        %

            value = this.entryPoint3D.point;
        end
        
        function value = getTargetPoint(this)
        %

            value = this.targetPoint3D.point;
        end
        
        function setEntryPoint(this, point)
        %

            if(isempty(this.entryPoint3D))
                this.entryPoint3D = Point3D();
            end
            this.entryPoint3D.point = point;  
            this.notify('trajectoryChanged');
        end
        
        function setTargetPoint(this, point)
        %

            if(isempty(this.targetPoint3D))
                this.targetPoint3D = Point3D();
            end
            this.targetPoint3D.point = point;
            this.notify('trajectoryChanged');
        end
        
        function direction = getDirection(this)
        % Function to give a normalized vector from entry to destination
        
            direction = -((this.entryPoint3D.point - this.targetPoint3D.point) / norm(this.entryPoint3D.point - this.targetPoint3D.point));
        end
    end
end

% .. AUTHORS:
%       - Andreas Husch, Original File
%       - Daniel Duarte Tojal, Documentation