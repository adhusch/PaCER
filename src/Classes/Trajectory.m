% Trajectory - represents a (straight line) trajectory by two Point3D (entry and target) objects
%
% Andreas Husch
% Centre Hospitalier de Luxembourg, Dep. of Neurosurgery /
% University of Luxembourg - Luxembourg Centre for Systems Biomedicne
% 2014 - 2017
% mail@andreashusch.de, husch.andreas@chl.lu

classdef Trajectory < handle & matlab.mixin.Copyable & MetaTrajectory
    properties
       String = ''; 
    end

    properties (SetObservable = true)
        entryPoint3D = Point3D.empty;
        targetPoint3D = Point3D.empty;
    end

    properties (Access = public, Dependent = true);
        entryPoint = NaN(3,1);
        targetPoint = NaN(3,1);
        direction = NaN(3,1);      
    end
    
    methods
       function str = toString(this)
            if(isempty(this.String))
                str = ['Trajectory Object with target ' num2str(this.targetPoint')];
            else
                str = this.String;
            end
        end
        
        function setEntryPoint3D(this, point3DObj)
            if(isa(point3DObj, 'Point3D'))
                this.entryPoint3D = point3DObj;
                this.notify('trajectoryChanged');
            end
        end
        
        function setTargetPoint3D(this, point3DObj)
            if(isa(point3DObj, 'Point3D'))
                this.targetPoint3D = point3DObj;
                this.notify('trajectoryChanged');
            end
        end
        
        function value = getEntryPoint(this)
            value = this.entryPoint3D.point;
        end
        
        function value = getTargetPoint(this)
            value = this.targetPoint3D.point;
        end
        
        function setEntryPoint(this, point)
            if(isempty(this.entryPoint3D))
                this.entryPoint3D = Point3D();
            end
            this.entryPoint3D.point = point;  
            this.notify('trajectoryChanged');
        end
        
        function setTargetPoint(this, point)
            if(isempty(this.targetPoint3D))
                this.targetPoint3D = Point3D();
            end
            this.targetPoint3D.point = point;
            this.notify('trajectoryChanged');
        end
        
        function direction = getDirection(this)
            %normalized vector from entry to destination
            direction = -((this.entryPoint3D.point - this.targetPoint3D.point) / norm(this.entryPoint3D.point - this.targetPoint3D.point));
        end
    end
end