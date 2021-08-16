%%% STARTING STUFF > idk what matlabrc does~
matlabrc; clc; close all;


%%% SIMULATION INFORMATION
% Defining time
dt = 1/30;
duration = 10;
tspan = dt:dt:duration;
L = length(tspan);


%%% OBJECT INFORMATION
% Initial State
x0 = [10;0;0];
v0 = [0;0;5];
initial = [x0; v0];
k = 20;

% Object Properties
mass = 1;
vertices = [-1 -1  -1;
            -1  1 -1;
            1   1  -1;
            1  -1  -1;
            -1 -1  1;
            -1  1 1;
            1   1  1;
            1  -1  1]; % I copied this from Chris's code
faces = [1 2 6 5;
         2 3 7 6;
         3 4 8 7;
         4 1 5 8;
         1 2 3 4;
         5 6 7 8]; % I copied this from Chris's code
color = [0 0.5 0]; % Should be green

% Creating object with shapeT.m class
cube = shapeT(vertices, faces, mass, color);


%%% SOLVING STUFF
options = odeset('RelTol', 1e-9, 'AbsTol', 1e-9*ones(1,6));
[t,x] = ode45(@(t,X) springDynamics(t,X,k), tspan, initial, options);


%%% MAKING ANIMATION
% Plot limits and camera angles
xlabel("X")
ylabel("Y")
zlabel("Z")
xlim([-20 20])
ylim([-20 20])
zlim([-20 20])
view(45,20)

% Actual Animation
for i = 1:L
    p_i = [x(i,1), x(i,2), x(i,3)];
    cube.updateLocation(p_i)
    title(i)
    drawnow
    pause(1/30)
end
