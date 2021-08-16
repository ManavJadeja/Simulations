classdef shapeT < handle
    %SHAPET stores a shape and its properties
    
    properties
        vertices    % Matrix with list of vertices
        faces       % Matrix with list of faces
        mass        % Scalar mass
        color       % 1x3 color matrix (0-1 for RGB)
                
        h           % handle
    end
    
    methods (Access = public)
        function obj = shapeT(vertices, faces, mass, color)
            %SHAPET Construct an instance of this class
            obj.vertices = vertices;
            obj.faces = faces;
            obj.mass = mass;
            obj.color = color;
            
            obj.draw();
        end
        
        function [] = updateLocation(obj, locmat)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            v_new = locmat+obj.vertices;
            set(obj.h, 'Vertices', v_new);
        end
        
        function [] = draw(obj)
            obj.h = patch('Faces', obj.faces, 'Vertices', obj.vertices,...
                          'FaceColor', obj.color);
            axis equal
            grid on
            rotate3d on
        end
    end
end

