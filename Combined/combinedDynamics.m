function [dx] = combinedDynamics(t,x,I,k)
%%% COMBINEDDYNAMICS
% Combined spring and rotational dynamics

% OVERALL STRUCTURE
%{
x(1:3) > x y z
x(4:6) > x' y' z'
x(7:10) > quaternions
x(11:13) > angular velocities

I = inertia
k = spring constant
%}

%%% ROTATION DYNAMICS
% Setup of quaternions and omega
q = x(7:10);
w = x(11:13);

% Euler rotational dynamics:
dw = I\(-1*cpm(w)*I*w);

% Quaternion kinematic equations:
Bq = zeros(4,3);
Bq(1:3,:) = cpm(q(1:3)) + diag([q(4), q(4), q(4)]);
Bq(4,:) = -q(1:3);
dq = (1/2)*Bq*w;

% Output of rotation dynamics
dROT = [dq; dw];


%%% POSITION DYNAMICS
% Position values and components
r_mag = sqrt(x(1)^2 + x(2)^2 + x(3)^2);
r_x = x(1)/r_mag;
r_y = x(2)/r_mag;
r_z = x(3)/r_mag;

% Output of position dynamics
dPOS(1:3) = x(4:6);
dPOS(4:6) = -k*[r_x; r_y; r_z];

%%% FINAL OUTPUT
dx = [dPOS'; dROT];

end

