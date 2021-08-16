function [dx] = springModelDynamics(t,x,m,k)
%%% SPRINGMODELDYNAMICS
% Spring dynamics (really simple stuff~)

dx = zeros(3,1);
dx(1) = x(2);
dx(2) = -k*x(1)/m;

end

