classdef cubeSpring < handle
    %%% CUBESPRING
    % Creating small cubes for Burlion NonLinear Slosh Model
    
    properties
        m       % mass of the cube
        k       % spring stiffness
        h       % horizontal distance from center of tank
        s       % displacement from equillibrium
        t       % Time span for cube (tspan)

        vertices    % vertices (expecting a 2x2x2 cube)
        faces       % faces (values based on vertices)
        color       % RBG matrix from 0-1
                
        handle      % handle
    end
    
    methods (Access = public)
        function obj = cubeSpring(m, k, h, s, tspan, v, f, c)
            %CUBESPRING Construct an instance of this class
            % Adding model parameters
            obj.m = m;
            obj.k = k;
            obj.h = h;
            L = length(tspan);
            obj.t = zeros(L, 1);
            obj.s = zeros(L, 3);
            obj.s(1, :) = s;
            
            % Adding properties to draw with
            v_temp = v;
            v_temp(:,2) = v_temp(:,2) + h;
            obj.vertices = v_temp;
            obj.faces = f;
            obj.color = c;
            
            % Drawing the cube
            obj.draw();
        end
        
        function [] = updateLocation(obj,loc)
            %%% UPDATELOCATION
            % Update location with a new position matrix
            v_temp = obj.vertices;
            v_temp(:,1) = v_temp(:,1) + loc;
            % disp(obj.vertices)
            % disp(obj.faces)
            set(obj.handle, 'Vertices', v_temp);
        end
        
        function [] = draw(obj)
            obj.handle = patch('Faces', obj.faces, 'Vertices', obj.vertices,...
                               'FaceColor', obj.color);
            axis equal
            grid on
            rotate3d on
        end
        
        function [] = solveSpringDynamics(obj, tspan, options)
            [obj.t, x] = ode45(@(t,x)springModelDynamics(t, x, obj.m, obj.k),...
                                     tspan, obj.s(1, :), options);
            obj.s = [x(:, 1), x(:, 2), -obj.k*obj.s(:, 1)/obj.m];
        end
    end
end

