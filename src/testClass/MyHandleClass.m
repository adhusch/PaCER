classdef MyHandleClass < handle & my.super.Class
    % a handle class
    %
    % Parameters: 
    %
    %    a variable:     somethin something
    %

    properties
        x % a property
    end
    methods
        function h = MyHandleClass(x)
            h.x = x
        end
        function x = get.x(obj)
            x = obj.x
        end
    end
    methods (Static)
        function w = my_static_function(z)
        % A static function in :class:`MyHandleClass`.
        %
        % Parameters: 
        %
        %    z:     something
        %
        % Returns:
        %
        %    w:     something else

            w = z
        end
    end
end

%% .. Authors:
    %% - Andreas Husch, Original File
    %% - Daniel Duarte Tojal, Documentation
