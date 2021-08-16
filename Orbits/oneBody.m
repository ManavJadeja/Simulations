function dx = oneBody(t, x, C)

%{
% 'x' vector layout
x(1) = x
x(2) = y
x(3) = z
x(4) = x'
x(5) = y'
x(6) = z'

% constants to know
C(1) = m_E          % mass of the earth
C(2) = G            % gravitational constant
%}

r_mag = sqrt( (x(1)^2) + (x(2)^2) + (x(3)^2) ); % position magnitude
r_x = x(1)/r_mag;
r_y = x(2)/r_mag;
r_z = x(3)/r_mag;

F = C(2)*C(1)/(r_mag^2);


dx = [
    x(4);
    x(5);
    x(6);
    -F*r_x;
    -F*r_y;
    -F*r_z;
];

end