classdef shapeM < handle
    %SHAPEM stores a shape and its properties
    %   Used for modelling translational and rotational motion
    
    properties
        verticesR   % List of vertices for ROTATION (matrix)
        verticesL   % List of vertices for LOCATION (matrix)
        faces       % List of faces (matrix)
        location    % Location of shape (matrix)
        mass        % Mass (scalar)
        inertia     % 1x3 with xx, yy, and zz inertia
        color       % Color matrix (0-1 > RGB)
                
        h           % handle
    end
    
    methods (Access = public)
        function [obj] = shapeM(vertices, faces, location,...
                mass, inertia, color)
            %%% SHAPEM
            % Construct an instance of this class
            obj.verticesR = vertices;
            obj.verticesL = bsxfun(@plus, vertices, location');
            obj.faces = faces;
            obj.location = location;
            obj.mass = mass;
            obj.inertia = inertia;
            obj.color = color;
            
            obj.draw();
        end
        
        function [] = updateAttitudeLocation(obj, rotmat, locmat)
            %%% UPDATE ATTITUDE AND LOCATION
            % Apply rotation to verticesR and update verticesL
            vR_new = (rotmat*obj.verticesR')';
            % set(obj.h, 'Vertices', vR_new);
            
            vL_new = vR_new + locmat;
            set(obj.h, 'Vertices', vL_new);
        end
        
        function [] = draw(obj)
            % Draw the object with current values
            obj.h = patch('Faces', obj.faces, 'Vertices', obj.verticesL,...
                          'FaceColor', obj.color);
            axis equal
            grid on
            rotate3d on
        end
    end
end
