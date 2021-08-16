%%% STARTING STUFF > idk what matlabrc does~
matlabrc; clc; close all;


%%% SIMULATION INFORMATION
% Defining time
dt = 1/30;
duration = 30;
tspan = dt:dt:duration;
L = length(tspan);


%%% OBJECT INFORMATION
% Object Properties
mass = 1;
k = 20;
inertia = diag([1 1 1]);
% I copied this from Chris's code
vertices = [-1 -1  -1;
            -1  1 -1;
            1   1  -1;
            1  -1  -1;
            -1 -1  1;
            -1  1 1;
            1   1  1;
            1  -1  1]; % Assumes center is the origin
faces = [1 2 6 5;
         2 3 7 6;
         3 4 8 7;
         4 1 5 8;
         1 2 3 4;
         5 6 7 8];
color = [0 0.5 0]; % green

% Location Initial State
x0 = [10;10;0];
v0 = [0;0;0];
pos0 = [x0; v0];

% Rotation Initial State
w0 = [0;0;3]; % w0 = randn(3,1); 
q0 = [0;0;0;1];
rot0 = [q0; w0];

% Initial State
% Structure > 3 position, 3 velocity, 4 quaternions, 3 omegas
init0 = [pos0; rot0];

% Creating object with shape.m class
advancedCube = shapeM(vertices, faces, x0, mass, inertia, color);


%%% SOLVING STUFF
options = odeset('RelTol', 1e-9, 'AbsTol', 1e-9*ones(1,13));
[t,x] = ode45(@(t,x) combinedDynamics(t,x,inertia,k), tspan, init0, options);


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
    q_i = x(i, 7:10);
    rotmat = q2a(q_i);
    locmat = x(i, 1:3);
    advancedCube.updateAttitudeLocation(rotmat, locmat)
    title(i)
    drawnow
    pause(1/30)
end