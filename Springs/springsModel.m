%%% STARTING STUFF > idk what matlabrc does~
matlabrc; clc; close all;


%%% SIMULATION INFORMATION
% Defining time
dt = 1/30;
duration = 30;
tspan = dt:dt:duration;
L = length(tspan);


%%% SPRING-MASS INFORMATION
% Spring-Mass Object Information
m = [1 1 1 1 1 1 1 1];
k = [5 5 10 10 15 15 20 20];
s = [ % Initial conditions for all the springs
    5 -5 5 -5 5 -5 5 -5;    % Initial Position
    0 0 0 0 0 0 0 0;        % Initial Velocity
    0 0 0 0 0 0 0 0;        % Initial Acceleration (leave this as zero)
];
h = [-7 -5 -3 -1 1 3 5 7];

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
         5 6 7 8]; % Corresponding faces to vertices
color = [0 0.5 0]; % green

% Creating Spring-Mass Objects
numCubes = length(m); % uses mass but all of those should be the same size
cube = cubeSpring.empty(numCubes,0); % FIGURE OUT HOW TO CREATE EMPTY OBJECT ARRAYS
for a = 1:numCubes
    cube(a) = cubeSpring(m(1, a), k(1, a), h(1, a), s(1, a),tspan,...
                         vertices, faces, color);
end


%%% SOLVING SPRING-MASS DYNAMICS
options = odeset('RelTol', 1e-9, 'AbsTol', 1e-9*ones(1,3));
for b = 1:numCubes
    cube(b).solveSpringDynamics(tspan, options);
    %%% Research paper uses s" for some of the computation and equations
    %%% Using m*s" = -k*s (equations of motion for spring-mass systems)
    %%% we can get s" easily from the solution provided by ode45
    %%% To implement, edit line to >> x = zeros(L,2,numCubes);
    %%% And this has to be >> [t, x(:,1:2,b)] = ode45(...);
    %%% And then [x(:,3,b] = -k*x(:)/m;
    %%% x(:,1,b) is position for object b, x(:,2,b) is velocity for object
    %%% Now x(:,3,b) is the acceleration for object b
    % Preferably make these edits in springModelDynamics.m
end


%%% MAKING ANIMATION
% Plot limits and camera angles
xlabel("X")
ylabel("Y")
zlabel("Z")
xlim([-10 10])
ylim([-10 10])
zlim([-10 10])
view(45,20)

% Actual Animation
for c = 1:L
    for d = 1:numCubes
        cube(d).updateLocation(cube(d).s(c, 1))
    end
    title(c)
    drawnow
    pause(1/30)
end


%%% Rotating tank stuff
% m = 1;
% b = 1;
% 
% I_h = I + I0 + m*b^2 + cubesInertia;


%%% NOTE: FIGURE OUT HOW TO ADD TANK AND OTHER PARAMETERS TO PHYSICS
%%% NOT SURE IF THIS IS A 3-D PROBLEM, CURRENTLY IT IS A 2-D PROBLEM
%%% ASK BURLION WHETHER I NEED TO FIGURE OUT 3-D SPRINGS AND RELATED

