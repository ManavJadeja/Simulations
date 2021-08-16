%%% Clearing current stuff
clc, clear

%%% DRAWING GLOBE

space_color = 'k';
npanels = 180;   % Number of globe panels around the equator deg/panel = 360/npanels
alpha   = 1; % globe transparency level, 1 = opaque, through 0 = invisible
%GMST0 = []; % Don't set up rotatable globe (ECEF)
GMST0 = 4.89496121282306; % Set up a rotatable globe at J2000.0

image_file = 'http://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Land_ocean_ice_2048.jpg/1024px-Land_ocean_ice_2048.jpg';

% Mean spherical earth
erad    = 6371008.7714;         % equatorial radius (meters)
prad    = 6371008.7714;         % polar radius (meters)
erot    = 7.2921158553e-5;      % earth rotation rate (radians/sec)

figure('Color', space_color);
hold on;
set(gca, 'NextPlot','add', 'Visible','off');
axis equal;
axis auto;
view(0,30);
axis vis3d;

% Create a 3D meshgrid of the sphere points using the ellipsoid function
[x, y, z] = ellipsoid(0, 0, 0, erad, erad, prad, npanels);
globe = surf(x, y, -z, 'FaceColor', 'none', 'EdgeColor', 0.5*[1 1 1]);
rotate(globe, [0 0 1], 90);
if ~isempty(GMST0)
    hgx = hgtransform;
    set(hgx,'Matrix', makehgtform('zrotate',GMST0));
    set(globe,'Parent',hgx);
end

% Load Earth image for texture map
cdata = imread(image_file);

set(globe, 'FaceColor', 'texturemap', 'CData', cdata, 'FaceAlpha', alpha, 'EdgeColor', 'none');
ax = gca;

%%% ADDING AN ORBIT (from Untitled005.m and oneBody.m)
% Constant Properties
R_E = 6.371E6;                  % radius of the earth (m)
m_E = 5.972E24;                 % mass of the earth (kg)
G = 6.6741E-11;                 % gravitational constant (m^3 kg^-1 s^-2
alt = 5E5;                      % altitude of satellite (m)
e_rot = 7.2921158553e-5;        % earth rotation rate (radians/sec)

% Time related constants
dt = 1;                         % time step (s)
t_start = 0;                    % start time
t_stop = 6000;                  % stop time
tspan = t_start:dt:t_stop-1;    % time span

% Constant Vector
c = [
    m_E;        % mass of the earth
    G;          % gravitational constant
    e_rot;      % earth rotation speed
];

% initial conditions
x0 = [
    0;                % x0
    R_E+alt;                      % y0
    0;                      % z0
    sqrt(G*m_E/(R_E+alt));                      % vx_0
    0;                      % vy_0
    0;  % vz_0
];

%%% INsert kleplar to carts here

options = odeset('RelTol',1e-10,'AbsTol',1e-10*ones(1,6));
[t,x] = ode45(@(t,x)oneBody(t,x,c), tspan, x0, options);
% add ", options" if you want error stuff

%%% PLOTTING / ANIMATION

% SIMPLE PLOT3
plot3(x(:,1), x(:,2), x(:,3), '-r', 'LineWidth', 1.5)
% set(gca,'color','k','xcolor','w','ycolor','w','zcolor','w');
% set(gcf,'color','k')

% COMET FUNCTION
% comet3(ax, x(:,1), x(:,2), x(:,3), 1E-2)

% ANIMATED LINE
% h = animatedline('Color','r','LineWidth',2);

% ANIMATED POINT
h = plot3(x(1,1), x(1,2), x(1,3), 'r.', 'MarkerSize', 20);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);

lim = 1.5*R_E;
set(ax, 'XLim', [-lim lim], 'YLim', [-lim lim], 'ZLim', [-lim lim]);

% v = VideoWriter('orbit.mp4', 'MPEG-4');
% v.Quality = 100;
% v.FrameRate = 60;
% open(v);

for i = 1:10:t_stop-1
    set(h, 'XData', x(i,1), 'YData', x(i,2), 'ZData', x(i,3));
    rotate(globe, [0 0 1], dt);
    drawnow;
    % frame = getframe(gcf);
    % writeVideo(v, frame);
    pause(0.1);
end

% close(v);

% All done
disp("DONE")
