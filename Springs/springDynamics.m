function [dx] = springDynamics(t, x, k)
%SPRINGDYNAMICS Summary of this function goes here
%   Detailed explanation goes here

%{
x(1) = x
x(2) = y
x(3) = z
x(4) = x'
x(5) = y'
x(6) = z'

k = spring constant
%}

r_mag = sqrt(x(1)^2 + x(2)^2 + x(3)^2);
r_x = x(1)/r_mag;
r_y = x(2)/r_mag;
r_z = x(3)/r_mag;


dx = [
    x(4)
    x(5)
    x(6)
    -k*r_x
    -k*r_y
    -k*r_z
];

end

